from matplotlib import pylab as plt
import pandas as pd

# lotka-volterra
lv_data = pd.read_csv("lv_data.csv", sep="\t", header=0, index_col=False)

lv_data.plot(x="time", y=["X", "Y"])
plt.xlabel("time")
plt.ylabel("population density")
plt.savefig("lotka_volterra.png")

# rma
rma_data = pd.read_csv("rma_data.csv", sep="\t", header=0, index_col=False)

rma_data.plot(x="time", y=["X", "Y"])
plt.xlabel("time")
plt.ylabel("population density")
plt.savefig("rma.png")

# chemostat
chemostat_data = pd.read_csv("chemostat_data.csv", sep="\t", header=0, index_col=False)
chemostat_data["CT"] = chemostat_data["C1"] + chemostat_data["C2"]

chemostat_data.plot(x="time", y=["CT", "P", "T"])
plt.xlabel("time")
plt.ylabel("population density")
plt.savefig("chemostat.png")
