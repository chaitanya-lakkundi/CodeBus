from sys import argv
from os import mkdir

print("colorize_dots.py START")

repoDir = argv[1]
if repoDir[-1] == "/":
	repoDir = repoDir[:-1]

dotsDir = repoDir + "_dots"

def addGreen(line):
	try:
		pos = line.find("fillcolor=")
		endpos = line[pos:].find(",")
		line = line[:pos] + 'fillcolor="#85e085"' + line[pos+endpos:]
	except:
		pass

	return line

def addRed(line):
	try:
		pos = line.find("fillcolor=")
		endpos = line[pos:].find(",")
		line = line[:pos] + 'fillcolor="#ff5c33"' + line[pos+endpos:]
	except:
		pass

	return line

def colorize(tagnames):
	tagnames.append("dummyend")
	cur_tagname = tagnames[0]
	try:
		mkdir(dotsDir + "/out_dots/coldot")
	except FileExistsError:
		pass

	for next_tagname in tagnames[1:]:

		diffyAdd = open(repoDir + "/diffs/diff_" + cur_tagname)
		diffyDel = open(repoDir + "/diffs/diff_" + next_tagname)

		addlist = []
		dellist = []

		for line in diffyAdd:
			if line.startswith(">"):
				addlist.append(line[2:].strip())

		for line in diffyDel:
			if line.startswith("<"):
				dellist.append(line[2:].strip())

		dotfile = open(dotsDir + "/out_dots/out_" + cur_tagname + ".dot").readlines()
		of = open(dotsDir + "/out_dots/coldot/out_" + cur_tagname + "_col.dot","w")

		for line in dotfile:

			for item in addlist:
				if item.strip() in line:
					line = addGreen(line)

			for item in dellist:
				if item.strip() in line:
					line = addRed(line)

			of.write(line)

		cur_tagname = next_tagname
		of.close()

tagnames = [tag.strip() for tag in open(repoDir + "/tagnames").readlines()]

colorize(tagnames)
print("colorize_dots.py END")