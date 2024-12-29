### **Challenge - Communication between pods in different Namespaces in Kubernetes**

#### **Objective**
1. Create two namespaces, each of them with a deployment of 3 replicas.
2. Each deployment must be exposed through a `Service`of the type `ClusterIP`.
3. Finally, it has to be demonstrated that a `Pod`of `Namespace X`is able to communicate with a `Pod` of `Namespace Y`. All commands used must be indicated.
<br><br>

### **Solution**

#### **Create Namespaces**
- Create two Namespaces,  namespace-1 and namespace-2.
```
kubectl create ns namespace-1

kubectl create ns namespace-2
```
- Verify both namespaces were created.
```
kubectl get ns
```
```
NAME                 STATUS   AGE
namespace-1          Active   13s
namespace-2          Active   7s
```
<br>

#### **Create Deployment files**
- Two deployments with 3 replicas each. One with Nginx image, another one with Redis image.
deploymentNginx.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: namespace-1
spec: 
  replicas: 3
  selector: 
    matchLabels:
      app: nginx
  template: 
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.0
        ports:
        - containerPort: 80
```
deploymentRedis.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  namespace: namespace-2
spec: 
  replicas: 3
  selector: 
    matchLabels:
      app: redis
  template: 
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:6.2.6
        ports:
        - containerPort: 6379
```
- Apply deployment files.
```
kubectl apply -f deploymentNginx.yaml
```
```
kubectl apply -f deploymentRedis.yaml
```
- check deployments were created and are in Ready Status.
```
kubectl get deployments -n namespace-1
```
```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           2m49s
```
```
kubectl get deployments -n namespace-2
```
```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
redis-deployment   3/3     3            3           2m27s
```
- Check 3 replicas of each deployment are Ready.

```
kubectl get pods -n namespace-1
```
```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-698fbd9fb8-2cvx8   1/1     Running   0          5m6s
nginx-deployment-698fbd9fb8-l48w8   1/1     Running   0          5m6s
nginx-deployment-698fbd9fb8-q2gjb   1/1     Running   0          5m6s
```
```
kubectl get pods -n namespace-2
```
```
NAME                                READY   STATUS    RESTARTS   AGE
redis-deployment-5c874f8b9b-9l4sb   1/1     Running   0          4m48s
redis-deployment-5c874f8b9b-vnbjj   1/1     Running   0          4m48s
redis-deployment-5c874f8b9b-xstb9   1/1     Running   0          4m48s
```

#### **Generate clusterIP files**
- Two clusterIP.yaml files are generated, one per Service.
clusterIPNginx.yaml
```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  name: nginx-service
  namespace: namespace-1
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: ClusterIP
status:
  loadBalancer: {}
```
clusterIPRedis.yaml
```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  name: redis-service
  namespace: namespace-2
spec:
  ports:
  - port: 6379
    protocol: TCP
    targetPort: 6379
  selector:
    app: redis
  type: ClusterIP
status:
  loadBalancer: {}
```
- Apply Service files.
```
kubectl apply -f clusterIPNginx.yaml
```
```
kubectl apply -f clusterIPRedis.yaml
```
- Verify Services were created.
```
kubectl get svc -n namespace-1
```
```
NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
nginx-service   ClusterIP   10.96.53.244   <none>        80/TCP    16s
```
```
kubectl get svc -n namespace-2
```
```
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
redis-service   ClusterIP   10.96.209.255   <none>        6379/TCP   5m51s
```
- Obtain detail of each Service.
```
kubectl describe service nginx-service -n namespace-1
```
```
Name:                     nginx-service
Namespace:                namespace-1
Labels:                   <none>
Annotations:              <none>
Selector:                 app=nginx
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.53.244
IPs:                      10.96.53.244
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
Endpoints:                10.244.2.4:80,10.244.1.4:80,10.244.2.3:80
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>
```
```
kubectl describe service redis-service -n namespace-2
```
```
Name:                     redis-service
Namespace:                namespace-2
Labels:                   <none>
Annotations:              <none>
Selector:                 app=redis
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.209.255
IPs:                      10.96.209.255
Port:                     <unset>  6379/TCP
TargetPort:               6379/TCP
Endpoints:                10.244.1.5:6379,10.244.2.5:6379,10.244.2.6:6379
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>
```

<br>

#### **Test communication between namespaces**
- Create temporal Pod in `namespace 2` to test communication with `nginx-service.namespace-1`
```
kubectl run test-pod -n namespace-2 --image=busybox --restart=Never -- sh -c
```
```
kubectl exec -it test-pod -n namespace-2 -- sh
# it opens a shell
```
- Within the shell, verify Service is connected.
```
nslookup nginx-service.namespace-1.svc.cluster.local
```
```
Server:         10.96.0.10
Address:        10.96.0.10:53


Name:   nginx-service.namespace-1.svc.cluster.local
Address: 10.96.53.244
```
- Demonstrate communication. Send HTTP request to `nginx-service` in `namespace-1`
```
wget -qO- http://nginx-service.namespace-1
```
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```