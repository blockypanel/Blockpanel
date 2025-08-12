FROM openjdk:21-jdk-slim
WORKDIR /data
RUN apt-get update && apt-get install -y wget
RUN wget -O server.jar https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar
EXPOSE 25565
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]