# DevOps Roadmap — Laravel + React

A full-stack Laravel + React application fully containerized with Docker.
Built as a hands-on DevOps learning project.

## Stack
- **Backend:** Laravel 13 (PHP 8.3)
- **Frontend:** React + Vite
- **Web Server:** Nginx
- **Database:** MySQL 8
- **Cache/Queue:** Redis 7
- **Containerization:** Docker + Docker Compose

## Prerequisites
- Docker
- Make
- Git

## Quick Start

### 1. Clone the repo
git clone git@github.com:Grantyyyyy/devops-roadmap.git
cd devops-roadmap

### 2. Set up environment
cp backend/.env.example backend/.env

### 3. Start all containers
make up

### 4. Run migrations
make migrate

### 5. Visit the app
- Laravel → http://localhost:8000
- React   → http://localhost:3000

## Available Commands

| Command         | Description                        |
|-----------------|------------------------------------|
| make up         | Start all containers               |
| make down       | Stop all containers                |
| make build      | Rebuild and start containers       |
| make restart    | Restart all containers             |
| make migrate    | Run Laravel migrations             |
| make tinker     | Open Laravel tinker shell          |
| make logs       | Show live container logs           |
| make ps         | Show running containers            |
| make db         | Open MySQL shell                   |
| make redis      | Open Redis shell                   |
| make clear      | Clear all Laravel caches           |
| make fresh      | Wipe database and fresh migrate    |

## Project Structure

devops-roadmap/
├── backend/         Laravel API
├── frontend/        React + Vite
├── nginx/           Nginx config
├── docker-compose.yml
└── Makefile

## Troubleshooting

### Containers not starting?
make down
make build

### Laravel permission errors?
docker exec laravel_app chmod -R 777 /var/www/html/storage

### Database connection error?
Check backend/.env has:
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
