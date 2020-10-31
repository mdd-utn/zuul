Api Gateway
-----------------------------------

Read PDF signer via Git Remote Repository

remote repo. 
		https://gitlab.com/informatica-drp/tool-zuul-server.git
 
  DOCKER_NAME: "services"
  DOCKER_PORT: "9099"
  DOCKER_LINKS: "--link eureka:eureka --link config-server:config-server "
  CONTEXT-PATH: "/services"
		
ACTUATOR REFRESH
=================

curl -X POST  http://0.0.0.0:9099/services/actuator/refresh

BUILD
=====

cd /mnt/work/workspaces/workspace_drp/tool-srv-zuul

mvn clean eclipse:eclipse package -Dmaven.test.skip=true
docker stop services || true && docker rm services || true

docker rmi zuul-service-local
docker rmi $( docker images | grep registry.gitlab.com/informatica-drp/tool-zuul-server | tr -s ' ' | cut -d ' ' -f 3)
docker rmi $( docker images | grep informaticadrp/tool-zuul-server | tr -s ' ' | cut -d ' ' -f 3)


docker build -t "zuul-service-local" .
docker tag "zuul-service-local" "zuul-service-local:latest"
	
docker run -itd -p 9099:9099 --name services --hostname services \
-e "SPRING_PROFILES_ACTIVE=dev" --link eureka:eureka --link config-server:config-server \
--restart unless-stopped \
zuul-service-local:latest
	
		
RUN DOCKER ON STAGE
====================
		
docker run -itd -p 9099:9099 --name services --hostname services \
-e "SPRING_PROFILES_ACTIVE=dev" --link eureka:eureka --link config-server:config-server \
--restart unless-stopped \
registry.gitlab.com/informatica-drp/tool-zuul-server:4

		
RUN DOCKER oN PROD
====================
		
docker run -itd -p 9099:9099 --name services \
-e "SPRING_PROFILES_ACTIVE=prod" \  
--link eureka:eureka --link config-server:config-server \
--hostname services \
--restart unless-stopped \
informaticadrp/prod:registry.gitlab.com/informatica-drp/tool-zuul-server:4



GITLAB-RUNNER
=============


gitlab- runner

sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "dMJqkDcvGJzCXAxys6QL" \
  --executor "shell" \
  --description "ubuntu-pc-zuul-server" \
  --tag-list "test, run-develop, run-master" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"
  
  sudo gitlab-runner verify --delete
  
 gitlab-runner unregister --url https://gitlab.com/ --token tLVYdXbC742gzW8w57qb

		