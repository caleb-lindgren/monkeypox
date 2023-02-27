import subprocess

query_res = subprocess.Popen(['esearch', '-db', 'sra', '-query', 'monkeypox[All Fields] AND "Monkeypox virus"[orgn] AND (cluster_public[prop] AND "biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "strategy wgs"[Properties] OR "strategy wga"[Properties] OR "strategy wcs"[Properties] OR "strategy clone"[Properties] OR "strategy finishing"[Properties] OR "strategy validation"[Properties] AND "filetype fastq"[Properties])'], stdout=subprocess.PIPE)
docsum_res = subprocess.Popen(['efetch', '-format', 'docsum'], stdin=query_res.stdout, stdout=subprocess.PIPE)

out, err = docsum_res.communicate()
