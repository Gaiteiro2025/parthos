#!/bin/bash

# Diretório onde o repositório Pathos foi clonado
BASE_DIR="$(dirname "$(pwd)")"
REPO_DIR="$(pwd)"

# Carregar as variáveis do .env local de forma segura
if [ -f "$REPO_DIR/.env" ]; then
   export $(grep -v '^#' "$REPO_DIR/.env" | grep -E '^[A-Za-z_]+=' | xargs)

else
  echo "Aviso: .env não encontrado no diretório $REPO_DIR. Usando valores padrão."
  DB_HOST="db"
  DB_PORT="5432"
  DB_USER="postgres"
  DB_PASS="postgres"
  DB_NAME="nestdb"
  JWT_SECRET="default_secret2"
fi


# Obter o nome de usuário do GitHub configurado localmente
GITHUB_USER=$(git config user.name)

# Verificar se o nome de usuário foi obtido
if [ -z "$GITHUB_USER" ]; then
  echo "Erro: Não foi possível obter o nome de usuário do GitHub. Defina o nome de usuário no Git configurado."
  exit 1
fi

# Lista de repositórios a serem clonados
REPOS=(
  "git@github.com:$GITHUB_USER/parthos-user-api.git"
  "git@github.com:$GITHUB_USER/parthos-task-api.git"
)

# Criar a rede Docker antes de rodar os containers
echo "Criando a rede Docker..."
docker network create parthos-network || true

# Função para clonar, configurar o .env e instalar dependências
clone_and_setup() {
  local repo_url=$1
  local repo_name=$(basename $repo_url .git)
  local repo_path="$BASE_DIR/$repo_name"

  # Verifica se o repositório já foi clonado
  if [ -d "$repo_path" ]; then
    echo "$repo_name já existe. Pulando clone..."
  else
    echo "Clonando o repositório $repo_name..."
    git clone $repo_url $repo_path
  fi

  # Verifica se o repositório foi clonado corretamente
  if [ ! -d "$repo_path" ]; then
    echo "Erro: O repositório $repo_url não foi clonado corretamente. Abortando."
    exit 1
  fi

  # Garante que exista um .env no repositório
  if [ ! -f "$repo_path/.env" ]; then
    echo "Criando .env padrão em $repo_path..."
    echo "DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_USER=${DB_USER}
DB_PASS=${DB_PASS}
DB_NAME=${DB_NAME}
JWT_SECRET=${JWT_SECRET}" > "$repo_path/.env"
  else
    echo ".env já existe em $repo_path. Pulando criação..."
  fi

  # Instala dependências se houver package.json
  if [ -f "$repo_path/package.json" ]; then
    echo "Instalando dependências do $repo_name..."
    cd "$repo_path"
    npm install
  fi

  # Subir os containers Docker do serviço
  if [ -f "$repo_path/docker-compose.yml" ]; then
    echo "Subindo os containers do $repo_name..."
    docker-compose -f "$repo_path/docker-compose.yml" up -d --build
  else
    echo "Aviso: Nenhum docker-compose.yml encontrado em $repo_name. Pulando..."
  fi
}

# Clona e configura cada repositório
for repo in "${REPOS[@]}"; do
  clone_and_setup $repo
done

# Subir os containers da infraestrutura principal
echo "Subindo os containers da infraestrutura..."
docker-compose -f "$REPO_DIR/docker-compose.yml" up -d --build

echo "Ambiente configurado e containers iniciados!"
