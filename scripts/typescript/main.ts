import { exec } from 'child_process';
import * as fs from 'fs';
import * as yaml from 'js-yaml';
import * as os from 'os';
import * as path from 'path';
import { promisify } from 'util';

const execAsync = promisify(exec);

interface Kubeconfig {
  apiVersion: string;
  clusters: any[];
  contexts: any[];
  'current-context': string;
  kind: string;
  preferences: any;
  users: any[];
}

interface ClusterInfo {
  name: string;
  id: string;
}

async function main() {
  // Define the path for the final merged kubeconfig file
  const rancherConfigFile = process.env.RANCHER_CONFIG_FILE || path.join(os.homedir(), '.kube', 'rancher-clusters.yaml');

  try {
    // Get the list of clusters from rancher
    const { stdout: clusterOutput } = await execAsync("rancher cluster ls --format '{{.Cluster.Name}},{{.Cluster.ID}}'");

    const clusters: ClusterInfo[] = clusterOutput
      .trim()
      .split('\n')
      .map(line => {
        const [name, id] = line.split(',');
        return { name, id };
      })
      .filter(cluster => cluster.name !== 'local');

    console.log(`Found ${clusters.length} clusters in rancher.`);

    console.log('Fetching kubeconfigs for all clusters...');

    // Fetch kubeconfigs in parallel
    const kubeconfigs = await Promise.all(
      clusters.map(async (cluster) => {
        console.log(`Fetching kubeconfig for cluster: ${cluster.name}`);
        const { stdout: kubeconfigYaml } = await execAsync(`rancher clusters kubeconfig ${cluster.id} ${cluster.name}`);
        return yaml.load(kubeconfigYaml) as Kubeconfig;
      })
    );

    console.log('All kubeconfigs downloaded. Merging them to single file');

    // Merge kubeconfigs
    const mergedKubeconfig: Kubeconfig = {
      apiVersion: 'v1',
      kind: 'Config',
      preferences: {},
      clusters: [],
      users: [],
      contexts: [],
      'current-context': kubeconfigs.length > 0 ? kubeconfigs[0]['current-context'] : '',
    };

    for (const kubeconfig of kubeconfigs) {
      mergedKubeconfig.clusters.push(...kubeconfig.clusters);
      mergedKubeconfig.users.push(...kubeconfig.users);
      mergedKubeconfig.contexts.push(...kubeconfig.contexts);
    }

    // Save the merged kubeconfig to the file
    const mergedYaml = yaml.dump(mergedKubeconfig);
    fs.writeFileSync(rancherConfigFile, mergedYaml);

    console.log(`Successfully merged all kubeconfigs to ${rancherConfigFile}`);

  } catch (error) {
    console.error('An error occurred:', error);
    process.exit(1);
  }
}

main();