FROM elixir:1.8.0

# Allow builds to occur for different mix environments, default to dev.
ARG environment=dev
ENV MIX_ENV=${environment}

# Install Hex and Phoenix
RUN mix local.hex --force
RUN mix local.rebar --force

# Install node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q inotify-tools nodejs

# Create folder for Application to live
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Elixir Dependencies
RUN mix deps.clean --all
RUN mix deps.get
