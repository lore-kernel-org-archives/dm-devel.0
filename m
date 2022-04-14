Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5177DC43219
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-Vx4TThvIO7KqqpAziAg63A-1; Thu, 14 Apr 2022 09:18:28 -0400
X-MC-Unique: Vx4TThvIO7KqqpAziAg63A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F24B805F0E;
	Thu, 14 Apr 2022 13:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1ADD040D0176;
	Thu, 14 Apr 2022 13:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D996A1940345;
	Thu, 14 Apr 2022 13:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8143F19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73D65C15D7E; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 700D2C159B3
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5292286B8A3
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-hWKL4jdhMHSgKlkyDdQGfQ-1; Thu, 14 Apr 2022 09:18:19 -0400
X-MC-Unique: hWKL4jdhMHSgKlkyDdQGfQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 41E721F748;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B8F2132C0;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iI05ARofWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:07 +0200
Message-Id: <20220414131811.2551-4-mwilck@suse.com>
In-Reply-To: <20220414131811.2551-1-mwilck@suse.com>
References: <20220414131811.2551-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 3/7] multipath-tools: make config_dir a
 compiled-in option
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3996009834112374045=="

--===============3996009834112374045==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Don't allow overriding the configuration directory at runtime.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc               |  3 ++-
 README.md                  |  3 +++
 libmultipath/config.c      | 10 +---------
 libmultipath/config.h      |  1 -
 libmultipath/defaults.h    |  1 -
 libmultipath/dict.c        | 29 +++++------------------------
 multipath/multipath.conf.5 | 10 +---------
 multipathd/uxlsnr.c        | 27 +++++++--------------------
 8 files changed, 19 insertions(+), 65 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 05ea737..cef7a06 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -97,6 +97,7 @@ nvmedir=09=09=3D $(TOPDIR)/libmultipath/nvme
 includedir=09=3D $(prefix)/usr/include
 pkgconfdir=09=3D $(usrlibdir)/pkgconfig
 plugindir       :=3D $(prefix)/$(LIB)/multipath
+configdir       :=3D $(prefix)/etc/multipath/conf.d
=20
 GZIP_PROG=09=3D gzip -9 -c
 RM=09=09=3D rm -f
@@ -128,7 +129,7 @@ WARNFLAGS=09:=3D -Werror -Wall -Wextra -Wformat=3D2 $(W=
FORMATOVERFLOW) -Werror=3Dimplici
 CPPFLAGS=09:=3D -D_FORTIFY_SOURCE=3D2
 CFLAGS=09=09:=3D --std=3Dgnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 =09=09   -DBIN_DIR=3D\"$(bindir)\" -DMULTIPATH_DIR=3D\"$(plugindir)\" -DRU=
N_DIR=3D\"${RUN}\" \
-=09=09   -DEXTRAVERSION=3D\"$(EXTRAVERSION)\" -MMD -MP
+=09=09   -DCONFIG_DIR=3D\"$(configdir)\" -DEXTRAVERSION=3D\"$(EXTRAVERSION=
)\" -MMD -MP
 BIN_CFLAGS=09=3D -fPIE -DPIE
 LIB_CFLAGS=09=3D -fPIC
 SHARED_FLAGS=09=3D -shared
diff --git a/README.md b/README.md
index e0d5e11..d67888d 100644
--- a/README.md
+++ b/README.md
@@ -75,6 +75,9 @@ The following variables can be passed to the `make` comma=
nd line:
  * `plugindir=3D"/some/path"`: directory where libmultipath plugins (path
    checkers, prioritizers, and foreign multipath support) will be looked u=
p.
    This used to be the run-time option `multipath_dir` in earlier versions=
.
+ * `configdir=3D"/some/path"` : directory to search for configuration file=
s.
+    This used to be the run-time option `config_dir` in earlier versions.
+=09The default is `/etc/multipath/conf.d`.
  * `ENABLE_LIBDMMP=3D0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=3D0`: disable support for the device-mapper event
    polling API. For use with pre-5.0 kernels that don't supprt dmevent pol=
ling
diff --git a/libmultipath/config.c b/libmultipath/config.c
index faf4d8a..5478c1d 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -774,11 +774,6 @@ static void _uninit_config(struct config *conf)
 =09if (conf->checker_name)
 =09=09free(conf->checker_name);
