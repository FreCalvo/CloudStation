### **Deployment and Update of a Kubernetes Deployment**
#### **Objective**
- Create a NGINX Deployment and then update it through Rolling Update strategy, while update history is registered.

#### **Steps**
1. Create initial Deployment.
    - Create a deployment named `nginx-deployment` in the namespace `cloudstation` with 3 replicas of image `nginx:1.26.2`.

2. Update Deployment using Rolling Update strategy.
    - Update Deployment to version `nginx:1.27.1`. Use the option `--record` to register in the revisions history.
    - Verify the update succeeded.
    ```
    kubectl rollout status deployment/nginx-deployment --namespace=cloudstation
    ```

3. Check the revisions history.
4. Describe the Deployment.
5. Document the steps.
    - Create a file to document all the steps named `deployment-update.md`.
---
<br>

### **Solution**

#### **Namespace**
- Create namespace.
```
kubectl create ns cloudstation
```
- verify namespace was created.
```
kubectl get ns
```
cloudstation namespace is shown in the list.
```
NAME                 STATUS   AGE
cloudstation         Active   10s
```
<br>

#### **Deployment**
- Create Deployment.
```
kubectl create deployment nginx-deployment -n cloudstation --image=nginx:1.26.2 --replicas=3 --dry-run=client -oyaml > challenge-deployment.yaml
```
- Check challenge-deployment.yaml was created and right nginx is assigned.
```
cat challenge-deployment.yaml
```
See verification image:[nginx:1.26.2](images/nginx1.26.1.png)

- Apply configuration.
```
kubectl apply -f challenge-deployment.yaml

# Terminal indicates: deployment.apps/nginx-deployment created
```

- Check Pods were created.
```
kubectl get pods -n cloudstation

# Terminal indicates: All three Pods are Running
```
```
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-58869d8644-dd6px   1/1     Running   0          12m
nginx-deployment-58869d8644-gvt45   1/1     Running   0          12m
nginx-deployment-58869d8644-pv76k   1/1     Running   0          12m
```

#### **Update Deployment**

- Update Deployment using Rolling Update strategy.
```
kubectl set image deployment/nginx-deployment nginx=nginx:1.27.1 -n cloudstation --record

# Terminal indicates: deployment.apps/nginx-deployment image updated
```
```
NAME                                READY   STATUS              RESTARTS   AGE
nginx-deployment-58869d8644-gvt45   0/1     ContainerCreating   0          4s
nginx-deployment-58869d8644-pv76k   1/1     Running             0          13s
nginx-deployment-dcbffc8bb-9hn57    1/1     Running             0          19m
nginx-deployment-dcbffc8bb-z5mjj    1/1     Running             0          19m
nginx-deployment-58869d8644-gvt45   1/1     Running             0          8s
nginx-deployment-dcbffc8bb-9hn57    1/1     Terminating         0          19m
nginx-deployment-58869d8644-dd6px   0/1     Pending             0          0s
nginx-deployment-58869d8644-dd6px   0/1     Pending             0          0s
nginx-deployment-58869d8644-dd6px   0/1     ContainerCreating   0          0s
nginx-deployment-dcbffc8bb-9hn57    0/1     Completed           0          19m
nginx-deployment-58869d8644-dd6px   1/1     Running             0          1s
nginx-deployment-dcbffc8bb-z5mjj    1/1     Terminating         0          19m
nginx-deployment-dcbffc8bb-9hn57    0/1     Completed           0          19m
nginx-deployment-dcbffc8bb-9hn57    0/1     Completed           0          19m
nginx-deployment-dcbffc8bb-z5mjj    0/1     Completed           0          19m
nginx-deployment-dcbffc8bb-z5mjj    0/1     Completed           0          19m
nginx-deployment-dcbffc8bb-z5mjj    0/1     Completed           0          19m
```
```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-58869d8644-dd6px   1/1     Running   0          27s
nginx-deployment-58869d8644-gvt45   1/1     Running   0          35s
nginx-deployment-58869d8644-pv76k   1/1     Running   0          44s
```
- Check the Pods status
```
kubectl get pods --watch -n cloudstation
```

#### **Check Revision History**
- Check revision history of nginx-deployment.
```
kubectl rollout history deployment/nginx-deployment -n cloudstation
```
 
 #### **Describe the Deployment**
 - Look for the Description of one of the recently created Pods
 ```
kubectl describe pod nginx-deployment-58869d8644-dd6px -n cloudstation
```
See verification image: [nginx:1.27.1](images/nginx1.27.1.png)


#### **Document the Steps**
- This file is intended to document all the steps for this challenge.