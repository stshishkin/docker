# Version 0.0.1
FROM ubuntu:14.04
MAINTAINER Shishkin Stepan "st.shishkin@gmail.com"
ENV REFRESHED_AT 2016-08-25
ENV DOWNLOAD_ASTER http://downloads.asterisk.org/pub/telephony/asterisk/
ENV FNAME_ASTER asterisk-11-current.tar.gz
#TODO: install openssl from source
#ENV DOWNLOAD_SSL https://www.openssl.org/source/
#ENV FNAME_SSL openssl-1.0.1t.tar.gz
ENV TMP_DIR /tmp
ENV PROD_DEBS php5 php5-mysql uuid libsrtp0
ENV DEV_DEBS libncurses-dev libz-dev libxml2-dev libsqlite3-dev uuid-dev \
libcurl-dev libspeex-dev libspeexdsp-dev libogg-dev libvorbis-dev libasound2-dev portaudio19-dev libcurl4-openssl-dev \
libpq-dev unixodbc-dev libsqlite0-dev libmysqlclient15-dev libneon27-dev libgmime-dev libusb-dev liblua5.1-0-dev \
libopenh323-dev libvpb-dev libgtk2.0-dev libmysqlclient-dev libbluetooth-dev libradiusclient-ng-dev freetds-dev \
libsnmp-dev libiksemel-dev libcorosync-dev libnewt-dev libpopt-dev libical-dev libspandsp-dev libjack-dev \
libresample-dev libc-client-dev binutils-dev libsrtp-dev libgsm1-dev libedit-dev libldap-dev build-essential 
#preparing system
RUN apt-get check && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install aptitude
RUN aptitude -y install --add-user-tag asterisk-compile $DEV_DEBS
#update openssl from ppa
RUN aptitude -y install software-properties-common && \ 
    add-apt-repository -y ppa:ondrej/php && \
#cause it can't add a public key of ppa with non-ascii description by default
    aptitude update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' | xargs apt-key adv --keyserver keyserver.ubuntu.com --recv-keys && \
    aptitude update && \ 
    aptitude -y install $PROD_DEBS && \
    aptitude -y upgrade openssl libssl1.0.2 libssl-dev
#TODO: install openssl from source
#WORKDIR $TMP_DIR
#ADD $DOWNLOAD_SSL$FNAME_SSL .
#RUN tar -xzf $FNAME_SSL && rm $FNAME_SSL
#RUN cd $(ls -1) && \
#    ./config --prefix=/usr/ --shared && \
#    make depend && \
#    make && \
#    make install

