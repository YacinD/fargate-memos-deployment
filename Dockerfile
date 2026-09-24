# Frontend build
FROM node:24.21.0 AS frontend

WORKDIR /frontend

RUN corepack enable

COPY app/memos/web/package.json \
     app/memos/web/pnpm-lock.yaml \
     app/memos/web/pnpm-workspace.yaml \
     ./

COPY app/memos/web/patches ./patches

RUN pnpm install --frozen-lockfile

COPY app/memos/web/ ./

RUN pnpm release


# Backend build
FROM golang:1.26.2-alpine AS backend

WORKDIR /backend-build

RUN apk add --no-cache \
    git \
    ca-certificates

COPY app/memos/go.mod app/memos/go.sum ./

RUN go mod download

COPY app/memos/ ./

COPY --from=frontend \
    /server/router/frontend/dist \
    ./server/router/frontend/dist

RUN test -f server/router/frontend/dist/index.html

ARG VERSION=dev
ARG COMMIT=unknown

RUN CGO_ENABLED=0 \
    go build \
    -trimpath \
    -ldflags="-s -w \
    -X github.com/usememos/memos/internal/version.Version=${VERSION} \
    -X github.com/usememos/memos/internal/version.Commit=${COMMIT}" \
    -tags netgo,osusergo \
    -o memos \
    ./cmd/memos


# Runtime
FROM alpine:3.21 AS runtime

RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    && addgroup -g 10001 -S nonroot \
    && adduser -u 10001 -S -G nonroot -h /var/opt/memos nonroot \
    && mkdir -p /var/opt/memos \
    && chown -R nonroot:nonroot /var/opt/memos

COPY --from=backend \
    /backend-build/memos \
    /usr/local/bin/memos

VOLUME /var/opt/memos

ENV MEMOS_PORT=5230

EXPOSE 5230

USER nonroot

WORKDIR /var/opt/memos

ENTRYPOINT ["/usr/local/bin/memos"]