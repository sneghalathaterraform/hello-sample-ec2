FROM tomcat:9-jdk17
COPY target/helloapp.war /usr/local/tomcat/webapps/
EXPOSE 8080
