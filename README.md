## Description

This template repository includes a basic setup for using Docker to run RSpec tests, Pry, and Ruby scripts using Ruby 2.6.5.

To use Docker, you will first need to [install](https://docs.docker.com/get-docker/) it. Once it's installed, Docker should be open so you can actually run Docker commands in the terminal.

## Running IRB

You don't need this setup for running IRB (Ruby REPL) by itself. To use IRB on its own, do the following (after Docker is installed and open):

```
$ docker pull ruby:2.6.5
```

This pulls down the image of Ruby we use at Epicodus. You only need to do this once.

Once you have it on your machine, you can run IRB with the following command:

```
$ docker run -it ruby:2.6.5 irb
```

We recommend creating an alias (called something like `dirb` for Docker IRB) to make the command easier to use.

You can exit IRB as normal by typing `exit`.

## Using This Repository for Docker

This repository is a template repository. To use it, start by creating a new repository with `ruby-rspec-docker-container` as a template. Clone that repository down to your desktop.

The repository contains a simple project that tests a simple `title_case` method. To run tests on the current code, simply run the command `docker-compose up` in the root directory of this project.

To run tests on your own code, replace the `lib` and `spec` directories with your own source code (for `lib`) and tests (for `spec`).

We recommend creating an alias for the following commands. The alias should look something like this:

```
dspec ()
{
  docker-compose down
  docker-compose up --build
  docker-compose run --rm app
}
```

With this alias, the `dspec` command will automatically run RSpec tests. You can use `binding.pry` as needed.

### Running Scripts

Running scripts is optional at Epicodus. However, if you want to experiment with it, follow these steps:

- The script must be located in `lib` and be called `script.rb`.

- Run the following command: `docker-compose run --rm app ruby lib/script.rb`.

Once again, we recommend aliasing this command if you plan to run scripts often. If you prefer to name your script something else, you just need to update the command to use the correct path and file name.

---

How Our Docker Configuration Works Pt. 1

Everything from here on out in this lesson is optional. However, Docker is an important development tool at many tech companies, and the more you learn about the basics, the better! That being said, the priority right now is learning Ruby - so feel free to skip this section and come back to it later (or skip it and don't come back to it at all) if you want to prioritize learning Ruby. You will never be tested on Docker configuration on independent projects. But you will be accountable for your personal environment and for submitting a working project - whether you are using a Docker configuration or not.

There are two files that are related to our Docker configuration:

    Dockerfile: This file contains all the commands needed to assemble a container image.

    docker-compose.yaml: This file contains the necessary configuration to run a container image.

Dockerfile

As we just mentioned, the Dockerfile includes all the commands necessary for assembling our container.

Let's take a look:
Dockerfile

FROM ruby:2.6.5
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

CMD ["bundle", "exec", "rspec"]

Now let's walk through these commands one by one.

    A Dockerfile always starts with a FROM command. This creates a base image that we can then configure further. Generally, we'll pull this starting image from one of many public repositories that Docker provides. An image could contain the necessary environment for developing in a specific language (such as Ruby, Python, or C#). That's what our Dockerfile starts with: the specific version of Ruby we want to use. However, a starting image could also have many layers. For instance, we could create a starting image that has Ruby, Rails, Postgres, and other tools which we could then share with our team.

    Next, we use the WORKDIR command to set a working directory for commands such as RUN and CMD. It doesn't matter what we call it but Docker recommends using WORKDIR so Docker always knows where the root of the project is.

    The COPY command copies files from the local project into the container. In this case, we copy the Gemfile and Gemfile.lock files (which are necessary for the specific configuration of our project and includes tools like RSpec and Pry).

    The RUN command does exactly what it sounds like: runs a specified command. In this case, the command is bundle install. The bundle install command works much like npm install. It downloads gems specified in our Gemfile, installs them in the local project, and updates the Gemfile.lock with specified versions (much like package-lock.json).

    Next, we COPY again - this time, we copy . (all) into /myapp (the working directory we created).

    Finally, CMD runs the specified command or commands. It's common to see this in an array that represents multiple arguments. If we were just using Ruby without Docker, we'd type bundle exec rspec into the terminal. The only difference here with CMD is that each word in the command is separated into a different array element. While we can run rspec on its own, it's always safer to prepend it with bundle exec as it ensures that only the gems (libraries) local to the project are used when the command is run.

Now let's take a look at our docker-compose.yaml file.
docker-compose.yaml

While the Dockerfile has instructions on building an image, the docker-compose.yaml has instructions on running an image. Our current docker-compose.yaml is very simple:
docker-compose.yaml

version: "3.9"
services:
app:
build: .

    The version specifies the version of docker-compose we should be using. Here, the version is set to "3.9".

    The services section is all the services the application needs to run. For instance, it's common to see a web service that includes information about running a web application as well as services for databases. We will be including that functionality in the future but for now we just have basic functionality related to app. app is just the name of the service and it could be anything. We'll discuss where it's used in just a moment.

    build specifies what should get built when we run docker-compose up (when we first run a project) or when we run docker-compose up --build (when we want the image to reflect any code changes in our project). In this case, it's set to .. Everything should be built!

Because we are only running one container, we technically could do everything with just a Dockerfile right now. But when we are running multiple containers (such as when we use a database), docker-compose will make our lives much easier. For that reason, that's why we are including a docker-compose.yaml file now and getting familiar with docker-compose commands.
Docker Commands

Finally, let's take a look at the Docker commands we've mentioned in this lesson and what exactly they are doing.

    $ docker-compose up: When we run this command, Docker will look at docker-compose.yaml for any instructions needed to run the image. In this particular case, the command will build the image using the instructions in the Dockerfile, create a service called app and expose an environmental variable called script.

    $ docker-compose up --build: Docker uses caching so if we just run $ docker-compose up, Docker might not update our image to reflect updated code.

    $ docker pull: This specifies that Docker should pull a publicly available image for use as the image's base layer. In our particular case, we are pulling ruby-2.6.5 to use with IRB.

    $ docker run: We can also run Docker commands without using docker-compose, which is exactly what we do with the following command: docker run -it ruby:2.6.5 irb. This instructs Docker to run a specified image. The -it flag states that it should be an interactive shell, which is exactly what we need to run IRB. As we can see in this case, we are passing two arguments into $ docker run: the name of the image (ruby:2.6.5, which we've pulled from Docker) and the process we want to run (irb). Note that the flags are options, not arguments.

    $ docker-compose down: In the dspec/rspec alias, we use this command. $ docker-compose down is essentially the opposite of $ docker-compose up. It winds down the image so it's no longer running. Why do we have to do this? Well, that's a good question. The image we use is a one-off, which means it runs tests or a script and then stops instead of running continuously. There should be a need for $ docker-compose down. However, it's possible that a process could be continuously running such as if it's stuck in a breakpoint so it's good to start our alias with $ docker-compose down just in case.

    $ docker-compose run: We can use this command to run a service we've included in our docker-compose.yaml file. In our dspec/rspec alias, we include the following command: $ docker-compose run --rm app. This is where it's very helpful that we named our service - we can specify that it's the app service we want to run. The --rm flag specifies that the image should be removed after we are done with the one-off command. This is useful to ensure that we don't have stray images hanging around and taking up space on our machines.

How Our Docker Configuration Works Pt. 2

Once again, this content is optional. You are not required to know what every line in a Dockerfile and docker-compose.yaml file does. However, you may be interested in learning this content and it will help improve your understanding of Docker.

Let's start by looking at docker-compose.yaml.
docker-compose.yaml

version: '3.9'
services:
web:
volumes: - .:/myapp
build: .
ports: - "4567:4567"
stdin_open: true
tty: true

We are already familiar with version and services. Note that we call our service web here. We could call it app but it's common to call it web since it corresponds to a web application. We are also familiar with the build: . line. However, everything else is new.
Using volumes for live reloading code

First, what's the deal with volumes?
docker-compose.yaml

    volumes:
      - .:/myapp

Well, Docker volumes are used for persistence. We'll be using them in future sections with our databases. But we aren't using databases yet, so what's the point here? Well, if we didn't include this, we wouldn't be able to live update our code in Docker. Here, we are specifying that we should mount /myapp in a volume on the container. /myapp is the working directory we specify in our Dockerfile. So every time we update our code, the volume will update as well, allowing us to live reload our code. Without this, we'd need to run docker-compose down and then docker-compose up --build every time we make even a tiny change to our code. That would be extremely tedious and make development quite unpleasant.
Using ports so our browser can interact with Docker

Next, we have a ports property:
docker-compose.yaml

    ports:
      - "4567:4567"

When we run a local server that hosts a Sinatra application, we will do so on port 4567. The port number is arbitrary but this is the default port for Sinatra so that's why we are using it. If we were running a local server on our machine without Docker, we could just open up that port in localhost:4567. However, a Docker container is sealed off from our machine. It runs on our operating system but it's totally self-contained. We can't just run localhost:4567 inside our container and then run it in our browser. That's because Sinatra is running in our Docker container while our browser is on our local machine. They are two separate environments.

What the ports configuration option does is allow us to map a port within the container to a port outside of the container. The format for this is HOST:CONTAINER. So the part to the left of the colon is the port that should be opened for our local machine (so we can run our application in the browser) while the part on the right is the port that's being used inside the container.

Let's actually take a quick look at the last line of our Dockerfile to see how this all connects:
Dockerfile

...
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]

This command runs our local server. We'll cover the entire command soon, but for now we'll just focus on the last part of it: "-p", "4567". We specify that the local server should use 4567 because that's what Sinatra typically uses. So when our container spins up a server, it does so on port 4567 - the second part of the 4567:4567 in the HOST:CONTAINER format. Then, when we open up localhost:4567 in our browser, we are using the port that we've instructed docker-compose.yaml to open - the part to the left of the colon in the HOST:CONTAINER format. We could specify a completely different port number in the CMD above such as "-p", "5000". If we did so we'd update the ports configuration to 4567:5000. Then, if we decided we actually wanted to use localhost:4000 in our browser, we'd update the ports configuration to 4000:5000. You can poke around with this as you wish, but the reason everything is mapped to 4567 is to keep this as true to the experience of running a local server on your machine as possible. Once again, since Sinatra uses localhost:4567 by default, that's what we are using, too.

By the way, there's a specific name for mapping a port in one place to a port in another place: port forwarding. If you end up working with servers a lot, this is an important concept.
Using stdin_open and tty for breakpoints

Finally, we have the following configuration options:
docker-compose.yaml

...
stdin_open: true
tty: true

stdin is short for standard input. tty is short for teletype (also known more familiarly to us as a terminal). These configuration options are both related to the command line. Specifically, when we have a stream of data, such as the data coming from the server running in a Docker container, we'll sometimes need to stop this stream of data (using Pry breakpoints) to evaluate the value of variables, methods, and objects in the current scope of the breakpoint. We do that by attaching to the Docker container running the server. However, for this attached process to actually be interactive when we hit a breakpoint, we need these two configuration options to be true.
Dockerfile

Next, let's take a look at our Dockerfile. Everything is review (from our configuration for running RSpec tests) except for the final two lines.
Dockerfile

FROM ruby:2.6.5

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]

Let's jump right to the last two lines.

First, we EXPOSE 4567. Exposing a port is actually optional. It is mostly documentation for other developers that this is the port that they should use when interacting with the container. We specify 4567 because, as we discussed previously, this is the default port Sinatra uses for localhost.

Next, we have the CMD Docker should run. bundle exec is important for ensuring that gems local to our project are the ones Ruby uses when we run our command, preventing potential library conflicts. But what about the next part? rackup is a Rack command. You don't need to know about Rack for this course but here's a very basic overview - it's an interface between Ruby web servers and Ruby applications that makes it easy for applications to work with any Ruby web server. (Interfaces between servers and applications are a type of middleware - but we won't get into middleware now.) So the rackup command just tells the server to start up. The config.ru in our Sinatra applications is a Rackup configuration file.

Next, let's look at the host configuration, which is 0.0.0.0. This is pretty much telling Docker to listen for all interfaces on our computer's local network. Why is this important? 0.0.0.0 is special. It essentially is no specific address - unlike 127.0.0.1, the localhost IP for most computers. In this context, when we specify 0.0.0.0, it means we are asking Docker to listen to all network interfaces - not specific IPs. This is the easiest way to ensure that the server in our Docker container actually receives requests from the browser on our local machine. Otherwise, the local server in the container might be listening for communication from one IP while our local machine is sending messages from another IP.

As far as the port flag, we've already covered that. Ultimately, if any of this content related to networking doesn't make sense, that's fine. This is all bonus content and you'll never be tested on it or expected to know all these details while you are at Epicodus.
