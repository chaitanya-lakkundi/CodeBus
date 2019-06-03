from glob import glob
from sys import argv
from os import mkdir

# data = open("inh_all.dot").readlines()
# label_list = open("all_labels").readlines()
# numLabel = dict()

# for num,label in enumerate(label_list):
#     label = label.strip()
#     numLabel[label] = num

# of = open("inh_theone.dot","w")

# for item in data:
#     try:
#         label = item.split('"')[1]
#         num = numLabel[label]
#         pos = item.find("[")
#         item = "Node" + str(num) + " " + item[pos:]
            
#     except:
#         pass
    
#     of.write(item)
# of.close()

repoDir = argv[1]
dotsDir = repoDir + "_dots"
mkdir(dotsDir + "/out_dots")

dot_header = """\
digraph "Graphical Class Hierarchy"
{
  edge [fontname="Helvetica",fontsize="10",labelfontname="Helvetica",labelfontsize="10"];
  node [fontname="Helvetica",fontsize="10",shape=record];
  rankdir="LR";

"""
dot_footer = "}"

def generate_numLabels(dotfiles):
	all_labels = []
	numLabel = {}

	for each_dotfile in dotfiles:
		with open(each_dotfile) as df:
			for line in df.readlines():
				try:
					if "label=" in line:
						all_labels.append(line.split('"')[1])
				except:
					pass

	list(set(all_labels)).sort()

	for num,label in enumerate(all_labels):
	    label = label.strip()
	    numLabel[label] = num

	return numLabel

def generate_integrated_dotfile(tagname):
	of = open(dotsDir + "/" + "out_dots/" + "out_" + tagname + ".dot","w")
	of.write(dot_header)

	all_dots = glob(dotsDir + "/" + tagname + "/*cgraph.dot", recursive=True)

	filtered_dots = all_dots
	# filtered_dots = list(filter(lambda item: item.startswith("only_dots/html_1.1/"), all_dots))
	# filtered_dots = list(filter(lambda item: item.endswith("cgraph.dot"), filtered_dots))

	numLabel = generate_numLabels(filtered_dots)

	for dotfile in filtered_dots:
		# node_map is unique for every dotfile whereas numLabel is shared globally
	    node_map = {}

	    # Pass 1: Create node_map
	    with open(dotfile) as df:
	        for line in df.readlines():
	            try:
	                label = line.split('"')[1]
	                pos = line.find("[")
	                node_name = line[:pos].strip()
	                node_map[node_name] = "Node" + str(numLabel[label])
	            except:
	                pass
	    
	    # Pass 2: Replace all occurances  
	    with open(dotfile) as df:
	        for line in df.readlines():
	            try:
	                label = line.split('"')[1]
	                pos = line.find("[")
	                line = "Node" + str(numLabel[label]) + " " + line[pos:]
	                
	            except:
	                pos = line.find("[")
	                if "->" in line:
	                    edge_nodes = line[:pos]
	                    ar_pos = edge_nodes.find("->")
	                    nodeL = edge_nodes[:ar_pos].strip()
	                    nodeR = edge_nodes[ar_pos+2:].strip()
	                    new_nodeL = node_map[nodeL]
	                    new_nodeR = node_map[nodeR]
	                    edge_nodes = new_nodeL + " -> " + new_nodeR + " "
	                
	                    line = edge_nodes + line[pos:]

	            if line.startswith("digraph") or line.strip().startswith("edge") or line.strip().startswith("node") or line.strip().startswith("rankdir") or line.startswith("{") or line.startswith("}"):
	            	# don't write
	            	pass
	            else:
	            	of.write(line)

	of.write(dot_footer)

	of.close()

with open(repoDir + "/tagnames") as tf:
	tagnames = [tag.strip() for tag in tf.readlines()]

for each_tag in tagnames:
	generate_integrated_dotfile(each_tag)