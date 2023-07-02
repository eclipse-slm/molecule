ARG MOLECULE_VERSION=5.1.0
FROM python:3.9

ARG MOLECULE_VERSION

RUN echo "alias mcrs='molecule create -s'" >> ~/.bashrc && \
    echo "alias mrs='molecule reset -s'" >> ~/.bashrc && \
    echo "alias mps='molecule prepare -f -s'" >> ~/.bashrc && \
    echo "alias mcs='molecule converge -s'" >> ~/.bashrc && \
    echo "alias mvs='molecule verify -s'" >> ~/.bashrc && \
    echo "alias mds='molecule destroy -s'" >> ~/.bashrc

RUN git config --global credential.helper store
RUN apt update && apt install -y docker.io sshpass libguestfs-tools libvirt-dev virtinst
RUN python3 -m pip install \
    molecule==$MOLECULE_VERSION \
    molecule[docker]==$MOLECULE_VERSION \
    ansible \
    jmespath \
    pywinrm \
    pypsrp \
    requests-credssp==1.3.1

RUN ansible-galaxy install git+https://github.com/eclipse-slm/molecule_vsphere
#RUN ansible-galaxy collection install community.vmware:3.2.0

CMD /bin/sh -c /bin/bash