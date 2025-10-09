package main

import (
	"encoding/csv"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"

	"gopkg.in/yaml.v3"
)

// Kubeconfig represents the structure of a Kubernetes config file.
// Using interface{} for some fields to avoid defining the full complex structure.
type Kubeconfig struct {
	APIVersion     string        `yaml:"apiVersion"`
	Clusters       []interface{} `yaml:"clusters"`
	Contexts       []interface{} `yaml:"contexts"`
	CurrentContext string        `yaml:"current-context"`
	Kind           string        `yaml:"kind"`
	Preferences    interface{}   `yaml:"preferences"`
	Users          []interface{} `yaml:"users"`
}

// ClusterInfo holds the name and ID of a Rancher cluster.
type ClusterInfo struct {
	Name string
	ID   string
}

func main() {
	// Define the path for the final merged kubeconfig file
	rancherConfigFile := os.Getenv("RANCHER_CONFIG_FILE")
	if rancherConfigFile == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			log.Fatalf("failed to get user home directory: %v", err)
		}
		rancherConfigFile = filepath.Join(home, ".kube", "rancher-clusters.yaml")
	}

	// Get the list of clusters from rancher
	cmd := exec.Command("rancher", "cluster", "ls", "--format", "{{.Cluster.Name}},{{.Cluster.ID}}")
	output, err := cmd.Output()
	if err != nil {
		log.Fatalf("failed to list rancher clusters: %v\n%s", err, output)
	}

	// Parse the CSV output
	r := csv.NewReader(strings.NewReader(string(output)))
	records, err := r.ReadAll()
	if err != nil {
		log.Fatalf("failed to parse cluster list: %v", err)
	}

	var clusters []ClusterInfo
	for _, record := range records {
		if len(record) == 2 && record[0] != "local" {
			clusters = append(clusters, ClusterInfo{Name: record[0], ID: record[1]})
		}
	}

	fmt.Printf("Found %d clusters in rancher.\n", len(clusters))

	fmt.Println("Fetching kubeconfigs for all clusters...")

	// Fetch kubeconfigs in parallel
	var wg sync.WaitGroup
	kubeconfigsChan := make(chan *Kubeconfig, len(clusters))

	for _, cluster := range clusters {
		wg.Add(1)
		go func(cluster ClusterInfo) {
			defer wg.Done()
			fmt.Printf("Fetching kubeconfig for cluster: %s\n", cluster.Name)
			cmd := exec.Command("rancher", "clusters", "kubeconfig", cluster.ID, cluster.Name)
			kubeconfigYAML, err := cmd.Output()
			if err != nil {
				log.Printf("failed to fetch kubeconfig for cluster %s: %v", cluster.Name, err)
				return
			}

			var kubeconfig Kubeconfig
			if err := yaml.Unmarshal(kubeconfigYAML, &kubeconfig); err != nil {
				log.Printf("failed to unmarshal kubeconfig for cluster %s: %v", cluster.Name, err)
				return
			}
			kubeconfigsChan <- &kubeconfig
		}(cluster)
	}

	wg.Wait()
	close(kubeconfigsChan)

	fmt.Println("All kubeconfigs downloaded. Merging them to single file")

	// Merge kubeconfigs
	mergedKubeconfig := Kubeconfig{
		APIVersion:  "v1",
		Kind:        "Config",
		Preferences: map[string]interface{}{},
	}

	first := true
	for kubeconfig := range kubeconfigsChan {
		if first {
			mergedKubeconfig.CurrentContext = kubeconfig.CurrentContext
			first = false
		}
		mergedKubeconfig.Clusters = append(mergedKubeconfig.Clusters, kubeconfig.Clusters...)
		mergedKubeconfig.Users = append(mergedKubeconfig.Users, kubeconfig.Users...)
		mergedKubeconfig.Contexts = append(mergedKubeconfig.Contexts, kubeconfig.Contexts...)
	}

	// Save the merged kubeconfig to the file
	mergedYAML, err := yaml.Marshal(&mergedKubeconfig)
	if err != nil {
		log.Fatalf("failed to marshal merged kubeconfig: %v", err)
	}

	if err := ioutil.WriteFile(rancherConfigFile, mergedYAML, 0644); err != nil {
		log.Fatalf("failed to write merged kubeconfig to file: %v", err)
	}

	fmt.Printf("Successfully merged all kubeconfigs to %s\n", rancherConfigFile)
}