=20
-=09if (conf->config_dir)
-=09=09free(conf->config_dir);
-=09if (conf->enable_foreign)
-=09=09free(conf->enable_foreign);
-
 =09free_blacklist(conf->blist_devnode);
 =09free_blacklist(conf->blist_wwid);
 =09free_blacklist(conf->blist_property);
@@ -974,10 +969,7 @@ int _init_config (const char *file, struct config *con=
f)
 =09}
=20
 =09conf->processed_main_config =3D 1;
-=09if (conf->config_dir =3D=3D NULL)
-=09=09conf->config_dir =3D set_default(DEFAULT_CONFIG_DIR);
-=09if (conf->config_dir && conf->config_dir[0] !=3D '\0')
-=09=09process_config_dir(conf, conf->config_dir);
+=09process_config_dir(conf, CONFIG_DIR);
=20
 =09/*
 =09 * fill the voids left in the config file
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2cb9e97..4d001e4 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -212,7 +212,6 @@ struct config {
 =09char * checker_name;
 =09char * alias_prefix;
 =09char * partition_delim;
-=09char * config_dir;
 =09int prkey_source;
 =09int all_tg_pt;
 =09struct be64 reservation_key;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 72dcae2..7979f20 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -68,7 +68,6 @@
 #define DEFAULT_BINDINGS_FILE=09"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE=09"/etc/multipath/wwids"
 #define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
-#define DEFAULT_CONFIG_DIR=09"/etc/multipath/conf.d"
 #define MULTIPATH_SHM_BASE=09"/dev/shm/multipath/"
=20
=20
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4e58d51..91a0580 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -266,8 +266,8 @@ static int deprecated_handler(struct config *conf, vect=
or strvec, const char *fi
=20
 #define declare_deprecated_handler(option)=09=09=09=09\
 static int=09=09=09=09=09=09=09=09\
-def_ ## option ## _handler (struct config *conf, vector strvec,=09=09\
-=09=09=09    const char *file, int line_nr)=09=09\
+deprecated_ ## option ## _handler (struct config *conf, vector strvec,=09\
+=09=09=09=09   const char *file, int line_nr)=09\
 {=09=09=09=09=09=09=09=09=09\
 =09static bool warned;=09=09=09=09=09=09\
 =09if (!warned) {=09=09=09=09=09=09=09\
@@ -846,26 +846,7 @@ declare_def_handler(enable_foreign, set_str)
 declare_def_snprint_defstr(enable_foreign, print_str,
 =09=09=09   DEFAULT_ENABLE_FOREIGN)
=20
-static int
-def_config_dir_handler(struct config *conf, vector strvec, const char *fil=
e,
-=09=09       int line_nr)
-{
-=09static bool warned;
-
-=09/* this is only valid in the main config file */
-=09if (conf->processed_main_config) {
-=09=09condlog(1, "%s line %d, config_dir option only valid in /etc/multipa=
th.conf",
-=09=09=09file, line_nr);
-=09=09return 0;
-=09}
-=09if (!warned) {
-=09=09condlog(2, "%s line %d, \"config_dir\" is deprecated and will be dis=
abled in a future release",
-=09=09=09file, line_nr);
-=09=09warned =3D true;
-=09}
-=09return set_path(strvec, &conf->config_dir, file, line_nr);
-}
-declare_def_snprint(config_dir, print_str)
+declare_deprecated_handler(config_dir)
=20
 #define declare_def_attr_handler(option, function)=09=09=09\
 static int=09=09=09=09=09=09=09=09\
@@ -2021,7 +2002,7 @@ init_keywords(vector keywords)
 =09install_keyword("polling_interval", &checkint_handler, &snprint_def_che=
ckint);
 =09install_keyword("max_polling_interval", &def_max_checkint_handler, &snp=
rint_def_max_checkint);
 =09install_keyword("reassign_maps", &def_reassign_maps_handler, &snprint_d=
ef_reassign_maps);
-=09install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_d=
eprecated);
+=09install_keyword("multipath_dir", &deprecated_multipath_dir_handler, &sn=
print_deprecated);
 =09install_keyword("path_selector", &def_selector_handler, &snprint_def_se=
lector);
 =09install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint=
_def_pgpolicy);
 =09install_keyword("uid_attrs", &uid_attrs_handler, &snprint_uid_attrs);
