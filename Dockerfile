FROM docker:cli
RUN apk add --no-cache curl git bash
RUN curl -fsSL https://www.devopsellence.com/lfg.sh | sh
ENTRYPOINT ["devopsellence"]
