# if you are not using podman,
# please comment the below line.
export alias docker = podman

export alias dc = docker container
export alias dcr = docker container run
export alias dcrit = docker container run --interactive --tty
export alias dcx = docker container exec
export alias dcxit = docker container exec --interactive --tty
export alias dcrm = docker container rm
export alias dcrm! = docker container rm --force
export alias dcs = docker container start
export alias dcrs = docker container restart
export alias dcst = docker container stop
# Alias for `docker container ls --quiet | xargs docker stop`
export def dcsta [] {
  docker container ls --quiet | xargs docker stop
}
export alias dcls = docker container ls
export alias dclsa = docker container ls --all
export alias dci = docker container inspect
export alias dcp = docker container port
export alias dcl = docker container logs
export alias dctop = docker container top

export alias di = docker image
export alias dipl = docker image pull
export alias dib = docker image build
export alias dii = docker image inspect
export alias dils = docker image ls
export alias dip = docker image push
export alias dirm = docker image rm
export alias dit = docker image tag

export alias dn = docker network
export alias dnc = docker network create
export alias dncn = docker network connect
export alias dndcn = docker network disconnect
export alias dni = docker network inspect
export alias dnls = docker network ls
export alias dnrm = docker network rm

export alias dv = docker volume
export alias dvi = docker volume inspect
export alias dvls = docker volume ls
export alias dvprune = docker volume prune

export alias dm = docker compose
export alias dmu = docker compose up --detach
export alias dmu! = docker compose up -detach --build --force-recreate
export alias dmd = docker compose down
export alias dmd! = docker compose down --volumes --rmi all
export alias dmr = docker compose run
export alias dmrit = docker compose run --interactive --tty
export alias dmx = docker compose exec
export alias dmxit = docker compose exec --interactive --tty
export alias dmrm = docker compose rm
export alias dmrm! = docker compose rm --force
export alias dms = docker compose start
export alias dmrs = docker compose restart
export alias dmst = docker compose stop
# Alias for `docker compose ls --quiet | xargs docker compose stop`
export def dmsta [] {
  docker compose ls --quiet | xargs docker compose stop
}
export alias dmls = docker compose ls
export alias dmlsa = docker compose ls --all
export alias dmp = docker compose port
export alias dml = docker compose logs
export alias dmtop = docker compose top
export alias dmpl = docker compose pull
export alias dmb = docker compose build
export alias dmp = docker compose push
