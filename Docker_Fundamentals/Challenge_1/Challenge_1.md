# **Challenge Description.**
#### **Goal:** Download a specific image from Docker Registry an execute it.
---
### Solution:

#### *Steps to be provided are suitable for Ubuntu.

#### **Install Docker Engine / Docker Desktop.**
- Go to: https://docs.docker.com/desktop/install/linux/ubuntu/

- Set up Docker's apt repository.
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```
- Install the Docker packages.
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
- Verify that the Docker Engine installation is successful by running the hello-world image.
``` 
sudo docker run hello-world

# This command downloads a test image and runs it in a container. When the container runs, it prints a confirmation message and exits.
```

- Download latest DEB package.

- Update installation packages.   
```
sudo apt-get update
```
- Get into the Downloads folder.
```
cd Downloads
```
- Install Docker package.
```
sudo apt-get install ./docker-desktop-amd64.deb
```
- Verify version downloaded.
```
docker -v
# It displays the Docker version.
```
---

#### **Download the Nginx image from Docker Registry.**

- Download image.
```
docker pull nginx
```
- Verify an image has been created.
```
docker images

# It should display the image specifics.
REPOSITORY-TAG-IMAGE ID-CREATED-SIZE
```
- Run Container.
```
docker run --name my-nginx -d -p 8080:80 nginx

# 8080 is the host port. 80 is the port to access Container.
```

- Check Container status.
```
docker ps

# Status column indicates "Up".
```
- Go to your browser, type localhost:8080. You should see what is shown in the _Verification image._

#### [Verification image.](https://github.com/FreCalvo/CloudStation/blob/main/Docker_Fundamentals/Challenge_1/nginx_localhost8080.png)
