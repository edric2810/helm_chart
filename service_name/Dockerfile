FROM public.ecr.aws/klb/openjdk11:latest as build
WORKDIR /workspace/app
COPY . /workspace/app
RUN chmod +x ./gradlew
# RUN ./gradlew xjcGenerate
RUN ./gradlew clean build -x test -i --stacktrace

FROM public.ecr.aws/klb/openjdk11:latest
WORKDIR /workspace/app
COPY --from=build /workspace/app/build/libs/*-SNAPSHOT.jar app.jar
RUN mkdir temp

# COPY src/main/resources/keystore/ /lib/

RUN apt update -y && apt purge -y git curl telnet openssh-client openssl wget python* && apt autoremove -y && apt upgrade -y
RUN addgroup --gid 1000 minimal && adduser --system --gid 1000 --uid 1000 minimal
RUN chown -R 1000:1000 /workspace/app
USER minimal

# RUN /bin/sh -c 'touch /app.jar'

ENV TZ="Asia/Ho_Chi_Minh"
ENTRYPOINT ["java","-jar","app.jar"]


