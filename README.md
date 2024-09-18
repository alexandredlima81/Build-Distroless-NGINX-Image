# Distroless NGINX Docker Image

Este repositório contém a configuração para construir uma imagem Docker do NGINX utilizando o conceito de **multi-stage build**. A imagem final é baseada no **Distroless** para garantir uma imagem mínima e mais segura, contendo apenas os binários necessários para rodar o NGINX.

## Estrutura do Dockerfile

### Stage 1: NGINX Build

No primeiro estágio, utilizamos a imagem oficial do NGINX em sua versão **alpine** para extrair os binários necessários do NGINX:

```dockerfile
# Stage 1: Use an official NGINX image to extract binaries
FROM nginx:alpine as nginx-build
```

### Stage 2: Distroless Final Image
No segundo estágio, utilizamos a imagem Distroless baseada no Debian para garantir que a imagem final seja o mais enxuta e segura possível:

```dockerfile
# Stage 2: Use Distroless as the base for the final image
FROM gcr.io/distroless/base-debian12
```
Copiamos os binários do NGINX e os arquivos de configuração do estágio anterior:

```dockerfile
# Copy NGINX binaries from the first stage
COPY --from=nginx-build /usr/sbin/nginx /usr/sbin/nginx
COPY --from=nginx-build /etc/nginx /etc/nginx
```
Expomos a porta 80 para servir as requisições HTTP e iniciamos o NGINX em modo daemon off:

```dockerfile
# Expose the port NGINX will serve on
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
```
## Como Construir a Imagem

Siga os passos abaixo para construir a imagem Docker:

Clone o repositório:

```bash

git clone https://github.com/seu-usuario/distroless-nginx.git
cd distroless-nginx
```
Construa a imagem Docker:

```bash
docker build -t seu-usuario/nginx-distroless:latest .
```
Execute a imagem:

```bash
docker run -d -p 8080:80 seu-usuario/nginx-distroless:latest
```
Agora o NGINX estará rodando no seu container e estará acessível em http://localhost:8080.

## Pipeline de CI com GitHub Actions

Este repositório inclui uma pipeline de CI com o GitHub Actions que automaticamente:

Realiza o build da imagem Docker.
Realiza o push da imagem para o Docker Hub.
Para configurar o pipeline, certifique-se de adicionar as seguintes variáveis de GitHub Secrets ao seu repositório:

DOCKER_USERNAME: Seu nome de usuário no DockerHub.
DOCKER_PASSWORD: Sua senha ou token de acesso ao DockerHub.
Exemplo de Pipeline
yaml
Copy code
name: Build and Push Docker Image

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker image
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/nginx-distroless:latest .

      - name: Push Docker image
        run: |
          docker push ${{ secrets.DOCKER_USERNAME }}/nginx-distroless:latest
## Vantagens do Uso de Distroless

**Segurança:** A imagem Distroless é minimalista e não contém pacotes ou bibliotecas desnecessárias, reduzindo a superfície de ataque.
**Tamanho da Imagem:** A imagem resultante é muito menor do que uma imagem de NGINX tradicional, economizando espaço e melhorando os tempos de download e deploy.
