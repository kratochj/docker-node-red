# Node-RED-Docker

This project describes some of the many ways Node-RED can be run under Docker.

To run this directly in docker at it's simplest just run

        docker run -it -p 1880:1880 kratochj/node-red
		
### Using Volumes

Docker supports using [data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/) to store persistent or shared data outside the container. Files and directories within data volumes exist outside of the lifecycle of containers, i.e. the files still exist after removing the container.

Node-RED image uses the `/data` directory to store user configuration data.

Mounting a data volume inside the container at this directory path means user configuration data can be saved outside of the container and even shared between container instances.

Let's create a new named data volume to persist our user data and run a new container using this volume.  

        $ docker volume create --name node_red_user_data
        $ docker volume ls
        DRIVER              VOLUME NAME
        local               node_red_user_data
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name nodered kratochj/node-red

Using Node-RED to create and deploy some sample flows, we can now destroy the container and start a new instance without losing our user data.

        $ docker rm nodered
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name nodered kratochj/node-red

### Setting authentication

You can pass list of users via environment variables `USERS_FULL_ACCESS` and `USERS_RO_ACCESS` as a list of username|passwor_hash pairs separated by comma. 

To generate hash simply run:

		$ docker run -it kratochj/node-red hash
		(in dialog add password and hash will be printed on STDOUT)
		
This hash can be used as an environment variables as in example: 

		$ docker run -it -p 1880:1880 -e USERS_FULL_ACCESS="admin|hash1,admin2|hash2" -e USER_RO_ACCESS="readonlyuser|hash" --name nodered kratochj/node-red


