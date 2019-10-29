COPY Dockerfile /

RUN apt-get update 
&& apt-get install -y 
libjson-webtoken-perl 
libauthen-ntlm-perl 
libcgi-pm-perl 
libcrypt-openssl-rsa-perl 
libdata-uniqid-perl 
libfile-copy-recursive-perl 
libio-socket-ssl-perl 
libio-socket-inet6-perl 
libio-tee-perl 
libhtml-parser-perl 
libjson-webtoken-perl 
libmail-imapclient-perl 
libparse-recdescent-perl 
libmodule-scandeps-perl 
libpar-packer-perl 
libreadonly-perl 
libregexp-common-perl 
libsys-meminfo-perl 
libterm-readkey-perl 
libtest-mockobject-perl 
libtest-pod-perl 
libunicode-string-perl 
liburi-perl 
libwww-perl 
procps 
wget 
make 
cpanminus 
&& rm -rf /var/lib/apt/lists/*

RUN wget -N https://imapsync.lamiral.info/imapsync 
https://imapsync.lamiral.info/prerequisites_imapsync 
&& cp imapsync /usr/bin/imapsync 
&& chmod +x /usr/bin/imapsync # just_a_comment_to_force_update 2018_09_13_14_44_03

USER nobody

ENV HOME /var/tmp/

CMD ["/usr/bin/imapsync"]

#
