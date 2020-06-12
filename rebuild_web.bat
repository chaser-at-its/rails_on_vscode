docker-compose -f docker-compose.yml -f .devcontainer/docker-compose.yml ^
               up -d --build --force-recreate --no-deps web
