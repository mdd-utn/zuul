Api Gateway
-----------------------------------

Read PDF signer via Git Remote Repository

remote repo. 
		https://gitlab.com/informatica-drp/tool-zuul-server.git
 
  DOCKER_NAME: "services"
  DOCKER_PORT: "9099"
  DOCKER_LINKS: ""
  CONTEXT-PATH: "/services"
		
ACTUATOR REFRESH
=================

curl -X POST  http://0.0.0.0:9099/services/actuator/refresh

BUILD
=====

cd /mnt/work/workspaces/workspace_antlr/zuul

mvn clean eclipse:eclipse package -Dmaven.test.skip=true

docker stop proxy || true && docker rm proxy || true

docker rmi zuul-proxy-local

docker rmi $( docker images | grep registry.gitlab.com/mdd/zuul | tr -s ' ' | cut -d ' ' -f 3)

docker rmi $( docker images | grep mddutn/colmena/zuul | tr -s ' ' | cut -d ' ' -f 3)

docker build -t "zuul-proxy-local" .

docker tag "zuul-proxy-local" "zuul-proxy-local:latest"
	
docker run -itd -p 9099:9099 --name proxy --hostname proxy \
-e "SPRING_PROFILES_ACTIVE=dev"  \
--restart unless-stopped \
--net colmena-net  \
zuul-proxy-local:latest


docker logs proxy
	
		
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
  --registration-token "fJb2S8hW7kweJxcsYJ9g" \
  --executor "shell" \
  --description "ubuntu-pc-zuul-server" \
  --tag-list "test, run-develop, run-master" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"
  
  sudo gitlab-runner verify --delete
  
 gitlab-runner unregister --url https://gitlab.com/ --token fJb2S8hW7kweJxcsYJ9g

		