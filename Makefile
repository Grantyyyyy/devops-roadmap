.PHONY: up down build restart migrate tinker logs ps

# Start all containers in background
up:
	docker compose up -d

# Stop all containers
down:
	docker compose down

# Rebuild and start
build:
	docker compose up --build -d

# Restart all containers
restart:
	docker compose down && docker compose up -d

# Run Laravel migrations
migrate:
	docker exec laravel_app php artisan migrate

# Open Laravel tinker (interactive shell)
tinker:
	docker exec -it laravel_app php artisan tinker

# Show live logs
logs:
	docker compose logs -f

# Show running containers
ps:
	docker ps

# Fresh start - wipe database and restart
fresh:
	docker compose down -v
	docker compose up -d
	sleep 5
	docker exec laravel_app php artisan migrate --seed

# Open MySQL shell
db:
	docker exec -it laravel_db mysql -u laravel -psecret laravel

# Open Redis shell
redis:
	docker exec -it laravel_cache redis-cli

# Clear Laravel caches
clear:
	docker exec laravel_app php artisan cache:clear
	docker exec laravel_app php artisan config:clear
	docker exec laravel_app php artisan route:clear
	docker exec laravel_app php artisan view:clear

# ─── Staging ───────────────────────────────────────

# Build staging images
staging-build:
	docker build -t devops-roadmap-app:staging ./backend
	docker build -t devops-roadmap-frontend:staging ./frontend

# Start staging environment
staging-up:
	docker compose -f docker-compose.staging.yml up -d

# Stop staging environment
staging-down:
	docker compose -f docker-compose.staging.yml down

# Run migrations on staging
staging-migrate:
	docker exec staging_laravel_app php artisan migrate --force

# View staging logs
staging-logs:
	docker compose -f docker-compose.staging.yml logs -f

# Full staging deploy (build + start + migrate)
staging-deploy:
	docker build -t devops-roadmap-app:staging ./backend
	docker build -t devops-roadmap-frontend:staging ./frontend
	docker compose -f docker-compose.staging.yml down
	docker compose -f docker-compose.staging.yml up -d
	sleep 5
	docker exec staging_laravel_app php artisan migrate --force


# ─── Monitoring ───────────────────────────────────────

# Start monitoring containers
monitoring-up:
	docker compose -f docker-compose.monitoring.yml up -d

# Stop monitoring containers
monitoring-down:
	docker compose -f docker-compose.monitoring.yml down

# View monitoring logs
monitoring-logs:
	docker compose -f docker-compose.monitoring.yml logs -f
