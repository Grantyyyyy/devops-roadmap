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
