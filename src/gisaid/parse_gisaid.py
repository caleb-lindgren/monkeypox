import numpy as np
import os
import pandas as pd

files = [f"raw_text/{f}" for f in os.listdir('raw_text') if os.path.isfile(f"raw_text/{f}")]

ids = []
names = []
dates = []
locs = []
lineages = []
sample_subs = []

for f in files:
    with open(f, "r") as raw:
        for line in raw:
            if line.startswith("Location:"):
                loc = line.split("/")[-1].strip()
                if loc == "Los Angeles County":
                    loc = "California"
                elif loc == "Baltimore":
                    loc = "Maryland"
                locs.append(loc)
            elif line.startswith("Clade"):
                lineages.append(line.split("Lineage")[-1].strip())
            elif line.startswith("AA Substitutions"):
                raw_subs = line.split("Substitutions")[-1].split(",")
                trim_subs = []
                for sub in raw_subs:
                    sub_stripped = sub.strip()
                    if len(sub_stripped) > 0:
                        trim_subs.append(sub_stripped)
                if len(trim_subs) > 0:
                    sample_subs.append(trim_subs)
                else:
                    sample_subs.append(np.nan)
            elif line.startswith("Virus name"):
                names.append(line.split("name:")[-1].strip())
            elif line.startswith("Accession ID"):
                ids.append(line.split("ID:")[-1].strip())
            elif line.startswith("Collection date"):
                dates.append(line.split("date:")[-1].strip())

df = pd.DataFrame({
    "Accession ID": ids,
    "Virus Name": names,
    "Collection Date": pd.to_datetime(dates),
    "state": locs,
    "Lineage": lineages,
    "AA Substitutions": sample_subs,
}).\
sort_values(by=["state", "Lineage"]).\
reset_index(drop=True)

df.to_csv("gisaid_parsed.tsv", sep="\t", index=False)
