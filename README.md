# Oncogenomic laboratory docker repository

 * ### Description

This repository contains informations on how to generate and use the working environment used by researchers at Candiolo research institute-IRCCS Oncogenomic laboratory. 
Docker images are stored and can be downoaded from [cisella DockerHub repository](https://hub.docker.com/r/cisella/bookworm_r)


*  #### Generating the docker image

The Dockerfile in this folder has been used to generate a parent environment. For each new project, a new branch has been created with additional packages and libraries according to the 
requirements of the various research queries. More detailed information on project environments can be found in the corresponding submissions and are available to download from the 
[DockerHub repository](https://hub.docker.com/r/cisella/bookworm_r).

This repository can be downloaded and used to build the docker de-novo, as it contains the Dockerfile.
To do so, first pull the repository 


```bash
git pull CBenetti/OGC_docker_repo
```

Then, from outside of the folder, execute the following line to build the docker image

```bash
docker build OGC_docker_repo  -t ogclab:4.2.2 
```

At the time of the build, the versions of the R packages specified in the dockerfile are those listed in the [package version table](installed_packages.txt) in the current repository.
To achieve a full reproducibility without pulling the docker image, it would be advisable to check the package versions after the build before performing any analysis. 



* ### Running the docker


With the following code, a docker container will be initialized. It will allow to expose a list of ports which can be used for image visualization in R

```bash
docker run -it -p 8060-8888:8060-8888 image_name
```


* ###  Visualizing plots in R

Once R is up and running, to visualize plots interactively and without saving to pdf files, execute the following command before displaying the plot. 
The port number can be chosen from any value in the range specified in the docker run command.

```R
httpgd::hgd(host = "0.0.0.0", port = 8888)
```

It will display a link to paste into a web browser to show the plot.
In the same R session, to retrieve it just type


```R
httpgd::hgd_url(host = "localhost")
```

* ###  Opening new terminals from the same session and generating new plots

By exposing several different ports, plots can be visualized in the same manner even by opening a differen terminal from inside of the same container.

To open another terminal window operating in the same docker container which is already running, first retrieve the container id

```bash
docker ps
```

Then use it  to initialize a new instance of the same container as follows

```bash
docker exec -it containerid bash
```

In this new instance, images must be visualised in an unoccupied port of those which were made available in the creation of the container.
Hence, repeat the same passages in R using different port among the ones made available in the beginning
(in this case between 8060 to 8888)


* ### Credits

[Claudio Isella](mailto:c.isella@ircc.it)


[Cinzia Benetti](mailto:cinzia.benetti@edu.unito.it)

