### Parthos - Transforme seus problemas em solução

O **Parthos** é uma aplicação de gerenciamento de tarefas (To-Do List) que visa transformar a maneira como você organiza seu dia. Assim como o sábio Parthanax de Skyrim, que passou de obstáculo a aliado essencial, **Parthos** ajuda a superar o caos e trazer organização e clareza à sua rotina. A ferramenta permite criar, editar, excluir e listar tarefas, além de marcar como concluídas e filtrar por status.

Com uma interface limpa e responsiva, **Parthos** proporciona uma experiência de produtividade focada e eficiente, transformando desafios em soluções. Organize sua vida com a sabedoria e eficiência de Parthos.

---

**Funcionalidades principais:**
- Criação, edição e exclusão de tarefas.
- Marcar tarefas como concluídas.
- Filtrar tarefas por status.
- Design responsivo para dispositivos móveis e desktop.

**Justificativa para o nome "Parthos":**
Inspirado em Parthanax, de Skyrim, Parthos simboliza a transformação de caos em organização e o poder de superar desafios com sabedoria e foco.

## Estrutura do Projeto

- **docker-compose.yml**: Arquivo de configuração para orquestrar containers Docker.
- **scripts/setup.sh**: Script para automatizar a configuração do ambiente.
- **.env**: Arquivo de variáveis de ambiente (a ser configurado com as credenciais corretas).
- **networks/shared-network**: Configuração da rede Docker compartilhada entre os containers.

## Como Rodar o Projeto

1. Clone o repositório:

   ```bash
   git clone https://github.com/seu-usuario/parthos-.git
   cd parthos-infra
   ```
2. Conceda permissão de execução ao script:

   ```bash
   chmod +x ./scripts/setup.sh
   ```

3. Execute o script de setup:

   ```bash
   ./scripts/setup.sh
   ```

4. Os containers serão configurados e executados automaticamente.

## Configuração do Docker

O arquivo `docker-compose.yml` contém a configuração para os containers de frontend, backend e banco de dados PostgreSQL. Todos os containers estão conectados à mesma rede Docker.

## CI/CD (Opcional)

A configuração de CI/CD pode ser adicionada posteriormente, utilizando ferramentas como **GitHub Actions**, **Jenkins** ou **GitLab CI**.

## Licença

Este projeto é licenciado sob a [MIT License](LICENSE).
