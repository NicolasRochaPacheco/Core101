# Core101 Docker Documentation
This readme file is intended to be explain why we use Docker on the Core101 project, how to install Docker and build the Core101 image. If you have Docker installed on your machine and you know how to build a Docker image and using it without creating a new container every time, avoid reading this. If you did not understand the joke from the last sentence, you might read this.

## Why Docker?
One of the motivations on doing this project was creating a beginner-friendly RISC-V core. Most of RISC-V cores repositories assume that user knows how to synthetize their HDL and do not provide detailed documentation on prerrequisites and build methodologies. Thats why we use Docker. We are also tight on schedule to provide a step by step documentation on the prerrequisite installation and building process, as most of the teams are. But, by using a Docker image, we "provide" a virtual environment where everyone can build and use our core. 

Another advantage of using Docker is portability. A Docker just needs a Dockerfile to build the environment with all dependencies and prerrequisites installed, so we can ensure that everything will work properly. This portability is very useful when showing your progress to your advisor. There are less chances that your laptop will freeze on his/her office, or the synthetization will come up with and error after installing some pip packages just before your meeting.

## Docker installation
After explaining why we use Docker for hardware development, we would like to provide an installation reference. Here we have some common steps on installing Docker:

    $ sudo apt-get update
    $ sudo apt-get 	install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io

The previous commands come from the Ubuntu [Docker documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/). If you are using another OS, please check the documentation for your OS. If you want to run Docker without any root permissions (without sudo), execute:

    $ sudo groupadd docker
    $ sudo usermod -aG docker $USER
    $ newgrp docker

As the installation commands, those commands come from Ubuntu [Docker documentation](https://docs.docker.com/install/linux/linux-postinstall/). We invite you to check your OS documentation if you are not using Ubuntu. We also encourage you to check the documentation if any error shows up during the installation process. To test if Docker was installed successfully do:

    $ docker run hello-world

If the previous command shows a Hello World! on the console output, Docker was installed succesfully. Add `sudo` if you are still using root permisions with Docker.

## Building the Core101 image
As Docker is installed, you should build the Docker image to synthetize and run Core101 tests. To build the Docker image execute the following commands. Please make sure that this folder is your current directory.

    $ docker build -t core101:latest .

Once the image is built, you have to create a new container from the image. When you use the `run` command in Docker it creates a new containter, so it must be used only once.

    $ docker run -it --name core101 core101:latest

As the container is started a bash console is executed. To exit the container just use the `exit` command, all the changes will be saved. To restart the container after exiting, use:

    $ docker start -ai core101 

Again, do not use the `run` command attempting to restart a container. To remove the container, use:

    $ docker container rm core101