#install latest 11 asterisk
ADD $DOWNLOAD_ASTER$FNAME_ASTER .
RUN tar -xzf $FNAME_ASTER && rm $FNAME_ASTER
RUN cd $(ls -1) && \
    ./configure --with-ssl --with-crypto --with-srtp && \
    make menuselect.makeopts && \
    menuselect/menuselect \
    --disable CORE-SOUNDS-ES-G729 \
    --disable CORE-SOUNDS-ES-G722 \
    --disable CORE-SOUNDS-EN-ULAW \
    --disable CORE-SOUNDS-RU-G729 \
    --disable CORE-SOUNDS-FR-ULAW \
    --disable CORE-SOUNDS-RU-G722 \
    --disable CORE-SOUNDS-RU-WAV \
    --disable CORE-SOUNDS-ES-SIREN7 \
    --disable CORE-SOUNDS-EN_AU-ULAW \
    --disable CORE-SOUNDS-EN-WAV \
    --disable CORE-SOUNDS-ES-WAV \
    --disable CORE-SOUNDS-RU-SLN16 \
    --disable CORE-SOUNDS-EN_AU-ALAW \
    --disable CORE-SOUNDS-EN_AU-SLN16 \
    --disable CORE-SOUNDS-FR-SLN16 \
    --disable CORE-SOUNDS-FR-WAV \
    --disable CORE-SOUNDS-EN_AU-SIREN14 \
    --disable CORE-SOUNDS-RU-ALAW \
    --disable CORE-SOUNDS-EN_AU-SIREN7 \
    --enable CORE-SOUNDS-EN-GSM \
    --disable CORE-SOUNDS-FR-GSM \
    --disable CORE-SOUNDS-EN-SIREN7 \
    --disable CORE-SOUNDS-ES-GSM \
    --disable CORE-SOUNDS-EN_AU-WAV \
    --disable CORE-SOUNDS-RU-SIREN7 \
    --disable CORE-SOUNDS-EN_AU-GSM \
    --disable CORE-SOUNDS-FR-ALAW \
    --disable CORE-SOUNDS-ES-ALAW \
    --disable CORE-SOUNDS-ES-SIREN14 \
    --disable CORE-SOUNDS-FR-SIREN14 \
    --disable CORE-SOUNDS-EN-G729 \
    --disable CORE-SOUNDS-EN-G722 \
    --disable CORE-SOUNDS-EN-SLN16 \
    --disable CORE-SOUNDS-EN_AU-G722 \
    --disable CORE-SOUNDS-FR-G722 \
    --disable CORE-SOUNDS-EN-SIREN14 \
    --disable CORE-SOUNDS-FR-G729 \
    --disable CORE-SOUNDS-EN_AU-G729 \
    --disable CORE-SOUNDS-ES-ULAW \
    --disable CORE-SOUNDS-RU-SIREN14 \
    --disable CORE-SOUNDS-RU-ULAW \
    --disable CORE-SOUNDS-FR-SIREN7 \
    --disable CORE-SOUNDS-ES-SLN16 \
    --enable CORE-SOUNDS-RU-GSM \
    --disable CORE-SOUNDS-EN-ALAW \
    --disable chan_h323 \
    --disable chan_alsa \
    --enable chan_local \
    --disable chan_mgcp \
    --disable chan_vpb \
    --enable chan_agent \
    --enable chan_sip \
    --enable chan_gtalk \
    --enable chan_oss \
    --disable chan_nbs \
    --enable chan_iax2 \
    --enable chan_phone \
    --disable chan_skinny \
    --disable chan_console \
    --enable chan_jingle \
    --enable chan_unistim \
    --enable chan_multicast_rtp \
    --disable chan_misdn \
    --enable chan_dahdi \
    --enable chan_bridge \
    --disable format_mp3 \
    --enable res_config_mysql \
    --disable chan_ooh323 \
    --disable chan_mobile \
    --enable app_mysql \
    --disable app_saycountpl \
    --enable cdr_mysql \
    --disable EXTRA-SOUNDS-EN-ULAW \
    --disable EXTRA-SOUNDS-FR-ULAW \
    --disable EXTRA-SOUNDS-FR-GSM \
    --disable EXTRA-SOUNDS-EN-G722 \
    --disable EXTRA-SOUNDS-EN-ALAW \
    --enable EXTRA-SOUNDS-EN-GSM \
    --disable EXTRA-SOUNDS-EN-SLN16 \
    --disable EXTRA-SOUNDS-EN-SIREN7 \
    --disable EXTRA-SOUNDS-FR-G722 \
    --disable EXTRA-SOUNDS-EN-SIREN14 \
    --disable EXTRA-SOUNDS-EN-G729 \
    --disable EXTRA-SOUNDS-FR-WAV \
    --disable EXTRA-SOUNDS-FR-SIREN14 \
    --disable EXTRA-SOUNDS-FR-SLN16 \
    --disable EXTRA-SOUNDS-FR-G729 \
    --disable EXTRA-SOUNDS-EN-WAV \
    --disable EXTRA-SOUNDS-FR-ALAW \
    --disable EXTRA-SOUNDS-FR-SIREN7 \
    --disable MOH-OPSOUND-G722 \
    --disable MOH-OPSOUND-ALAW \
    --disable MOH-OPSOUND-SLN16 \
    --disable MOH-OPSOUND-ULAW \
    --disable MOH-OPSOUND-WAV \
    --disable MOH-OPSOUND-SIREN14 \
    --enable MOH-OPSOUND-GSM \
    --disable MOH-OPSOUND-G729 \
    --disable MOH-OPSOUND-SIREN7 \
    --disable conf2ael \
    --disable refcounter \
    --disable stereorize \
    --disable check_expr2 \
    --disable check_expr \
    --disable streamplayer \
    --disable muted \
    --disable astman \
    --disable aelparse \
    --disable smsq \
    --enable astcanary \
    --enable codec_g726 \
    --disable codec_resample \
    --enable codec_g722 \
    --enable codec_a_mu \
    --enable codec_ulaw \
    --enable codec_lpc10 \
    --enable codec_ilbc \
    --enable codec_gsm \
    --enable codec_dahdi \
    --disable codec_speex \
    --enable codec_adpcm \
    --enable codec_alaw \
    --disable LOW_MEMORY \
    --disable TEST_TANDEM_TRANSCODING \
    --disable USE_HOARD_ALLOCATOR \
    --disable BETTER_BACKTRACES \
    --enable DONT_OPTIMIZE \
    --disable RADIO_RELAX \
    --disable BUSYDETECT_DEBUG \
    --enable LOADABLE_MODULES \
    --disable LOTS_OF_SPANS \
    --disable BUSYDETECT_COMPARE_TONE_AND_SILENCE \
    --disable INTEGER_CALLERID \
    --disable G711_REDUCED_BRANCHING \
    --disable BUILD_NATIVE \
    --disable TEST_CODING_TABLES \
    --disable BUSYDETECT_TONEONLY \
    --disable MALLOC_DEBUG \
    --disable DEBUG_FD_LEAKS \
    --disable REBUILD_PARSERS \
    --disable DEBUG_THREADS \
    --disable STATIC_BUILD \
    --disable G711_NEW_ALGORITHM \
    --enable format_g719 \
    --enable format_wav \
    --enable format_jpeg \
    --disable format_ogg_vorbis \
    --enable format_vox \
    --enable format_pcm \
    --enable format_sln \
    --enable format_g723 \
    --enable format_ilbc \
    --enable format_wav_gsm \
    --enable format_h264 \
    --enable format_h263 \
    --enable format_g726 \
    --enable format_gsm \
    --enable format_g729 \
    --enable format_siren7 \
    --enable format_siren14 \
    --disable agi-test.agi \
    --disable eagi-sphinx-test \
    --disable jukebox.agi \
    --disable eagi-test \
    --enable bridge_builtin_features \
    --enable bridge_simple \
    --enable bridge_softmix \
    --enable bridge_multiplexed \
    --enable func_dialplan \
    --enable func_blacklist \
    --enable func_devstate \
    --enable func_callerid \
    --enable func_env \
    --disable func_speex \
    --enable func_sha1 \
    --enable func_volume \
    --enable func_base64 \
    --enable func_db \
    --enable func_frame_trace \
    --enable func_dialgroup \
    --enable func_cut \
    --enable func_realtime \
    --enable func_sprintf \
    --enable func_pitchshift \
    --enable func_iconv \
    --enable func_curl \
    --enable func_global \
    --enable func_audiohookinherit \
    --enable func_rand \
    --enable func_vmcount \
    --enable func_lock \
    --enable func_math \
    --enable func_callcompletion \
    --enable func_aes \
    --enable func_timeout \
    --enable func_shell \
    --enable func_srv \
    --enable func_config \
    --enable func_md5 \
    --enable func_odbc \
    --enable func_uri \
    --enable func_sysinfo \
    --enable func_channel \
    --enable func_cdr \
    --enable func_module \
    --enable func_logic \
    --enable func_extstate \
    --enable func_enum \
    --enable func_strings \
    --enable func_version \
    --enable func_groupcount \
    --enable cel_custom \
    --disable cel_tds \
    --enable cel_manager \
    --disable cel_pgsql \
    --disable cel_radius \
    --enable cel_sqlite3_custom \
    --enable cel_odbc \
    --enable app_festival \
    --enable app_test \
    --enable app_controlplayback \
    --enable app_sms \
    --enable app_stack \
    --enable app_echo \
    --enable app_directed_pickup \
    --enable app_record \
    --enable app_authenticate \
    --enable app_while \
    --enable app_cdr \
    --enable app_privacy \
    --disable app_skel \
    --enable app_dial \
    --enable app_flash \
    --enable app_chanspy \
    --enable app_senddtmf \
    --enable app_read \
    --disable app_osplookup \
    --enable app_milliwatt \
    --enable app_dahdibarge \
    --enable app_zapateller \
    --enable app_directory \
    --enable app_fax \
    --enable app_voicemail \
    --enable app_page \
    --enable app_forkcdr \
    --enable app_readexten \
    --enable app_disa \
    --enable app_dumpchan \
    --enable app_externalivr \
    --enable app_parkandannounce \
    --enable app_amd \
    --enable app_verbose \
    --enable app_sayunixtime \
    --disable app_ivrdemo \
    --enable app_sendtext \
    --enable app_playtones \
    --enable app_talkdetect \
    --enable app_userevent \
    --enable app_originate \
    --enable app_dahdiras \
    --enable app_followme \
    --enable app_morsecode \
    --enable app_confbridge \
    --enable app_mp3 \
    --enable app_speech_utils \
    --enable app_ices \
    --disable app_saycounted \
    --enable app_channelredirect \
    --enable app_chanisavail \
    --enable app_image \
    --enable app_nbscat \
    --enable app_db \
    --enable app_system \
    --enable app_alarmreceiver \
    --enable app_setcallerid \
    --enable app_waituntil \
    --enable app_mixmonitor \
    --enable app_adsiprog \
    --enable app_url \
    --enable app_getcpeid \
    --enable app_waitforring \
    --enable app_playback \
    --disable app_jack \
    --enable app_readfile \
    --enable app_exec \
    --enable app_minivm \
    --enable app_macro \
    --enable app_celgenuserevent \
    --enable app_waitforsilence \
    --enable app_meetme \
    --enable app_transfer \
    --enable app_queue \
    --enable app_dictate \
    --enable app_softhangup \
    --enable pbx_lua \
    --enable pbx_config \
    --enable pbx_dundi \
    --enable pbx_spool \
    --enable pbx_ael \
    --enable pbx_loopback \
    --enable pbx_realtime \
    --enable cdr_odbc \
    --enable cdr_custom \
    --enable cdr_adaptive_odbc \
    --enable cdr_sqlite3_custom \
    --disable cdr_pgsql \
    --enable cdr_csv \
    --disable cdr_sqlite \
    --disable cdr_radius \
    --disable cdr_tds \
    --enable cdr_syslog \
    --enable cdr_manager \
    --disable EMBED_TEST \
    --disable EMBED_APPS \
    --disable EMBED_ADDONS \
    --disable EMBED_PBX \
    --disable EMBED_CODECS \
    --disable EMBED_CHANNELS \
    --disable EMBED_BRIDGES \
    --disable EMBED_FUNCS \
    --disable EMBED_FORMATS \
    --disable EMBED_RES \
    --disable EMBED_CDR \
    --enable res_jabber \
    --enable res_adsi \
    --enable res_clialiases \
    --enable res_limit \
    --enable res_rtp_asterisk \
    --enable res_srtp \
    --enable res_clioriginate \
    --disable res_fax \
    --enable res_timing_pthread \
    --enable res_stun_monitor \
    --enable res_timing_timerfd \
    --enable res_realtime \
    --disable res_pktccops \
    --enable res_agi \
    --enable res_speech \
    --disable res_timing_kqueue \
    --enable res_calendar_exchange \
    --disable res_fax_spandsp \
    --enable res_crypto \
    --disable res_config_sqlite \
    --disable res_config_pgsql \
    --enable res_mutestream \
    --enable res_monitor \
    --enable res_config_odbc \
    --enable res_rtp_multicast \
    --disable res_snmp \
    --enable res_config_curl \
    --enable res_config_ldap \
    --enable res_calendar \
    --enable res_calendar_icalendar \
    --enable res_calendar_caldav \
    --enable res_musiconhold \
    --enable res_http_post \
    --enable res_odbc \
    --enable res_timing_dahdi \
    --enable res_curl \
    --enable res_security_log \
    --enable res_convert \
    --enable res_ael_share \
    --enable res_smdi \
    --enable res_calendar_ews \
    --enable res_phoneprov \
    --disable IMAP_STORAGE \
    --enable FILE_STORAGE \
    --disable ODBC_STORAGE \
    --disable test_time \
    --disable test_strings \
    --disable test_ast_format_str_reduce \
    --disable test_substitution \
    --disable test_aoc \
    --disable test_dlinklists \
    --disable test_app \
    --disable test_db \
    --disable test_netsock2 \
    --disable test_poll \
    --disable test_pbx \
    --disable test_hashtab_thrash \
    --disable test_linkedlists \
    --disable test_logger \
    --disable test_locale \
    --disable test_astobj2_thrash \
    --disable test_expr \
    --disable test_devicestate \
    --disable test_gosub \
    --disable test_utils \
    --disable test_stringfields \
    --disable test_config \
    --disable test_acl \
    --disable test_sched \
    --disable test_xml_escape \
    --disable test_func_file \
    --disable test_heap \
    --disable test_astobj2 \
    --disable test_event \
    --disable test_skel \
    --disable test_security_events \
    --disable test_amihooks \
    menuselect.makeopts && \
    make && make install && \
    apt-get clean
#clean up
RUN aptitude -y purge '?user-tag(asterisk-compile)' && \
aptitude autoclean
WORKDIR $TMP_DIR
RUN rm -rf $(ls -1)
#copy certs
ADD clientbase.ru.* /etc/ssl/certs/
#final run
WORKDIR /usr/sbin/
ENTRYPOINT ["asterisk"]
CMD ["-c","-g"]
