# build our Images and tag them
# we need 2 tags:
# - latest, as this is a reference of Images in our K8s config files
# - unique (GIT SHA), so that latest Image can be imperatively set to deploy (see below)
docker build -t skrlivoj/multi-client:latest -t skrlivoj/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t skrlivoj/multi-server:latest -t skrlivoj/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t skrlivoj/multi-worker:latest -t skrlivoj/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push Images to Docker Hub
docker push skrlivoj/multi-client:latest
docker push skrlivoj/multi-server:latest
docker push skrlivoj/multi-worker:latest
docker push skrlivoj/multi-client:$SHA
docker push skrlivoj/multi-server:$SHA
docker push skrlivoj/multi-worker:$SHA

# apply all configs in the "k8s" folder
kubectl apply -f k8s

# imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=skrlivoj/multi-server:$SHA
kubectl set image deployments/client-deployment client=skrlivoj/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=skrlivoj/multi-worker:$SHA
