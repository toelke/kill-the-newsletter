FROM node:16-buster AS builder

COPY . /src
WORKDIR /src
RUN npm ci && npx caxa --input .  --output "kill-the-newsletter" -- "{{caxa}}/node_modules/.bin/node" "{{caxa}}/distribution/index.js"

FROM gcr.io/distroless/cc-debian11 AS runner

WORKDIR /cfg
COPY ./deployment-example/configuration.js configuration.js

WORKDIR /app
COPY --from=builder /src/kill-the-newsletter kill-the-newsletter

CMD ["/app/kill-the-newsletter", "/cfg/configuration.js"]
