FROM mhart/alpine-node:6

WORKDIR /src
ADD . .

# If you have native dependencies, you'll need extra tools
RUN apk add --no-cache make gcc g++ python \
    && npm install \
    && apk del make gcc g++ python \
    && rm -rf /var/cache/apk/* \

EXPOSE 8080
CMD ["node", "server.js"]

