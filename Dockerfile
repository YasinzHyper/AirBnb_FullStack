# Use the official Node.js 18 Alpine image
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
# Install OpenSSL for Prisma compatibility
RUN apk add --no-cache libc6-compat openssl
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Build the application
RUN npm run build

# Development image, copy all the files and run next dev
FROM base AS dev
WORKDIR /app

# Install OpenSSL for Prisma compatibility, netcat for health checks, and dos2unix for line ending conversion
RUN apk add --no-cache libc6-compat openssl netcat-openbsd dos2unix

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source code
COPY . .

# Convert line endings and make startup script executable
RUN dos2unix docker/start.sh && chmod +x docker/start.sh

# Generate Prisma Client
RUN npx prisma generate

# Expose port 3000
EXPOSE 3000

# Set environment to development
ENV NODE_ENV=development

# Start the development server using our custom script
CMD ["./docker/start.sh"]

# Production image, copy all the files and run next start
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
# set hostname to localhost
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]