# DevOps Setup Nice-to-Haves

## Overall Rating

**6.5/10 for a beginner DevOps setup**

This is a solid starting point. The project already uses a multi-service Docker setup with a Laravel backend, Nginx web server, MySQL database, Redis cache, and a separate React frontend.

## What Is Already Good

- Docker Compose is used to coordinate the stack.
- Backend and frontend are separated into their own services.
- Laravel runs behind Nginx instead of exposing PHP-FPM directly.
- MySQL data is persisted with a named Docker volume.
- Redis is included early, which is useful for queues, cache, and sessions.
- Frontend uses a production-style multi-stage Docker build.
- Backend uses a multi-stage Dockerfile and installs Composer dependencies during image build.

## Nice-to-Have Improvements

### 1. Fix the backend bind mount dependency issue

The backend image installs Composer dependencies during the Docker build, but `docker-compose.yml` bind-mounts `./backend:/var/www/html` at runtime.

That mount can hide the `vendor` directory created inside the image unless `vendor` also exists on the host machine.

Possible improvements:

- Use a separate named volume for `/var/www/html/vendor`.
- Run `composer install` on the host before starting containers.
- Use a development-specific Compose file that handles dependencies explicitly.

### 2. Align Laravel environment settings with Docker

`backend/.env.example` currently defaults to SQLite and localhost services, while Docker Compose provides MySQL and Redis service names.

For Docker usage, document settings like:

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret

REDIS_HOST=cache
REDIS_PORT=6379
```

### 3. Move hardcoded secrets into environment files

The Compose file currently hardcodes values like database passwords.

For learning, this is fine. As the project grows, move these into a root `.env` or a Docker-specific env file.

Example:

```env
MYSQL_DATABASE=laravel
MYSQL_USER=laravel
MYSQL_PASSWORD=secret
MYSQL_ROOT_PASSWORD=secret
```

Then reference them from Compose:

```yaml
environment:
  MYSQL_DATABASE: ${MYSQL_DATABASE}
  MYSQL_USER: ${MYSQL_USER}
  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
```

### 4. Add a root README

The backend and frontend still have template README files, but the root project needs a project-specific README.

It should explain:

- What the stack contains.
- How to start the app.
- Which ports are exposed.
- How to run migrations.
- How to run backend tests.
- How to rebuild containers.
- Common troubleshooting steps.

### 5. Add `.dockerignore` files

Add `.dockerignore` files for both backend and frontend builds.

Backend should ignore things like:

```gitignore
.env
vendor
node_modules
storage/logs
.git
```

Frontend should ignore things like:

```gitignore
node_modules
dist
.env
.git
```

This keeps Docker build contexts smaller and avoids accidentally copying local-only files into images.

### 6. Fix or reinitialize Git

`git status` currently fails even though a `.git` directory exists. The `.git` directory appears incomplete.

Fix this early so the project history is tracked correctly.

Possible options:

- Reinitialize Git with `git init`.
- Remove the broken `.git` directory and start fresh.
- If this came from a copied project, restore the original `.git` metadata.

## Suggested Validation Commands

After improving the setup, use these commands to validate the stack:

```bash
docker compose config
docker compose up --build
docker compose exec app php artisan migrate
docker compose exec app php artisan test
```

If the frontend and backend both start successfully, check:

- Frontend: <http://localhost:3000>
- Backend via Nginx: <http://localhost:8000>

## Next Learning Targets

- Docker Compose profiles for development vs production.
- Healthchecks for MySQL, Redis, backend, and frontend.
- CI pipeline that runs frontend lint/build and backend tests.
- Basic deployment workflow.
- Environment-specific configuration.
- Container logs and debugging commands.
