FROM node:20-slim AS base

WORKDIR /app

# ── deps layer (cached unless package.json/package-lock.json change) ──────────
FROM base AS deps

COPY package.json package-lock.json ./

RUN npm ci

# ── runtime (Production Nginx stage) ─────────────────────────────────────────
FROM base AS build

COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM nginx:stable-alpine AS runtime
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# ── dev (For local development with hot-reloading) ───────────────────────────
FROM base AS dev

COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]