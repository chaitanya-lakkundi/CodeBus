FROM ubuntu:18.04

RUN apt-get update && \
        apt-get install -y python3 python3-setuptools git-core curl doxygen \
        graphviz qpdf

WORKDIR "/tmp"

RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb && \
        dpkg -i ripgrep_11.0.1_amd64.deb

RUN git clone https://github.com/mwaskom/seaborn.git && \
        cd seaborn && \
        python3 setup.py install

WORKDIR "/home"

RUN git clone https://github.com/chaitanya-lakkundi/CodeBus.git && \
        git clone https://github.com/radareorg/cutter.git && \
        git clone https://github.com/airbnb/epoxy.git && \
        git clone https://github.com/OpenKinect/libfreenect2.git

WORKDIR "/home/CodeBus"