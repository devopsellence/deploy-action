FROM docker:cli

ARG CLI_DOWNLOAD_URL
ARG CLI_VERSION

RUN apk add --no-cache curl git bash
RUN curl -fsSL "${CLI_DOWNLOAD_URL}" | bash -s -- --version="${CLI_VERSION}"

ENTRYPOINT ["devopsellence"]
