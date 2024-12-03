### **Challenge - "The Cloudy Station"**

#### **Description**
Protect one node of your Kubernetes cluster, avoiding pods to be programed within it... Except for the ones with the courage to tolerate "The Cloudy Station".
<br><br>

#### **Objective**
1. __First mission:__ Impose the magic Taint over node `k8s4devs-worker2` with key and value `cloud-station:true` and effect `NoSchedule`.
2. __Second mission:__ Create a brave pod with the necessary tolerancy to survive in "The Cloudy Station". This pod must be able to be programed in the node protected by the Taint.
<br><br>

#### **Command Tip**
To establish the Taint, Kubernetes Masters employ a command like this one:
```
kubectl taint nodes <node_name> <key1>=<value1>:<taint_effect>
```
---
<br><br>

### **Solution**
#### **Create Cluster.**
- Create configuration file.
```
nano kind-config.yaml
```
- Use the content below:
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
kind create cluster -n k8s4devs --config kind-config.yaml
```
- Verify Cluster was created.
```
kubectl config get-contexts 
```
```
Terminal answer:

CURRENT   NAME                   CLUSTER                AUTHINFO               NAMESPACE
  *         kind-k8s4devs          kind-k8s4devs          kind-k8s4devs                 
```
- Check nodes are Ready.
```
kubectl get nodes
```
```
Terminal answer:

NAME                     STATUS   ROLES           AGE   VERSION
k8s4devs-control-plane   Ready    control-plane   13d   v1.31.0
k8s4devs-worker          Ready    <none>          13d   v1.31.0
k8s4devs-worker2         Ready    <none>          13d   v1.31.0
```

#### **Apply Taint.**
- Enter the following command:
```
 kubectl taint nodes k8s4devs-worker2 cloud-station=true:NoSchedule
```
```
Terminal answer:

node/k8s4devs-worker2 tainted
```
- Verify Taint.
```
kubectl describe node k8s4devs-worker2 | grep Taints
```
```
Terminal answer:

Taints:             cloud-station=true:NoSchedule
```

#### **Create Namespace**
- Create namespace.
```
kubectl create ns cloudstation
```

```
Terminal answer:

namespace/cloudstation created
```

- Verify namespace was created.
```
kubectl get ns
```

```
Terminal answer:

NAME                 STATUS   AGE
cloudstation         Active   82s
```
<br>

#### **Create Pod**
- Create configuration file.
```
kubectl run pod-cloudy-station -n cloudstation --image=nginx --dry-run=client -oyaml > pod-cloudy-station.yaml
```
- File `pod-cloudy-station.yaml` is created with the following content:
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod-cloudy-station
  name: pod-cloudy-station
  namespace: cloudstation
spec:
  containers:
  - image: nginx
    name: pod-cloudy-station
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
- Modify file `pod-cloudy-station.yaml` to add tolerance for "The Cloudy Station".
```
nano pod-cloudy-station.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod-cloudy-station
  name: pod-cloudy-station
  namespace: cloudstation
spec:
  containers:
  - image: nginx
    name: pod-cloudy-station
    resources: {}
  tolerations:  # New line added.
  - key: "cloud-station"  # New line added.
    operator : "Equal"  # New line added.
    value: "true"  # New line added.
    effect: "NoSchedule"  # New line added.
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
- Apply configuration in `pod-cloudy-station.yaml`.
```
kubectl apply -f pod-cloudy-station.yaml
```
```
Terminal answer:

pod/pod-cloudy-station created
```
- Check Pods were created.
```
kubectl get pods -n cloudstation
```

```
Terminal answer:

NAME                 READY   STATUS    RESTARTS   AGE
pod-cloudy-station   1/1     Running   0          100s
```