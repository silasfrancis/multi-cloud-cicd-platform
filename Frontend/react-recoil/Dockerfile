FROM node:24-bullseye-slim AS base
WORKDIR /app

FROM base AS dev

COPY package.json yarn.lock ./

RUN --mount=type=cache,target=/app/.yarn_cache \
    yarn config set cache-folder /app/.yarn_cache && \
    yarn install --frozen-lockfile

COPY . .

# Build the app
RUN yarn build

# Install serve globally with yarn
RUN yarn global add serve

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]

FROM base AS production

# Copy only package files and install production dependencies
COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile

# Copy built files from the dev stage
COPY --from=dev /app/build ./build

# Expose port and start the application
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
