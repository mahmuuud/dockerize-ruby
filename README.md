# dockerize-ruby 🐳

## Introdcution
> In this Repo. I provide a simple reference to dockerize a simple Ruby application which uses Redis, Postgres-db as databases, Nginx and unicorn as a reverse proxy and HTTP servers. 

## Description:
* Looking at the project requirements at a glance, sounds like alot of dependencies and packages to be installed, Deployment must be a hassle right? what if I told you that you could get this application running in let that a handy of minutes? This is exactly what contenarizing an application is about (Sure there are some other benefits), In this project we have used Docker to package the Ruby app along with all the other dependencies, then we took this an extra mile and used Docker-compose to ensure the process is more smooth as we have alot of services which wil need some extra work if all installed on just one container. so doing so with docker-compose gave us the ability to use a separate container for each service and then linking all of them to make one solid stack for our application.

* We have decided to take an extra edge and use Kubernetes as an orchasteration tool for our containers, which could provide alot of features out of the box like loadbalancing, health checks and even the routing between the containers for free.

## Requirements:
* [Docker](https://www.docker.com/get-started)
* [docker-compose](https://docs.docker.com/compose/install/)
* [Kubernetes](https://kubernetes.io/docs/tasks/tools/)

## Installation:
* To run the application as standalone docker-compose stack, simply run `docker-compose up` at the project's root directory, too nice to be true right?
* For Kuberenetes, First we need to build the 2 images which are not currrently present remotely using `docker build -t drikq .` and `dockeer build -t nginx-drikq -f Dockerfile.nginx .`
* To deploy the application to your default Kuberenetes' cluster navigate to `Kubernetes-Files` and run `kubectl apply -f drkiq-claim0-persistentvolumeclaim.yaml,drkiq-deployment.yaml,drkiq-postgres-persistentvolumeclaim.yaml,drkiq-redis-persistentvolumeclaim.yaml,drkiq-service.yaml,nginx-deployment.yaml,nginx-service.yaml,postgres-deployment.yaml,postgres-service.yaml,redis-deployment.yaml,redis-service.yaml,sidekiq-deployment.yaml,env.yaml`.
* When running the application inside Kubernetes cluster you could make sure that all the pods are Running with no errors by using `kubectl get pods` or if you want to try the application on your own run `kubectl describe svc nginx` to get the node port which is used by the Nginx service to communicate with outside the cluster then you could access the app from your browser using `localhost:<NodePort>`.
* To try the running application running from docker-compose, simply navigate to `localhost:8020` which is the endpoint for Nginx service, the entry point to our application.

## Design at a glance ✨:
> The `docker-compose` is quite simple for anyone who has used it before, all what we do is to spin up containers for the services we are using, mount volumes for data persistence for the databases as containers are stateless, then we link both of the databases' containers to our app container in order for the database connection to happen.

> However the Kubernetes part had some challenges like it's always the case with Kubernetes right? I had to configure the Nginx service to be a `NodePort` service instead of the default `ClusterIP` mode which limits our pod visibility to inside the cluster only, this is a good practice for the other services as we don't want them visible outiside the cluster. But this is not exactly the case for the Nginx service as we want to access the application from our browser (which technically resides outside the cluster) so I have used `NodePort` for this specific service and it worked!
The other challenge was that mounting a volume for our application's.
For the environment variables, I prefered to use `config map` to pass the environment variables to the containers for its benefits specially changing these values on runtime without having to restart the deployment.

## Reference 📕:
* [Dockerizing a Ruby on Rails Application](https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application)