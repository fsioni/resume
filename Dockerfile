# Build stage
FROM registry.gitlab.com/islandoftex/images/texlive@sha256:c145e9c620c054df1e5c885c588b081b200707f151bf7a6693a591cc364d60ad as builder
WORKDIR /app

# Installation des outils nécessaires
RUN apt-get update && \
    apt-get install -y locales && \
    sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

# Copier les fichiers
COPY . .

# Créer un lien symbolique pour le dossier resources
RUN cd resume && ln -s resources .

# Génération du PDF
RUN cd resume && \
    mkdir -p output && \
    latexmk -pdf -interaction=nonstopmode -output-directory=output main.tex

# Production stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/resume/output/main.pdf ./cv.pdf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]