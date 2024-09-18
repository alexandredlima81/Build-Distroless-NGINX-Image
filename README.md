# Distroless NGINX Docker Image

Este repositório contém a configuração para construir uma imagem Docker do NGINX utilizando o conceito de **multi-stage build**. A imagem final é baseada no **Distroless** para garantir uma imagem mínima e mais segura, contendo apenas os binários necessários para rodar o NGINX.

## Estrutura do Dockerfile

### Stage 1: NGINX Build

No primeiro estágio, utilizamos a imagem oficial do NGINX em sua versão **alpine** para extrair os binários necessários do NGINX:

```dockerfile
# Stage 1: Use an official NGINX image to extract binaries
FROM nginx:alpine as nginx-build

Stage 2: Distroless Final Image
No segundo estágio, utilizamos a imagem Distroless baseada no Debian para garantir que a imagem final seja o mais enxuta e segura possível:
