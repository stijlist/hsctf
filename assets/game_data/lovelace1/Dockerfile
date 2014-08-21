FROM stilliard/pure-ftpd
RUN yes "notthepasswordyourelookingfor" | pure-pw useradd mycroft -u ftpuser -d /home/ftpusers/mycroft
RUN pure-pw mkdb
RUN echo "1000" > /etc/pure-ftpd/conf/MaxClientsNumber
RUN echo "1000" > /etc/pure-ftpd/conf/MaxClientsPerIP
COPY ./password /home/ftpusers/mycroft/

CMD /usr/sbin/pure-ftpd -c 1000 -C 1000 -l puredb:/etc/pure-ftpd/pureftpd.pdb -x -E -j -R &\
     /bin/bash