#!/bin/bash

# Diretório onde o repositório parthos-infra foi clonado
BASE_DIR="$(dirname "$(pwd)")"

# Obter o nome de usuário do GitHub configurado localmente
GITHUB_USER=$(git config user.name)

# Verificar se o nome de usuário foi obtido
if [ -z "$GITHUB_USER" ]; then
  echo "Erro: Não foi possível obter o nome de usuário do GitHub. Defina o nome de usuário no Git configurado."
  exit 1
fi

# Definindo os repositórios a serem clonados, usando o nome de usuário
REPOS=(
  "git@github.com:$GITHUB_USER/parthos-web.git"
  "git@github.com:$GITHUB_USER/parthos-api.git"
)

# Função para clonar e instalar dependências
clone_and_install() {
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

  # Instala dependências se o repositório existir
  echo "Instalando dependências do $repo_name..."
  cd $repo_path
  npm install
}

# Clona e instala as dependências para o frontend e backend
for repo in "${REPOS[@]}"; do
  clone_and_install $repo
done

# Subir os containers Docker
echo "Subindo os containers Docker..."
docker-compose up -d

echo "Ambiente configurado e containers iniciados!"
