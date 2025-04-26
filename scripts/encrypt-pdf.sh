#!/bin/bash
# This script uses qpdf to encrypt a file.
#
# usage: encrypt-pdf.sh file-to-encrypt.pdf output-name.pdf

if [ $# -ne 2 ]; then
  echo "usage: encrypt-pdf.sh file-to-encrypt.pdf output-file.pdf"
  exit 1
fi

echo "enter password: "
read -rs pw

qpdf --encrypt "$pw" "$pw" 256 -- "$1" "$2"
