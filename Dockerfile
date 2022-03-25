FROM ubuntu:20.04
MAINTAINER Szczepan Kozioł <szczepankoziol@gmail.com>

# Make sure the package repository is up to date.
ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -qy full-upgrade && apt-get -qy install \
    git \
    curl \
    apt-transport-https \
    build-essential \
# Install a basic SSH server
    openssh-server \
# Install JDK
    default-jdk && \    
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install NodeJS
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -qy nodejs && \
# Install Angular CLI 8
    npm update && \
# Install Yarn
    npm install -g yarn && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd
    
#RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
