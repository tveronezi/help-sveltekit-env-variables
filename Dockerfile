FROM node:19 as base
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN update-ca-certificates
ENV USER=cecilia
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"
WORKDIR /opt

FROM base as build
COPY . /opt
WORKDIR /opt
RUN npm install
RUN npm run build

FROM base as modules
COPY package.json /opt/
COPY package-lock.json /opt/
WORKDIR /opt
RUN npm ci --omit dev

FROM base
COPY --from=modules /opt/node_modules /opt/node_modules
COPY --from=build /opt/build /opt/build
COPY package.json /opt/
USER cecilia:cecilia
WORKDIR /opt
ENTRYPOINT [ "/usr/local/bin/node", "build" ]

