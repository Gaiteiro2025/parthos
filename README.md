# Parthos - Transforme seus problemas em solução

[![GitHub repo size](https://img.shields.io/github/repo-size/Gaiteiro2025/parthos-root)](https://github.com/Gaiteiro2025/parthos-root)
[![GitHub last commit](https://img.shields.io/github/last-commit/Gaiteiro2025/parthos-root)](https://github.com/Gaiteiro2025/parthos-root/commits/main)
[![GitHub Release](https://img.shields.io/github/v/release/Gaiteiro2025/parthos-root)](https://github.com/Gaiteiro2025/parthos-root/releases)
[![GitHub issues](https://img.shields.io/github/issues/Gaiteiro2025/parthos-root)](https://github.com/Gaiteiro2025/parthos-root/issues)
[![GitHub license](https://img.shields.io/github/license/Gaiteiro2025/parthos-root)](https://github.com/Gaiteiro2025/parthos-root/blob/main/LICENSE)

O **Parthos** é a infraestrutura principal para os microserviços do ecossistema. Ele orquestra os containers, gerencia a rede Docker e garante que todos os serviços funcionem corretamente.

## Estrutura do Projeto

- **docker-compose.yml**: Arquivo de configuração para orquestrar containers Docker.
- **scripts/setup.sh**: Script para automatizar a configuração do ambiente.
- **.env**: Arquivo de variáveis de ambiente.
- **nginx.conf**: Configuração do proxy reverso para roteamento entre microserviços.
- **networks/shared-network**: Rede Docker compartilhada entre os containers.

---

## Como Rodar o Projeto

### 1. Clone o Repositório
```sh
git clone git@github.com:Gaiteiro2025/parthos-root.git
cd parthos-root
```

### 2. Crie ou Cole o Arquivo .env
Crie um arquivo .env e cole ele na raiz do projeto. Exemplo de env para rodar local:
```sh
DB_HOST=db
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=nestdb
JWT_SECRET=default_secret
```

### 3. Configure as Permissões do Script
```sh
chmod +x ./scripts/setup.sh
```

### 4. Execute o Script de Setup
```sh
./scripts/setup.sh
```

### 5. O ambiente será inicializado automaticamente.
Esse script:
- Lê o arquivo `.env` e carrega as variáveis.
- Clona os repositórios dependentes.
- Configura os containers Docker.
- Inicializa o Nginx para gerenciar o proxy reverso.

---

## Repositórios Dependentes

A infraestrutura Parthos depende dos seguintes microserviços:

| Nome do Serviço         | Repositório | Porta |
|----------------------|-----------------------------------|-------|
| Parthos Gateway     | [Parthos Root](https://github.com/Gaiteiro2025/parthos-root) | 3000  |
| Parthos Web    | [Parthos Web](https://github.com/Gaiteiro2025/parthos-web) | 8080  |
| Parthos User API    | [Parthos User API](https://github.com/Gaiteiro2025/parthos-user-api) | 3001  |
| Parthos Task API    | [Parthos Task API](https://github.com/Gaiteiro2025/parthos-task-api) | 3002  |

Todos esses containers são conectados na rede `parthos-network` para comunicação interna.

---

## Configuração do Nginx (Proxy Reverso)

O **Nginx** é usado para gerenciar as requisições e distribuir entre os microserviços. Abaixo está a configuração principal:

```nginx
worker_connections 1024;

http {
    upstream parthos-user-api {
        server parthos-user-api:3001;
    }
    
    server {
        listen 5000;
        location /user/ {
            proxy_pass http://parthos-user-api/;
            rewrite ^/user/(.*) /$1 break;
        }
    }
}
```

Isso garante que todas as requisições para `/user/` sejam direcionadas ao `parthos-user-api`, facilitando a escalabilidade do sistema.

---

## CI/CD (Opcional)

A configuração de CI/CD pode ser adicionada posteriormente, utilizando ferramentas como **GitHub Actions**, **Jenkins** ou **GitLab CI**.

---

## Licença

Este projeto está sob a **licença MIT**. Veja o arquivo [LICENSE](https://github.com/Gaiteiro2025/parthos-root/blob/main/LICENSE) para mais detalhes.

