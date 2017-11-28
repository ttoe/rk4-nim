from matplotlib import pylab as plt
import pandas as pd

### # lotka-volterra
### lv_data = pd.read_csv("lv_data.csv", sep="\t", header=0, index_col=False)
### 
### lv_data.plot(x="time", y=["X", "Y"])
### plt.xlabel("time")
### plt.ylabel("population density")
### plt.savefig("lotka_volterra.png")
### 
### # rma
### rma_data = pd.read_csv("rma_data.csv", sep="\t", header=0, index_col=False)
### 
### rma_data.plot(x="time", y=["X", "Y"])
### plt.xlabel("time")
### plt.ylabel("population density")
### plt.savefig("rma.png")

# chemostat
chemostat_data = pd.read_csv("chemostat_data.csv", sep="\t", header=0, index_col=False)
chemostat_data["CT"] = chemostat_data["C1"] + chemostat_data["C2"]

chemostat_data.plot(x="time", y=["CT", "P", "T"])
plt.xlabel("time")
plt.ylabel("population density")
plt.savefig("chemostat_ct_p_tp.png")

### chemostat_data.plot(x="time", y=["CT", "P", "T"], logy=True)
### plt.xlabel("time")
### plt.ylabel("population density")
### plt.savefig("chemostat_log_ct_p_tp.png")

### chemostat_data.plot(x="time", y=["S", "C1", "C2", "CT", "P", "T"], logy=True)
### plt.xlabel("time")
### plt.ylabel("population density")
### plt.savefig("chemostat_log_all.png")

chemostat_data.plot(x="time", y=["S", "C1", "C2", "CT", "P", "T"])
plt.xlabel("time")
plt.ylabel("population density")
plt.savefig("chemostat_all.png")

### chemostat_data.plot(x="time", y=["C1", "C2", "P"])
### plt.xlabel("time")
### plt.ylabel("population density")
### plt.savefig("chemostat_c1_c2_p.png")
