FROM ruby:3.3.4-slim

# Instala dependências do sistema operacional
# (incluindo libpq-dev para o PostgreSQL e dependências de compilação)
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  curl \
  git \
  && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o Gemfile e o Gemfile.lock primeiro (importante para cache e consistência)
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN bundle install --jobs 4 --retry 3

# Copia o restante do código do projeto para o container
COPY . .

# Expõe a porta padrão do Rails
EXPOSE 3000

# Script de entrada para resolver problemas com o server.pid do Rails
COPY bin/docker-entrypoint.sh /usr/bin/
RUN sed -i 's/\r$//' /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Comando padrão ao iniciar o container do app
CMD ["rails", "server", "-b", "0.0.0.0"]