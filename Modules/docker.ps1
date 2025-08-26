# Docker Aliases and Functions
function dc { docker compose $args }
function dcu { docker compose up -d }
function dcd { docker compose down }
function dlog { docker logs -f $args }
function dclean { docker system prune -a -f }
