import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

from sys import argv

repoDir = argv[1]
dotsDir = repoDir + "_dots"
coldotDir = dotsDir + "/out_dots/coldot/"

sns.set_style("whitegrid")
blue,red = sns.color_palette("muted", 2)

# tagnames = [20161104,20161126,20170424,20180226,20180228,20180520,20180524,20180531,20180716,20181026,20190109,"latest"]
# xticks = [str(tag) for tag in tagnames]

added = [int(tag.strip()) for tag in open(coldotDir + "count_green").readlines()]
removed = [int(tag.strip())*-1 for tag in open(coldotDir + "count_red").readlines()]

x = range(1, len(added)+1)

fig, ax = plt.subplots()

ax.plot(x, added, color=blue, lw=1.5)
ax.plot(x, removed, color=red, lw=1.5)

ax.fill_between(x, 0, added, color=blue, alpha=.3)
ax.fill_between(x, 0, removed, color=red, alpha=.3)

ax.set(xticks=x)
# ax.set(xlim=(0, len(x) - 1), ylim=(None, None), xticks=x)
# plt.xticks(x,xticks, rotation=45)
fig.savefig(repoDir + "/" + "plot.png", dpi=300)