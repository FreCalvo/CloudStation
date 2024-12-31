### **Challenge - All in one**
Fork has to be made from https://github.com/falconcr/kubernetes-todo-app

#### **Objectives**
1. Create a configmap or secrets file to store variables information of each Deployment file.
2. Modify Deployment files  so that they now use variables from configmap or secrets file.
3. Create all necessary resources in a Kubernetes cluster (`minikube`).
4. Ensure all pods are running.
5. Make a short video to demonstrate FE can be accessed and tasks are added.

<br>

---
<br>


### **Solution**

Start a Kubernetes cluster with `minikube`.
```
minikube start
```
<br>

Create configmap.yaml file.
- As env variables to be decoupled are non-confidential data it was chosen the configmap option over the secret one.

- `configmap.yaml`

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-todo-app
data:
  STATS_QUEUE_URI: amqp://stats-queue
  REDIS_HOST: stats-cache
  REDIS_PORT: "6379"
  MONGO_CONNECTION_STRING: mongodb://todos-db
```
<br>
Modify Deployment files  so that they now use variables from configmap.yaml file.

- `stats.yaml`

```
#Before:
env:
    - name: STATS_QUEUE_URI
      value: amqp://stats-queue
    - name: REDIS_HOST
      value: stats-cache
    - name: REDIS_PORT
      value: "6379"

#After:
env:
    - name: STATS_QUEUE_URI
      valueFrom:
        configMapKeyRef:
          name: configmap-todo-app
          key: STATS_QUEUE_URI
    - name: REDIS_HOST
      valueFrom:
        configMapKeyRef:
          name: configmap-todo-app
          key: REDIS_HOST
    - name: REDIS_PORT
      valueFrom:
        configMapKeyRef:
          name: configmap-todo-app
          key: REDIS_PORT
```
<br>

- `front-end.yaml`
```
#Before:
env:
    - name: STATS_QUEUE_URI
      value: amqp://stats-queue

#After:
env:
    - name: STATS_QUEUE_URI
      valueFrom:
        configMapKeyRef:
          name: configmap-todo-app
          key: STATS_QUEUE_URI
```
<br>

- `backend-api.yaml`
```
#Before:
env:
    - name: MONGO_CONNECTION_STRING
      value: mongodb://todos-db

#After:
env:
    - name: MONGO_CONNECTION_STRING
      valueFrom:
        configMapKeyRef:
          name: configmap-todo-app
          key: MONGO_CONNECTION_STRING
```
<br>

Create new namespace: todo-app-challenge.
```
kubectl create ns todo-app-challenge
```
- Ensure namespace was created
```
kubectl get ns 
```
```
NAME                 STATUS   AGE
default              Active   5h
kube-node-lease      Active   5h
kube-public          Active   5h
kube-system          Active   5h
todo-app-challenge   Active   23s
```
<br>
Apply  deployment files in namespace todo-app-challenge.

- `configmap.yaml`
```
kubectl apply -f configmap.yaml -n todo-app-challenge
```
- `stats.yaml`
```
kubectl apply -f stats.yaml -n todo-app-challenge
```
- `mongo-db.yaml`
```
kubectl apply -f mongo-db.yaml -n todo-app-challenge
```
- `backend-api.yaml`
```
kubectl apply -f backend-api.yaml -n todo-app-challenge
```
- `front-end.yaml`
```
kubectl apply -f front-end.yaml -n todo-app-challenge
```
- Ensure all pods are running.
```
kubectl get pods -n todo-app-challenge
```
[pods_running](pods_running.png)

<br>

Open Kubernetes tunnel.
- Open tunnel to access app from 127.0.0.1
```
minikube tunnel
```
[app-in-browser](app-in-browser.png)