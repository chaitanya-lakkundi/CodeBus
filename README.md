# CodeBus
## ISHA Research Lab (Intelligent Software and Human Analytics)

## Analyzed Repositories from [RapidRelease](https://github.com/saketrule/RapidRelease) dataset

- https://github.com/radareorg/cutter
- https://github.com/airbnb/epoxy
- https://github.com/OpenKinect/libfreenect2

## Installation Method 1 
### Using generic installation of softwares (Tested on Ubuntu 16.04 and 18.04) 

1. Clone this repository and navigate to this directory in terminal.
2. Execute `./install.sh`
3. Execute `./run.sh ../Repos/cutter`   OR    `./run.sh PATH-TO-REPO` to analyze the repository.

## Installation Method 2
### Using Docker (20 minutes to install under our setup, Roughly 250 MB download)
#### Supports any operating system where `docker` is installed.

Assuming `docker` is installed. [Tutorial to install docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)

1. Download `Dockerfile` and save it in a new directory. Navigate to the new directory in terminal.
2. Execute `docker build -t codebus .` to create `codebus` docker image.
3. Execute `docker create --name codebus-run -t -i codebus` to create container named `codebus-run`.
4. `docker start codebus-run` to start the container.
5. `docker attach codebus-run` to get to command prompt.
6. Execute `./run.sh ../cutter` to analyze `cutter`.

#### How to copy files from Docker container to your host filesystem?
Execute `docker cp codebus-run:/home/cutter/cutter-evolution.pdf .`
and `docker cp codebus-run:/home/cutter/plot.png .` to copy both files.

## Output Files

Finally, mega collaboration diagram and area plots are generated in 

**PATH-TO-REPO/cutter-evolution.pdf and PATH-TO-REPO/plot.png**
