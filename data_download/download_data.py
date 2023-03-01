import os
import pandas as pd
import re
import subprocess
import sys

from xml.etree import ElementTree

# Read in command line args

if len(sys.argv) < 2:
    raise ValueError("Please specify a download path.")

if len(sys.argv) > 3:
    raise ValueError("Too many arguments passed.")

download_path = sys.argv[1]
if not os.path.isdir(download_path):
    raise ValueError(f"Download directory '{download_path}' does not exist. Please create it first.")

if len(sys.argv) == 3:
    num_download = int(sys.argv[2])
else:
    num_download = None

# Execute a series of bash commands using pipes to query the SRA for the accession numbers we want

print("Querying SRA for monkeypox accessions...")

query_res = subprocess.Popen(['esearch', '-db', 'sra', '-query', 'monkeypox[All Fields] AND "Monkeypox virus"[orgn] AND (cluster_public[prop] AND "biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "strategy wgs"[Properties] OR "strategy wga"[Properties] OR "strategy wcs"[Properties] OR "strategy clone"[Properties] OR "strategy finishing"[Properties] OR "strategy validation"[Properties] AND "filetype fastq"[Properties])'], stdout=subprocess.PIPE)
docsum_res = subprocess.Popen(['efetch', '-format', 'docsum'], stdin=query_res.stdout, stdout=subprocess.PIPE)

# Get the output of the commands
out, err = docsum_res.communicate()

print("Query results obtained.\nParsing out accessions...")

# Decode the binary to get all the XML as a string
xml = out.decode("utf-8")

# We need to add a root element after the xml declaration because ElementTree requires a root node
# And also get rid of the DOCTYPE tag because ElementTree doesn't like it
# So we'll accomplish both tasks in one fell swoop
xml_fixed = re.sub(f"<!DOCTYPE DocumentSummarySet>", r"<root>", xml) + "</root>"

# Read in the XML, then iterate over it and get all the run accessions
accs = []
root = ElementTree.fromstring(xml_fixed)
for run in root.iter("Run"):
    accs.append(run.attrib.get("acc"))

# Determine how many to download
if num_download is None:
    num_download = len(accs)

# Use pandas to export so we can send all the accessions to prefetch at once
accs_filename = "accs.tsv"

pd.Series(accs).\
sort_values().\
iloc[:num_download].\
to_csv(accs_filename, sep="\t", index=False, header=False)

print("Accessions parsed.\nDownloading compressed data files using prefetch...")

# Use prefetch to download the compressed data for those accession numbers
prefetch_ret = subprocess.run(f"prefetch -p --option-file {accs_filename} -O {download_path}", shell=True)

# Remove the temporary file of accessions
os.remove(accs_filename)
