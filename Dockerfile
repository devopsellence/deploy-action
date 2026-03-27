FROM docker:cli

ARG CLI_DOWNLOAD_URL=https://www.devopsellence.com/lfg.sh
ARG CLI_VERSION

RUN apk add --no-cache curl git bash
RUN curl -fsSL "${CLI_DOWNLOAD_URL}" -o /tmp/install.sh \
    && bash /tmp/install.sh --version="${CLI_VERSION}" \
    && rm /tmp/install.sh

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]
