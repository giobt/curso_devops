FROM gradle:7.2-jdk11 as builder

COPY . .

RUN gradle build

##################

FROM openjdk:11-jre-slim-buster

COPY --from=builder /home/gradle/build/libs/demo-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