@@ -2064,7 +2045,7 @@ init_keywords(vector keywords)
 =09install_keyword("strict_timing", &def_strict_timing_handler, &snprint_d=
ef_strict_timing);
 =09install_keyword("deferred_remove", &def_deferred_remove_handler, &snpri=
nt_def_deferred_remove);
 =09install_keyword("partition_delimiter", &def_partition_delim_handler, &s=
nprint_def_partition_delim);
-=09install_keyword("config_dir", &def_config_dir_handler, &snprint_def_con=
fig_dir);
+=09install_keyword("config_dir", &deprecated_config_dir_handler, &snprint_=
deprecated);
 =09install_keyword("delay_watch_checks", &def_delay_watch_checks_handler, =
&snprint_def_delay_watch_checks);
 =09install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &s=
nprint_def_delay_wait_checks);
 =09install_keyword("san_path_err_threshold", &def_san_path_err_threshold_h=
andler, &snprint_def_san_path_err_threshold);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4032641..b81fc9b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -933,15 +933,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B config_dir
-This option is deprecated, and will be removed in a future release.
-If set to anything other than "", multipath will search this directory
-alphabetically for file ending in ".conf" and it will read configuration
-information from them, just as if it was in \fI/etc/multipath.conf\fR.
-config_dir must either be "" or a fully qualified directory name.
-.RS
-.TP
-The default is: \fB/etc/multipath/conf.d/\fR
-.RE
+This option is not supported any more. The value is ignored.
 .
 .
 .TP
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index c07367f..645e356 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -91,7 +91,6 @@ static LIST_HEAD(clients);
 static struct pollfd *polls;
 static int notify_fd =3D -1;
 static int idle_fd =3D -1;
-static char *watch_config_dir;
=20
 static bool _socket_client_is_root(int fd)
 {
@@ -167,7 +166,6 @@ void uxsock_cleanup(void *arg)
=20
 =09close(ux_sock);
 =09close(notify_fd);
-=09free(watch_config_dir);
=20
 =09list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
 =09=09dead_client(client_loop);
@@ -213,16 +211,7 @@ static void reset_watch(int notify_fd, struct watch_de=
scriptors *wds,
 =09=09*sequence_nr =3D conf->sequence_nr;
 =09=09if (wds->conf_wd =3D=3D -1)
 =09=09=09conf_reset =3D 1;
-=09=09if (!watch_config_dir || !conf->config_dir ||
-=09=09    strcmp(watch_config_dir, conf->config_dir)) {
-=09=09=09dir_reset =3D 1;
-=09=09=09if (watch_config_dir)
-=09=09=09=09free(watch_config_dir);
-=09=09=09if (conf->config_dir)
-=09=09=09=09watch_config_dir =3D strdup(conf->config_dir);
-=09=09=09else
-=09=09=09=09watch_config_dir =3D NULL;
-=09=09} else if (wds->dir_wd =3D=3D -1)
+=09=09if (wds->dir_wd =3D=3D -1)
 =09=09=09dir_reset =3D 1;
 =09}
 =09put_multipath_config(conf);
@@ -232,14 +221,12 @@ static void reset_watch(int notify_fd, struct watch_d=
escriptors *wds,
 =09=09=09inotify_rm_watch(notify_fd, wds->dir_wd);
 =09=09=09wds->dir_wd =3D -1;
 =09=09}
-=09=09if (watch_config_dir) {
-=09=09=09wds->dir_wd =3D inotify_add_watch(notify_fd,
-=09=09=09=09=09=09=09watch_config_dir,
-=09=09=09=09=09=09=09IN_CLOSE_WRITE |
-=09=09=09=09=09=09=09IN_DELETE | IN_ONLYDIR);
-=09=09=09if (wds->dir_wd =3D=3D -1)
-=09=09=09=09condlog(3, "didn't set up notifications on %s: %m", watch_conf=
ig_dir);
-=09=09}
+=09=09wds->dir_wd =3D inotify_add_watch(notify_fd,
+=09=09=09=09=09=09CONFIG_DIR,
+=09=09=09=09=09=09IN_CLOSE_WRITE |
+=09=09=09=09=09=09IN_DELETE | IN_ONLYDIR);
+=09=09if (wds->dir_wd =3D=3D -1)
+=09=09=09condlog(3, "didn't set up notifications on %s: %m", CONFIG_DIR);
 =09}
 =09if (conf_reset) {
 =09=09wds->conf_wd =3D inotify_add_watch(notify_fd, DEFAULT_CONFIGFILE,
--=20
2.35.1


--===============3996009834112374045==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3996009834112374045==--

