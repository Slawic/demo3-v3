# Pull base image.
FROM amazoncorretto:latest

RUN \
# Update
yum update -y

COPY ./backend/eschool.jar ./app/eschool.jar

COPY ./backend/application.properties ./app/application.properties
WORKDIR ./app
EXPOSE 8080
CMD ["java", "-jar", "eschool.jar", "application.properties"]
