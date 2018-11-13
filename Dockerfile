FROM jupyter/scipy-notebook
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
ENV PASSWORD tina

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
USER root

ENV JUPYTER_ENABLE_LAB yes

RUN apt update
RUN apt install curl -y

ENV DEBIAN_FRONTEND noninteractive

# Ubuntu packages + Numpy
RUN apt-get update && apt-get install -y python3-pip curl unzip \
    libosmesa-dev libglew-dev patchelf libglfw3-dev

#Uncomment if you need mujoco for openai, also, you will need to add stuff for the licence. (i didnt bother)
#RUN curl https://www.roboti.us/download/mjpro150_linux.zip --output /tmp/mujoco.zip && \
#    mkdir -p /root/.mujoco && \
#    unzip /tmp/mujoco.zip -d /home/jovyan/.mujoco && \
#    rm -f /tmp/mujoco.zip
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/jovyan/.mujoco/mjpro150/bin

# Upgrade pip
RUN python3 -m pip install --upgrade pip

#ADD mujoco ?

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN jupyter serverextension enable --py jupyterlab

USER $NB_UID

RUN conda install -c menpo opencv3
RUN conda install -c conda-forge tensorflow
RUN conda install -c conda-forge fasttext
RUN conda install -c conda-forge spacy
RUN conda install -c tkharrat r-gym

RUN mkdir -p /home/jovyan/install
WORKDIR /home/jovyan/install
RUN pip install pybind11
RUN git clone https://github.com/facebookresearch/fastText.git
WORKDIR /home/jovyan/install/fastText
RUN python setup.py install

RUN pip3 install flask

WORKDIR /home/jovyan/work
