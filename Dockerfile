FROM node:19-bullseye AS builder

COPY . /src
WORKDIR /src
RUN npm ci && npx caxa --input .  --output "kill-the-newsletter" -- "{{caxa}}/node_modules/.bin/node" "{{caxa}}/build/server/index.mjs"

FROM gcr.io/distroless/cc-debian11 AS runner

WORKDIR /cfg
COPY ./configuration/default.mjs configuration.mjs

WORKDIR /app
COPY --from=builder /src/kill-the-newsletter kill-the-newsletter

CMD ["/app/kill-the-newsletter", "/cfg/configuration.mjs"]
