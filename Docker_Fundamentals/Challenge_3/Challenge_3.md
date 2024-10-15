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

1. Clone the Teemii repository.
```
 git clone https://github.com/dokkaner/teemii.git
```
2. Navigate to the Teemii directory.
```
cd teemii
```
3. Ensure the docker-compose.yml has the content specified below.
```
version: '3.8'

services:
  teemii-frontend:
    image: dokkaner/teemii-frontend:develop
    build: ./app
    ports:
      - "8080:80"
    networks:
      - teemii-network
    environment:
      - VITE_APP_TITLE=Teemii
      - VITE_APP_PORT=80

  teemii-backend:
    image: dokkaner/teemii-backend:develop
    build:
      context: ./server
    volumes:
      - teemii-data:/data
    networks:
      - teemii-network
    environment:
      - EXPRESS_PORT=3000
      - SOCKET_IO_PORT=1555

networks:
  teemii-network:
    driver: bridge
volumes:
  teemii-data:
    name: teemii-data

# See file docker-compose.yml
```
4. Build and Start the containers.
```
docker compose up -d
# -d: to run in the background.
```
5. Access Teemii.
```
http://localhost:8080
```
- When running completes you should see:
```
# Network teemii_teemii-network >> Created
# Volume "teemii-data"  >> Created
# Container teemii-teemii-backend-1  >> Started
# Container teemii-teemii-frontend-1  >> Started  
```
6. Stop and remove containers and network.
```
docker compose down
```
