FROM besn0847/ubuntu32
EXPOSE 2017
RUN apt-get update && apt-get install netcat-traditional -y
RUN update-alternatives --set nc /bin/nc.traditional

RUN mkdir /opt/hackerschool/
COPY . /opt/hackerschool/
WORKDIR /opt/hackerschool/

ENV DOORBOT_HOME /opt/hackerschool/

RUN groupadd user && useradd -d "$DOORBOT_HOME" -m -g user user -s /bin/bash
RUN mkdir -p "$DOORBOT_HOME" && chown -R user:user "$DOORBOT_HOME"
USER user

CMD "./serve"