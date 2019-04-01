# Sample Microservice Application

Stan's Robot Shop is a sample microservice application you can use as a sandbox to test and learn containerised application orchestration and monitoring techniques. It is not intended to be a comprehensive reference example of how to write a microservices application, although you will better understand some of those concepts by playing with Stan's Robot Shop. To be clear, the error handling is patchy and there is not any security built into the application.

This sample microservice application has been built using these technologies:
- NodeJS ([Express](http://expressjs.com/))
- Java ([Spark Java](http://sparkjava.com/))
- Python ([Flask](http://flask.pocoo.org))
- Golang
- PHP (Apache)
- MongoDB
- Redis
- MySQL ([Maxmind](http://www.maxmind.com) data)
- RabbitMQ
- Nginx
- AngularJS (1.x)

The various services in the sample application already include all required New Relic components installed and configured. The New Relic components provide automatic instrumentation for complete end to end visibility into your deployed stack.

## Build from Source
To optionally build from source (you will need a newish version of Docker to do this) use Docker Compose. Optionally edit the *.env* file to specify an alternative image registry and version tag; see the official [documentation](https://docs.docker.com/compose/env-file/) for more information.

    $ docker-compose build

If you modified the *.env* file and changed the image registry, you may need to push the images to that registry

    $ docker-compose push

## Run Locally
You can run it locally for testing.

If you did not build from source, don't worry all the images are on Docker Hub. Just pull down those images first using:

    $ docker-compose pull

Fire up Stan's Robot Shop with:

    $ docker-compose up

## Acessing the Store
If you are running the store locally via *docker-compose up* then, the store front is available on localhost port 8080 [http://localhost:8080](http://localhost:8888/)

If you are running the store on Kubernetes via minikube then, to make the store front accessible edit the *web* service definition and change the type to *NodePort* and add a port entry *nodePort: 30080*.

    $ kubectl -n robot-shop edit service web

Snippet

    spec:
      ports:
      - name: "8080"
        port: 8080
        protocol: TCP
        targetPort: 8080
        nodePort: 30080
      selector:
        cloudProvider: web
      sessionAffinity: None
      type: NodePort

The store front is then available on the IP address of minikube port 30080. To find the IP address of your minikube instance.

    $ minikube ip

If you are using a cloud Kubernetes / Openshift / Mesosphere then it will be available on the load balancer of that system. There will be specific blog posts on the Instana site covering these scenarios.

## Load Generation
A separate load generation utility is provided in the *load-gen* directory. This is not automatically run when the application is started. The load generator is built with Python and [Locust](https://locust.io). The *build.sh* script builds the Docker image, optionally taking *push* as the first argument to also push the image to the registry. The registry and tag settings are loaded from the *.env* file in the parent directory. The script *load-gen.sh* runs the image, edit this and set the HOST environment variable to point the load at where you are running the application. You could run this inside an orchestration system (K8s) as well if you want to, how to do this is left as an exercise for the reader.
