# CodeBus
### Research in Intelligent Software and Human Analytics Lab

## Docker Image
[![](https://images.microbadger.com/badges/image/cs18s502/codebus.svg)](https://microbadger.com/images/cs18s502/codebus "cs18s502/codebus") [![](https://images.microbadger.com/badges/version/cs18s502/codebus.svg)](https://microbadger.com/images/cs18s502/codebus "cs18s502/codebus")

## Analyzed Repositories from [RapidRelease](https://github.com/saketrule/RapidRelease) dataset

- https://github.com/radareorg/cutter
- https://github.com/airbnb/epoxy
- https://github.com/OpenKinect/libfreenect2

### What is a [Collaboration graph]?
A graph for each documented class showing the direct and indirect implementation dependencies (inheritance, containment, and class references variables) of the class with other documented classes. -- [[1]]

[Collaboration graph]: http://www.doxygen.nl/manual/config.html#cfg_collaboration_graph
[1]: http://www.doxygen.nl/manual/config.html#cfg_collaboration_graph

### What is a [Call graph]?
A call dependency graph for every global function or class method. -- [[2]]

[Call graph]: http://www.doxygen.nl/manual/config.html#cfg_call_graph
[2]: http://www.doxygen.nl/manual/config.html#cfg_call_graph

## Evolution of Architecture (in number of components)
![Full Plot](/Unified-Diagrams/full-plot.png?raw=true)

## Sample Architectural Changes in Cutter
![Sample Cutter 1](/Unified-Diagrams/samplecutter1.png?raw=true)
![Sample Cutter 2](/Unified-Diagrams/samplecutter2.png?raw=true)

## Sample Architectural Changes in libfreenect2
![Sample libfreenect 1](/Unified-Diagrams/samplelibfreenect1.png?raw=true)

## Installation Method 1
### Pull Docker Image (Fastest Method depending upon Internet connection speed)

Assuming `docker` is installed. ([Tutorial to install docker])

[Tutorial to install docker]: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

1. Execute `docker pull cs18s502/codebus:v1.1` to pull the image.
2. `docker run --name codebus-run -it cs18s502/codebus:v1.1` to create a container and run.
3. `./run.sh ../cutter`  OR  `./run.sh PATH-TO-REPO` to analyze the repository.
4. Execute `exit` to stop the container.

**PS:** If you want to start the container once again, execute the following commands.

1. `docker start codebus-run`
2. `docker attach codebus-run`

### How to copy files from Docker container to your host filesystem?
Execute `docker cp codebus-run:/home/cutter/cutter-evolution.pdf .`
and `docker cp codebus-run:/home/cutter/plot.png .` to copy both files.

## Installation Method 2 
### Using generic installation of softwares (Tested on Ubuntu 16.04 and 18.04) 

1. Clone this repository and navigate to this directory in terminal.
2. Execute `./install.sh`
3. Execute `./run.sh ../Repos/cutter`   OR    `./run.sh PATH-TO-REPO` to analyze the repository.

## Output Files

Finally, mega collaboration diagram and area plots are generated in 

**PATH-TO-REPO/cutter-evolution.pdf and PATH-TO-REPO/plot.png**
