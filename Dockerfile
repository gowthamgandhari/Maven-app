FROM tomcat:latest 
LABEL maintainer="G.Gowtham <gowtham@webapp>" 
EXPOSE 8080 
COPY target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
