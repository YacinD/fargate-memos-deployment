# Frontend build
FROM node:24.21.0 AS frontend

WORKDIR /frontend

RUN corepack enable

COPY app/memos/web/package.json app/memos/web/pnpm-lock.yaml app/memos/web/pnpm-workspace.yaml ./
COPY app/memos/web/patches ./patches

RUN pnpm install --frozen-lockfile

COPY app/memos/web/ ./

RUN pnpm release


# Backend build
FROM golang:1.26.2-alpine AS backend

WORKDIR /backend

RUN apk add --no-cache \
    git \
    build-base

COPY app/memos/go.mod app/memos/go.sum ./

RUN go mod download

COPY app/memos/ ./

COPY --from=frontend /frontend/dist ./web/dist

RUN CGO_ENABLED=1 go build \
    -o memos \
    ./cmd/memos


# Runtime
FROM alpine:3.21

WORKDIR /var/opt/memos

RUN apk add --no-cache \
    ca-certificates \
    sqlite \
    tzdata

COPY --from=backend /backend/memos /usr/local/bin/memos

EXPOSE 5230

CMD ["memos"]