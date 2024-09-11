import pandas as pd

pd.set_option("display.max_rows", 500)
pd.set_option("display.max_columns", 500)
pd.set_option("display.width", 1000)


url = "imports-85.csv"
col_names = [
    "symboling",
    "normalized-losses",
    "fuel-type",
    "aspiration",
    "num-of-doors",
    "body-style",
    "drive-wheels",
    "engine-location",
    "wheel-base",
    "length",
    "width",
    "height",
    "curb-weight",
    "engine-type",
    "num-of-cylinders",
    "engine-size",
    "fuel-system",
    "bore",
    "stroke",
    "compression-ratio",
    "horsepower",
    "peak-rpm",
    "city-mpg",
    "highway-mpg",
    "price",
]

df_car = pd.read_csv(
    url, sep=",", names=col_names,
    na_values="?", header=None
)

df_car.shape
df_car.head(5)
df_car.info()
df_car.columns

df_car = df_car[
    ["aspiration", "num-of-doors", "drive-wheels", "num-of-cylinders"]
].copy()
df_car.head()

df_car.info()

df_car["num-of-doors"].value_counts()

door_mapper = {"two": 2, "four": 4}

df_car["doors"] = df_car["num-of-doors"].replace(door_mapper)

df_car.head()

df_car["num-of-cylinders"].value_counts()

cylinder_mapper = {
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "eight": 8,
    "twelve": 12,
}

df_car["cylinders"] = df_car["num-of-cylinders"].replace(cylinder_mapper)

df_car.head()

df_car["drive-wheels"].value_counts()

df_car = pd.get_dummies(df_car, columns=["drive-wheels"])

df_car.head()

df_car["aspiration"].value_counts()

df_car = pd.get_dummies(df_car, columns=["aspiration"], drop_first=True)

df_car.head()
