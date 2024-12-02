### **Creating a Namespace and one Pod with two containers**

#### **Objective**
- Create a new Namespace named _pokeland_.
- Within this Namespace, create a Pod named _pikachu-pod_ that has two containers.
    - One container executes a basic Nginx application named _nginx-container_.
    - One container executes a basic Redis application named _redis-container_.

#### **Expected Result**
1. Verify the Pod was successfully created:
```
kubectl get pods -n pokeland
```

2. Verify containers logs to ensure they are working:
```
kubectl logs pikachu-pod -c nginx-container -n pokeland

kubectl logs pikachu-pod -c redis-container -n pokeland
```
---

### **Solution**

#### **Cluster**
- Create configuration file.
```
nano <configuration file name>.yaml

#For this example:

nano kind-config.yaml
```
- Use content below:
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    image: kindest/node:v1.31.0
  - role: worker
    image: kindest/node:v1.31.0
  - role: worker       
    image: kindest/node:v1.31.0
```
- Create Cluster.
```
kind create cluster -n <cluster name> --<configuration file name.yaml>

#For this example:

kind create cluster -n k8s-challenge-1 --config kind-config.yaml

# You must be positioned in the folder where config kind-config.yaml is. 
```
- Verify you are in the right context before proceeding further.
```
kubectl config get-contexts
```
The "*" in the Current column indicates the cluster you are at.
```
CURRENT   NAME                   CLUSTER                AUTHINFO               NAMESPACE
*         kind-k8s-challenge-1   kind-k8s-challenge-1   kind-k8s-challenge-1   
```
<br>

#### **Namespace**
- Create namespace.
```
kubectl create ns pokeland
```
- verify namespace was created.
```
kubectl get ns
```
pokeland namespace is shown in the list.
```
NAME                 STATUS   AGE
default              Active   79m
kube-node-lease      Active   79m
kube-public          Active   79m
kube-system          Active   79m
local-path-storage   Active   79m
pokeland             Active   74m
```
<br>
<br>

#### **Pod**
- Create configuration file.
```
nano pikachu-pod.yaml
```
- Use content below:
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod-nginx
    env: local
  name: pikachu-pod
  namespace: pokeland
spec:
  containers:
  - image: nginx
    name: nginx-container
    ports:
    - containerPort: 80
    resources: {}
  - image: redis
    name: redis-container
    ports:
    - containerPort: 6379
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
- Apply Pod.
```
kubectl apply -f pikachu-pod.yaml

# Terminal indicates: pod/pikachu-pod created
```
- Verify Pod was successfully created:
```
kubectl get pods -n pokeland
```
Pikachu-pod Status is Running
```
NAME          READY   STATUS    RESTARTS   AGE
pikachu-pod   2/2     Running   0          13m
```
- Verify container logs for nginx-container to ensure it is working:
```
kubectl logs pikachu-pod -c nginx-container -n pokeland

# Terminal content:
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2024/12/02 01:02:58 [notice] 1#1: using the "epoll" event method
2024/12/02 01:02:58 [notice] 1#1: nginx/1.27.3
2024/12/02 01:02:58 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14) 
2024/12/02 01:02:58 [notice] 1#1: OS: Linux 6.10.4-linuxkit
2024/12/02 01:02:58 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2024/12/02 01:02:58 [notice] 1#1: start worker processes
2024/12/02 01:02:58 [notice] 1#1: start worker process 33
2024/12/02 01:02:58 [notice] 1#1: start worker process 34
2024/12/02 01:02:58 [notice] 1#1: start worker process 35
2024/12/02 01:02:58 [notice] 1#1: start worker process 36
2024/12/02 01:02:58 [notice] 1#1: start worker process 37
2024/12/02 01:02:58 [notice] 1#1: start worker process 38
2024/12/02 01:02:58 [notice] 1#1: start worker process 39
2024/12/02 01:02:58 [notice] 1#1: start worker process 40
```

- Verify container logs for redis-container to ensure it is working:
```
kubectl logs pikachu-pod -c redis-container -n pokeland

# Terminal content:
1:C 02 Dec 2024 01:02:58.944 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 02 Dec 2024 01:02:58.944 * Redis version=7.4.1, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 02 Dec 2024 01:02:58.944 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 02 Dec 2024 01:02:58.945 * monotonic clock: POSIX clock_gettime
1:M 02 Dec 2024 01:02:58.947 * Running mode=standalone, port=6379.
1:M 02 Dec 2024 01:02:58.947 * Server initialized
1:M 02 Dec 2024 01:02:58.947 * Ready to accept connections tcp
```