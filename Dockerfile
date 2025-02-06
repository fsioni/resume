# Build stage
FROM texlive/texlive:latest as builder
WORKDIR /app

# Préparation de l'environnement
RUN apt-get update && \
    apt-get install -y locales && \
    sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

# Copie des fichiers
COPY . .

# Configuration LaTeX
RUN echo '$pdflatex = "pdflatex -file-line-error -synctex=1 -interaction=nonstopmode %O %S";' > .latexmkrc && \
    echo '$pdf_mode = 1;' >> .latexmkrc && \
    echo '$max_repeat = 5;' >> .latexmkrc

# Stage final
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copie du PDF généré
COPY --from=builder /app/resume/main.pdf ./cv.pdf
COPY --from=builder /app/resume/main.pdf ./index.html

# Variables d'environnement et informations
RUN echo -e "\e[1;33mENVIRONMENT VARIABLES\e[0m"
RUN env

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]