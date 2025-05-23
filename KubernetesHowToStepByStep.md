# Deployment of PetClinic to Kubernetes via Killercoda

## Steps Taken

1. **Initialize Kubernetes playground on Killercoda.**
2. **Create a Namespace:**

   ```bash
   kubectl create namespace petclinic
   ```
3. **Create Deployment using GitHub Container Registry image:**

   ```bash
   kubectl create deployment petclinic \
     --image=ghcr.io/mklemmingen/pet-clinic_bettercodepaul_sose2025:latest \
     --replicas=1 \
     -n petclinic
   ```
4. **Expose the Deployment via NodePort:**

   ```bash
   kubectl expose deployment petclinic \
     --type=NodePort \
     --name=petclinic-service \
     --port=8080 \
     --target-port=8080 \
     -n petclinic
   ```

## Issues Faced

* **ImagePullBackOff errors:** The container image was updated, but Kubernetes pods still used the old version.
* **Failed secondary container:** `pet-clinic-bettercodepaul-sose2025-rpgpp` exited with code 1.
* **502 Gateway errors from Killercoda link.**

## Solutions

* Fixed Dockerfile: ensured `CMD` included `--server.port=8080` and added `EXPOSE 8080`.
* Rebuilt the image and pushed to GitHub Container Registry.
* Applied the updated `deployment.yaml`:

  ```bash
  kubectl apply -f deployment.yaml
  kubectl delete pod -n petclinic --all
  ```
* Waited until both containers were `READY` before accessing.
* Accessed the app via:

  ```
  https://<session>-<nodeIP>-<port>.spca.r.killercoda.com/
  ```

## Tips

* Always delete pods after reapplying the deployment to pull the updated image.
* Check logs with:

  ```bash
  kubectl logs -n petclinic -l app=petclinic
  ```
* Use:

  ```bash
  kubectl get pod -o wide -n petclinic
  ```

  to find the internal IP for Killercoda URLs.
