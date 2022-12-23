FROM node:16-buster AS builder

COPY . /src
WORKDIR /src
RUN npm ci && npx caxa --directory . --command "{{caxa}}/node_modules/.bin/node" "{{caxa}}/distribution/index.js" --output "kill-the-newsletter"

FROM gcr.io/distroless/cc-debian11 AS runner

WORKDIR /cfg
COPY ./deployment-example/configuration.js configuration.js

WORKDIR /app
COPY --from=builder /src/kill-the-newsletter kill-the-newsletter

CMD ["/app/kill-the-newsletter", "/cfg/configuration.js"]
