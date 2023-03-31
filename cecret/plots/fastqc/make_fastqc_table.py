import altair as alt
import os
import pandas as pd
import sys

data_dir = sys.argv[1]

if not os.path.isdir(data_dir):
    raise ValueError("Invalid input directory.")

sample_dirs = [f.path for f in os.scandir(data_dir) if f.is_dir()]

samples = []
depths = []
coverages = []
perc_kepts = []

all_count = 0
empty_count = 0

for sample_dir in sample_dirs:
    all_count += 1
    if os.path.isfile():
    else:
        empty_count += 1
