FROM debian:latest

RUN apt update \
    && apt install -y \
        ntp \
        samba \ 
        winbind \
        ldb-tools \ 
        bind9 bind9utils \
        krb5-admin-server krb5-k5tls \
        openssl ca-certificates certbot \
        pwgen expect \
        supervisor \
        rsyslog \
    && apt clean

COPY scripts/kdb5_util_create.expect /root/kdb5_util_create.expect
COPY scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY scripts /root
RUN chmod -R 500 /root
    
VOLUME [ "/var/lib/samba", "/var/lib/krb5kdc", "/etc/samba", "/etc/bind"]
EXPOSE 22 53 389 88 135 139 138 445 464 3268 3269

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["app:start"]
    