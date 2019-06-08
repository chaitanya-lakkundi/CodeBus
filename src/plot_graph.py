import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

from sys import argv

repoDir = argv[1]
if repoDir[-1] == "/":
	repoDir = repoDir[:-1]

dotsDir = repoDir + "_dots"
coldotDir = dotsDir + "/out_dots/coldot/"

# sns.set_style("whitegrid")
# blue,red = sns.color_palette("muted", 2)

blue = (0.2824, 0.4706, 0.8157)
red = (0.9334, 0.5215, 0.2902)

added = [int(tag.strip()) for tag in open(coldotDir + "count_green").readlines()]
removed = [0] + [int(tag.strip())*-1 for tag in open(coldotDir + "count_red").readlines()][:-1]
total_components = open(repoDir + "/diffs/ctotal").read().strip()

x = range(1, len(added)+1)
fig, ax = plt.subplots()

ax.plot(x, added, color=blue, lw=1.5, label="Added Components")
ax.plot(x, removed, color=red, lw=1.5, label="Removed Components")

ax.fill_between(x, 0, added, color=blue, alpha=.3)
ax.fill_between(x, 0, removed, color=red, alpha=.3)

# ax.set(xticks=x)
ax.legend()

plt.xlabel("Releases")
plt.ylabel("Number of Components")
plt.title(repoDir.split("/")[-1] + " - Collaboration Graph Evolution")
plt.text(max(x)/2, min(removed), "Total Components = " + total_components)

fig.savefig(repoDir + "/" + "plot.png", dpi=300)