FROM ubuntu:20.04
WORKDIR /tmp
RUN apt update -y
RUN apt upgrade -y

RUN apt install curl -y
RUN curl -sO https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt update -y
RUN apt upgrade -y
RUN apt install apt-transport-https \
                aspnetcore-runtime-3.1 \
                systemctl -y

COPY ./identity/bin/Debug/netcoreapp3.1/publish /app

COPY ./identity.service /etc/systemd/system/
RUN echo "### wating 10 seconds before systemctl apsnetcore app service init ###"
RUN sleep 10
RUN systemctl daemon-reload
RUN systemctl start identity.service
RUN systemctl

RUN apt install nginx -y
COPY ./nginx.conf /etc/nginx/sites-available/default
CMD ["nginx", "-g", "daemon off;"]
