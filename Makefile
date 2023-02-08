run_bash:
	@docker compose run ubuntu-bash

run_zsh:
	@docker compose run ubuntu-zsh

exec_bash:
	@docker compose exec -it ubuntu-bash bash

exec_zsh:
	@docker compose exec -it ubuntu-zsh zsh

clean:
	@docker compose ps -aq | xargs docker rm -f
