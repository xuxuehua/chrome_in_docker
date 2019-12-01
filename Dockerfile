FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER vnc

RUN apt-get update && \
    apt-get install -y --no-install-recommends  gnome-session gdm3 \
    ubuntu-desktop \
    terminator \ 
    gdebi \
	gnupg2 \
	fonts-takao \
	pulseaudio \
	supervisor \
	x11vnc \
	tasksel \
	sudo \
	fluxbox \
	eterm && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver 

ADD https://dl.google.com/linux/linux_signing_key.pub \
	https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb \
	/tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& gdebi --non-interactive /tmp/google-chrome-stable_current_amd64.deb \
	&& gdebi --non-interactive /tmp/chrome-remote-desktop_current_amd64.deb
	
RUN echo "%vnc     ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

RUN adduser --gecos "" vnc && mkdir -p /home/vnc/.vnc
RUN chown -R vnc:vnc /home/vnc

ADD xstartup /home/vnc/.vnc/xstartup

RUN echo '/usr/bin/startlxde' >> /home/vnc/.vnc/xstartup


USER vnc

RUN printf "password\npassword\n\n" | vncpasswd

CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 24 && tail -f /home/vnc/.vnc/*:1.log

EXPOSE 5901





