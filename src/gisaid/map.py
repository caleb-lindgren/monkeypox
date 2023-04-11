import altair as alt
import numpy as np
import pandas as pd

from geopy.geocoders import Nominatim
from vega_datasets import data

# Get state IDs from this table
state_ids = data.population_engineers_hurricanes()[["state", "id"]].\
rename(columns={"state": "State"})

# Load data from GISAID
df = pd.\
read_csv("gisaid_parsed.tsv", sep="\t")

df = df.assign(Lineage=df["Lineage"].fillna("No data"))

#df = df[["State", "Lineage", "Collection Date"]].\
#groupby(["State", "Lineage"]).\
#count().\
#reset_index(drop=False)

df = df[["State", "Lineage", "Collection Date"]].\
reset_index(drop=False)

df = df.merge(
    right=state_ids,
    on="State",
    how="outer"
)

# Get latitude and longitude for each state
geolocator = Nominatim(user_agent="MyApp")
lats = []
longs = []
states = df["State"].unique()

for state in states:
    location = geolocator.geocode(state)
    lats.append(location.latitude)
    longs.append(location.longitude)

coords = pd.DataFrame({
    "State": states,
    "latitude": lats,
    "longitude": longs,
})

df = df.merge(
    right=coords,
    on="State",
    how="outer",
)

# Calculate jitter so points don't overlap but are still centered on state
jit_states = []
jit_lineages = []
jit_lats = []
jit_longs = []

def pol_to_cart(rho, phi):
    x = rho * np.cos(phi)
    y = rho * np.sin(phi)
    return x, y

for state in df["State"].unique():

    samples = df[df["State"] == state]

    lat = samples.loc[samples["State"] == state, "latitude"].iloc[0]
    lng = samples.loc[samples["State"] == state, "longitude"].iloc[0]

    sample_count = 0
    total_samples = samples.shape[0]

    for lineage in samples["Lineage"].unique():

        jit_states.append(state)
        jit_lineages.append(lineage)

        if pd.notna(lineage):
            rho = samples.loc[samples["Lineage"] == lineage].shape[0] / 20 + 0.1
            phi = np.pi * 2 / total_samples * sample_count
            x, y = pol_to_cart(rho=rho, phi=phi)

            jit_lats.append(lat + y)
            jit_longs.append(lng + x)

        else:
            jit_lats.append(lat)
            jit_longs.append(lng)

        sample_count += 1

jits = pd.DataFrame({
    "State": jit_states,
    "Lineage": jit_lineages,
    "latitude_jitter": jit_lats,
    "longitude_jitter": jit_longs,
})

df = df.merge(
    right=jits,
    on=["State", "Lineage"],
    how="outer"
)

states_shapes = alt.topo_feature(data.us_10m.url, "states")

interval = alt.selection_interval()

background = alt.Chart(df).mark_geoshape(
    fill="lightgray",
    stroke="white",
).encode(
    shape="geo:G",
).transform_lookup(
    lookup="id",
    from_=alt.LookupData(data=states_shapes, key="id"),
    as_="geo",
).properties(
    width=900,
    height=520,
).project(
    type="albersUsa"
)

click = alt.selection_multi(encodings=['color'])

points = alt.Chart(df).mark_circle().encode(
    longitude="longitude_jitter:Q",
    latitude="latitude_jitter:Q",
    color="Lineage:N",
    size="count()",
    tooltip=["State", "Lineage", "count()"],
).transform_filter(
    "isValid(datum.Lineage)",
).transform_filter(
    click,
)

lineage_hist = alt.Chart(df).mark_bar().encode(
    x="count()",
    y="Lineage:N",
    color=alt.condition(click, "Lineage:N", alt.value("lightgray"))
).properties(
    width=800,
    height=150,
).transform_filter(
    "isValid(datum.Lineage)",
).add_selection(
    click
)

state_hist = alt.Chart(df).mark_bar().encode(
    x="count()",
    y="State:N",
    color=alt.condition(click, "Lineage:N", alt.value("lightgray"))
).properties(
    width=800,
    height=150,
).transform_filter(
    "isValid(datum.Lineage)",
).add_selection(
    click
)

chart = alt.vconcat(
    alt.layer(
        background,
        points
    ),
    lineage_hist,
    state_hist,
    center=True,
)

chart.save("interactive.html")
