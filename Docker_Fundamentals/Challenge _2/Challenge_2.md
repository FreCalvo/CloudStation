# **Challenge Description.**
#### **Goal:** Deploy a web app through Docker, it comprises a container for the front-end (teemii-frontend), and a container for the back-end (teemii-backend).
---
### Prerequisites:
#### The following packages are already installed:
- npm installed.  
- Docker Engine / Docker Desktop installed.

---
### Requirements:
- Use the following Docker image for front-end (FE): 
<span style="color:gray">
dokkaner/teemii-frontend:develop
</span>
- Interface must be accessible from port 8080.
- When containers running Teemii can be accessed at http://localhost:8080


- Use the following Docker image for back-end (BE): 
<span style="color:gray">
dokkaner/teemii-backend:develop
</span>
- BE must be available at port 3000.
- Data must be persistent through a volume in the path
<span style="color:gray">
/data 
</span>
of the container.
---

## Solution:

### **Set everything up**
1. Clone Teemii repository,
```
git clone https://github.com/dokkaner/teemii.git
```

2. Create a Docker Network.
    - This network will allow rhe containers to communicate with each other.
```
    docker network create teemii-network
```

- Verify network is within networks list.

```
docker network ls

# teemii-network is in the list.
```
3. Create Docker Volume.
    - For persistent storage
```
    docker volume create teemii-data
```
- Verify volume exists.
```
docker volume list

# teemii-data volume is in the list.
# It should display the Volume specifics:
# DRIVER - VOLUME NAME
```
<br>

### **Build and Run Backend.**
- Go to <span style="color:gray"> server</span> directory.
```
cd server
```
- Build the Teemii backend Docker image.
```
docker build -t teemii-backend:develop .

# This will create the image.
```

- Run backend container connect it to 
<span style="color:gray"> teemii-network</span> and link it to <span style="color:gray"> teemii-data</span>.
```
docker run -d --name teemii-backend --network teemii-network -v teemii-data:/app/data dokkaner/teemii-backend:develop
```
<br>

### **Build and Run Frontend.**

- Go to <span style="color:gray"> app</span> directory.
```
cd ../app
```
- Build the Teemii frontend Docker image.
```
docker build -t teemii-frontend:develop .
# This will create the image.
```
- Run frontend container and connect it to 
<span style="color:gray"> teemii-network</span>.
```
docker run -d -p 8080:80 --name teemii-frontend --network teemii-network dokkaner/teemii-frontend:develop
```

- Double check both containers are running.
```
docker ps
# teemii-frontend and teemii-backend are with Up status.

```

### **Access Teemii**

- Go to localhost:8080. 
```
http://localhost:8080⁠
```
- Image of localhost:8080
#### [Verification image.](https://github.com/FreCalvo/CloudStation/blob/main/Docker_Fundamentals/Challenge%20_2/docker_run_1.png)

- Delete backend container.

```
docker rm <container id> --force
```
#### [Verification image.](https://github.com/FreCalvo/CloudStation/blob/main/Docker_Fundamentals/Challenge%20_2/docker_rm_backend.png)

-  Run back backend container.
```
 docker run -d --name teemii-backend --network teemii-network -v teemii-data:/app/data teemii-backend
```

#### [Verification image.](https://github.com/FreCalvo/CloudStation/blob/main/Docker_Fundamentals/Challenge%20_2/docker_run_2.png)

### **Stop containers Teemii**


- To stop and remove containers.
```
# Type the following commands in the given order.

docker stop teemii-frontend
docker stop teemii-backend
docker rm teemii-frontend
docker rm teemii-backend
```
