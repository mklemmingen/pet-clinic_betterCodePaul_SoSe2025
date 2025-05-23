# Petclinic Kubernetes Deployment Report

## Steps Taken

1. Initialized Kubernetes playground on Killercoda
2. Created namespace:

   ```bash
   kubectl create namespace petclinic
   ```
3. Created deployment:

   ```bash
   kubectl create deployment petclinic \
     --image=ghcr.io/mklemmingen/pet-clinic_bettercodepaul_sose2025:latest \
     --replicas=1 \
     -n petclinic
   ```
4. Exposed the deployment as a NodePort service:

   ```bash
   kubectl expose deployment petclinic \
     --type=NodePort \
     --name=petclinic-service \
     --port=8080 \
     --target-port=8080 \
     -n petclinic
   ```
   
5. GET IP and PORT

```bash
kubectl get service petclinic-service -n petclinic
```

## Issues Encountered

* `ImagePullBackOff` errors due to old images
* Second container inside pod kept restarting with code 1
* Deployment didn’t reflect new Docker image after re-push
* Access via Killercoda URL returned 502

## Solutions

* Updated `Dockerfile` to include `EXPOSE 8080` and fixed `CMD`:

  ```dockerfile
  FROM maven:3.6.0-jdk-11-slim

  WORKDIR home

  COPY target/spring-petclinic*.jar .

  CMD java -Xmx512m -Xms512m -jar spring-petclinic*.jar --server.port=8080
  EXPOSE 8080
  ```
* Applied updated deployment with:

  ```bash
  nano deployment.yaml
  ```

  Paste this content:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: petclinic
    namespace: petclinic
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: petclinic
    template:
      metadata:
        labels:
          app: petclinic
      spec:
        containers:
          - name: petclinic
            image: ghcr.io/mklemmingen/pet-clinic_bettercodepaul_sose2025:latest
            ports:
              - containerPort: 8080
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: petclinic-service
    namespace: petclinic
  spec:
    type: NodePort
    selector:
      app: petclinic
    ports:
      - port: 8080
        targetPort: 8080
        nodePort: 30635
  ```

  Then apply with:

  ```bash
  kubectl apply -f deployment.yaml
  ```
* Deleted pods to force re-pull of image:

  ```bash
  kubectl delete pod -n petclinic --all
  ```
* Verified logs:

  ```bash
  kubectl logs -n petclinic -l app=petclinic
  ```

## Outcome

Application runs correctly with 2/2 containers healthy. Accessible via provided Killercoda service endpoint (NodePort).
