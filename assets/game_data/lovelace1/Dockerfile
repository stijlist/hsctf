FROM stilliard/pure-ftpd
RUN yes "notthepasswordyourelookingfor" | pure-pw useradd mycroft -u ftpuser -d /home/ftpusers/mycroft
RUN pure-pw mkdb
RUN echo "1000" > /etc/pure-ftpd/conf/MaxClientsNumber
RUN echo "1000" > /etc/pure-ftpd/conf/MaxClientsPerIP
echo "50000:50400" > /etc/pure-ftpd/conf/PassivePortRange


COPY ./password /home/ftpusers/mycroft/
RUN chown -R root:root /home/ftpusers/mycroft
RUN chmod 755 /home/ftpusers/mycroft/
RUN chmod 755 /home/ftpusers/mycroft/password

CMD /usr/sbin/pure-ftpd -c 1000 -C 1000 -l puredb:/etc/pure-ftpd/pureftpd.pdb -x -E -j -R -N