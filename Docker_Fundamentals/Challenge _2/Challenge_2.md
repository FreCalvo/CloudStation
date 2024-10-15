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

### **Pull BE and FE images from Docker Repository**
1. Create a Docker Network.
    - This network will allow rhe containers to communicate with each other.
```
    docker network create teemii-network
```

- Verify network is within networks list.

```
docker network ls

# teemii-network is in the list.
```
2. Create Docker Volume.
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

3. Pull Backend image.
    - Pull the backend image from Dockerhub.
```
    docker pull dokkaner/teemii-backend:develop
```
4. Pull Frontend image.
    - Pull the frontend image from Dockerhub.
```
    docker pull dokkaner/teemii-frontend:develop
```
- Check images were properly created.
```
docker images

# It should display the image specifics.
# REPOSITORY-TAG-IMAGE ID-CREATED-SIZE

# dokkaner/teemii-frontend is present.
# dokkaner/teemii-backend is present.
```
### **Run Containers**
- Run backend container connect it to 
<span style="color:gray"> teemii-network</span> and link it to <span style="color:gray"> teemii-data</span>.
```
docker run -d --name teemii-backend --network teemii-network -v teemii-data:/app/data dokkaner/teemii-backend:develop

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

### **Stop containers Teemii**

- To stop and remove containers.
```
# Type the following commands in the given order.

docker stop teemii-frontend
docker stop teemii-backend
docker rm teemii-frontend
docker rm teemii-backend
```


