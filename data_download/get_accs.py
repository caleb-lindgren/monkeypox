import pandas as pd
import re
import subprocess

from xml.etree import ElementTree

# Execute a series of bash commands using pipes to query the SRA for the accession numbers we want
query_res = subprocess.Popen(['esearch', '-db', 'sra', '-query', 'monkeypox[All Fields] AND "Monkeypox virus"[orgn] AND (cluster_public[prop] AND "biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "strategy wgs"[Properties] OR "strategy wga"[Properties] OR "strategy wcs"[Properties] OR "strategy clone"[Properties] OR "strategy finishing"[Properties] OR "strategy validation"[Properties] AND "filetype fastq"[Properties])'], stdout=subprocess.PIPE)
docsum_res = subprocess.Popen(['efetch', '-format', 'docsum'], stdin=query_res.stdout, stdout=subprocess.PIPE)

# Get the output of the commands
out, err = docsum_res.communicate()

# Decode the binary to get all the XML as a string
xml = out.decode("utf-8")

# We need to add a root element after the xml declaration because ElementTree requires a root node
# And also get rid of the DOCTYPE tag because ElementTree doesn't like it
xml_fixed = re.sub(f"<!DOCTYPE DocumentSummarySet>", r"<root>", xml) + "</root>"

# Read in the XML, then iterate over it and get all the run accessions
accs = []
root = ElementTree.fromstring(xml_fixed)
for run in root.iter("Run"):
    accs.append(run.attrib.get("acc"))

# Use pandas to sort and export
pd.Series(accs).\
sort_values().\
to_csv("accs.tsv", sep="\t", index=False, header=False)
