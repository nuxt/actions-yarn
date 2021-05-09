FROM node:16

LABEL version="1.1.0"
LABEL repository="https://github.com/nuxt/actions-yarn"
LABEL homepage="https://github.com/nuxt/actions-yarn"
LABEL maintainer="Xin Du (Clark) <clark.duxin@gmail.com>"

LABEL com.github.actions.name="GitHub Action for Yarn"
LABEL com.github.actions.description="Wraps the yarn CLI to enable common yarn commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"
COPY LICENSE README.md /

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
