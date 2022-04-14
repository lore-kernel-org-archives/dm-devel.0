Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0275CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-KJOoEc3hMFuKz4vM9D1o4Q-1; Thu, 14 Apr 2022 09:18:31 -0400
X-MC-Unique: KJOoEc3hMFuKz4vM9D1o4Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4D5986B8AB;
	Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE38742B92D;
	Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27DE91940356;
	Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12F811940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 036C12024CDD; Thu, 14 Apr 2022 13:18:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1B432024CDA
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C2B803533
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-KF2I1oCKMpyrgL5gb9KUOQ-1; Thu, 14 Apr 2022 09:18:20 -0400
X-MC-Unique: KF2I1oCKMpyrgL5gb9KUOQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id EE9C51F74B;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BAE7F132C0;
 Thu, 14 Apr 2022 13:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sEcELBofWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:10 +0200
Message-Id: <20220414131811.2551-7-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 6/7] multipath-tools: stop supporting
 getuid_callout
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2312294308822304188=="

--===============2312294308822304188==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

getuid_callout has been deprecated since 2013, commit d7dc36d ("multipath:
Deprecate 'getuid' configuration variable"). Stop using it for good.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile      |   2 +-
 libmultipath/callout.c     | 221 -------------------------------------
 libmultipath/callout.h     |   7 --
 libmultipath/config.c      |  14 ---
 libmultipath/config.h      |   3 -
 libmultipath/dict.c        |  15 +--
 libmultipath/discovery.c   |  22 +---
 libmultipath/propsel.c     |   8 +-
 libmultipath/structs.c     |   1 -
 libmultipath/structs.h     |   1 -
 multipath/multipath.conf.5 |  22 +---
 11 files changed, 11 insertions(+), 305 deletions(-)
 delete mode 100644 libmultipath/callout.c
 delete mode 100644 libmultipath/callout.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 77e954a..b3a48c4 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -50,7 +50,7 @@ ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HE=
ADERS_INCDIR)/scsi/fc/f
 endif
=20
=20
-OBJS =3D parser.o vector.o devmapper.o callout.o \
+OBJS =3D parser.o vector.o devmapper.o \
 =09hwtable.o blacklist.o util.o dmparser.o config.o \
 =09structs.o discovery.o propsel.o dict.o \
 =09pgpolicies.o debug.o defaults.o uevent.o time-util.o \
diff --git a/libmultipath/callout.c b/libmultipath/callout.c
deleted file mode 100644
index 57c3481..0000000
--- a/libmultipath/callout.c
+++ /dev/null
@@ -1,221 +0,0 @@
-/*
- * Source: copy of the udev package source file
- *
- * Copyrights of the source file apply
- * Copyright (c) 2004 Christophe Varoqui
- */
-#include <stdio.h>
-#include <sys/stat.h>
-#include <string.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <sys/wait.h>
-#include <errno.h>
-
-#include "checkers.h"
-#include "vector.h"
-#include "structs.h"
-#include "util.h"
-#include "callout.h"
-#include "debug.h"
-
-int execute_program(char *path, char *value, int len)
-{
-=09int retval;
-=09int count;
-=09int status;
-=09int fds[2], null_fd;
-=09pid_t pid;
-=09char *pos;
-=09char arg[CALLOUT_MAX_SIZE];
-=09int argc =3D sizeof(arg) / 2;
-=09char *argv[argc + 1];
-=09int i;
-
-=09i =3D 0;
-
-=09if (strchr(path, ' ')) {
-=09=09strlcpy(arg, path, sizeof(arg));
-=09=09pos =3D arg;
-=09=09while (pos !=3D NULL && i < argc) {
-=09=09=09if (pos[0] =3D=3D '\'') {
-=09=09=09=09/* don't separate if in apostrophes */
-=09=09=09=09pos++;
-=09=09=09=09argv[i] =3D strsep(&pos, "\'");
-=09=09=09=09while (pos[0] =3D=3D ' ')
-=09=09=09=09=09pos++;
-=09=09=09} else {
-=09=09=09=09argv[i] =3D strsep(&pos, " ");
-=09=09=09}
-=09=09=09i++;
-=09=09}
-=09} else {
-=09=09argv[i++] =3D path;
-=09}
-=09argv[i] =3D  NULL;
-
-=09retval =3D pipe(fds);
-
-=09if (retval !=3D 0) {
-=09=09condlog(0, "error creating pipe for callout: %s", strerror(errno));
-=09=09return -1;
-=09}
-
-=09pid =3D fork();
-
-=09switch(pid) {
-=09case 0:
-=09=09/* child */
-
-=09=09/* dup write side of pipe to STDOUT */
-=09=09if (dup2(fds[1], STDOUT_FILENO) < 0) {
-=09=09=09condlog(1, "failed to dup2 stdout: %m");
-=09=09=09return -1;
-=09=09}
-=09=09close(fds[0]);
-=09=09close(fds[1]);
-
-=09=09/* Ignore writes to stderr */
-=09=09null_fd =3D open("/dev/null", O_WRONLY);
-=09=09if (null_fd > 0) {
-=09=09=09if (dup2(null_fd, STDERR_FILENO) < 0)
-=09=09=09=09condlog(1, "failed to dup2 stderr: %m");
-=09=09=09close(null_fd);
-=09=09}
-
-=09=09retval =3D execv(argv[0], argv);
-=09=09condlog(0, "error execing %s : %s", argv[0], strerror(errno));
-=09=09exit(-1);
-=09case -1:
-=09=09condlog(0, "fork failed: %s", strerror(errno));
-=09=09close(fds[0]);
-=09=09close(fds[1]);
-=09=09return -1;
-=09default:
-=09=09/* parent reads from fds[0] */
-=09=09close(fds[1]);
-=09=09retval =3D 0;
-=09=09i =3D 0;
-=09=09while (1) {
-=09=09=09count =3D read(fds[0], value + i, len - i-1);
-=09=09=09if (count <=3D 0)
-=09=09=09=09break;
-
-=09=09=09i +=3D count;
-=09=09=09if (i >=3D len-1) {
-=09=09=09=09condlog(0, "not enough space for response from %s", argv[0]);
-=09=09=09=09retval =3D -1;
-=09=09=09=09break;
-=09=09=09}
-=09=09}
-
-=09=09if (count < 0) {
-=09=09=09condlog(0, "no response from %s", argv[0]);
-=09=09=09retval =3D -1;
-=09=09}
-
-=09=09if (i > 0 && value[i-1] =3D=3D '\n')
-=09=09=09i--;
-=09=09value[i] =3D '\0';
-
-=09=09wait(&status);
-=09=09close(fds[0]);
-
-=09=09retval =3D -1;
-=09=09if (WIFEXITED(status)) {
-=09=09=09status =3D WEXITSTATUS(status);
-=09=09=09if (status =3D=3D 0)
-=09=09=09=09retval =3D 0;
-=09=09=09else
-=09=09=09=09condlog(0, "%s exited with %d", argv[0], status);
-=09=09}
-=09=09else if (WIFSIGNALED(status))
-=09=09=09condlog(0, "%s was terminated by signal %d", argv[0], WTERMSIG(st=
atus));
-=09=09else
-=09=09=09condlog(0, "%s terminated abnormally", argv[0]);
-=09}
-=09return retval;
-}
-
-int apply_format(char * string, char * cmd, struct path * pp)
-{
-=09char * pos;
-=09char * dst;
-=09char * p;
-=09char * q;
-=09int len;
-=09int myfree;
-
-=09if (!string)
-=09=09return 1;
-
-=09if (!cmd)
-=09=09return 1;
-
-=09dst =3D cmd;
-=09p =3D dst;
-=09pos =3D strchr(string, '%');
-=09myfree =3D CALLOUT_MAX_SIZE;
-
-=09if (!pos) {
-=09=09strlcpy(dst, string, CALLOUT_MAX_SIZE);
-=09=09return 0;
-=09}
-
-=09len =3D (int) (pos - string) + 1;
-=09myfree -=3D len;
-
-=09if (myfree < 2)
-=09=09return 1;
-
-=09snprintf(p, len, "%s", string);
-=09p +=3D len - 1;
-=09pos++;
-
-=09switch (*pos) {
-=09case 'n':
-=09=09len =3D strlen(pp->dev) + 1;
-=09=09myfree -=3D len;
-
-=09=09if (myfree < 2)
-=09=09=09return 1;
-
-=09=09snprintf(p, len, "%s", pp->dev);
-=09=09for (q =3D p; q < p + len; q++) {
-=09=09=09if (q && *q =3D=3D '!')
-=09=09=09=09*q =3D '/';
-=09=09}
-=09=09p +=3D len - 1;
-=09=09break;
-=09case 'd':
-=09=09len =3D strlen(pp->dev_t) + 1;
-=09=09myfree -=3D len;
-
-=09=09if (myfree < 2)
-=09=09=09return 1;
-
-=09=09snprintf(p, len, "%s", pp->dev_t);
-=09=09p +=3D len - 1;
-=09=09break;
-=09default:
-=09=09break;
-=09}
-=09pos++;
-
-=09if (!*pos) {
-=09=09condlog(3, "formatted callout =3D %s", dst);
-=09=09return 0;
-=09}
-
-=09len =3D strlen(pos) + 1;
-=09myfree -=3D len;
-
-=09if (myfree < 2)
-=09=09return 1;
-
-=09snprintf(p, len, "%s", pos);
-=09condlog(3, "reformatted callout =3D %s", dst);
-=09return 0;
-}
diff --git a/libmultipath/callout.h b/libmultipath/callout.h
deleted file mode 100644
index ab648e8..0000000
--- a/libmultipath/callout.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _CALLOUT_H
-#define _CALLOUT_H
-
-int execute_program(char *, char *, int);
-int apply_format (char *, char *, struct path *);
-
-#endif /* _CALLOUT_H */
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 5478c1d..51b35cf 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -264,9 +264,6 @@ free_hwe (struct hwentry * hwe)
 =09if (hwe->revision)
 =09=09free(hwe->revision);
=20
-=09if (hwe->getuid)
-=09=09free(hwe->getuid);
-
 =09if (hwe->uid_attribute)
 =09=09free(hwe->uid_attribute);
=20
@@ -327,9 +324,6 @@ free_mpe (struct mpentry * mpe)
 =09if (mpe->selector)
 =09=09free(mpe->selector);
=20
-=09if (mpe->getuid)
-=09=09free(mpe->getuid);
-
 =09if (mpe->uid_attribute)
 =09=09free(mpe->uid_attribute);
=20
@@ -435,7 +429,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 =09merge_str(vendor);
 =09merge_str(product);
 =09merge_str(revision);
-=09merge_str(getuid);
 =09merge_str(uid_attribute);
 =09merge_str(features);
 =09merge_str(hwhandler);
@@ -487,7 +480,6 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 {
 =09merge_str(alias);
 =09merge_str(uid_attribute);
-=09merge_str(getuid);
 =09merge_str(selector);
 =09merge_str(features);
 =09merge_str(prio_name);
@@ -579,9 +571,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 =09if (dhwe->uid_attribute && !(hwe->uid_attribute =3D set_param_str(dhwe-=
>uid_attribute)))
 =09=09goto out;
=20
-=09if (dhwe->getuid && !(hwe->getuid =3D set_param_str(dhwe->getuid)))
-=09=09goto out;
-
 =09if (dhwe->features && !(hwe->features =3D set_param_str(dhwe->features)=
))
 =09=09goto out;
=20
@@ -742,9 +731,6 @@ static void _uninit_config(struct config *conf)
 =09=09free(ptr);
 =09vector_reset(&conf->uid_attrs);
=20
-=09if (conf->getuid)
-=09=09free(conf->getuid);
-
 =09if (conf->features)
 =09=09free(conf->features);
=20
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 4d001e4..1520df7 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -52,7 +52,6 @@ struct hwentry {
 =09char * product;
 =09char * revision;
 =09char * uid_attribute;
-=09char * getuid;
 =09char * features;
 =09char * hwhandler;
 =09char * selector;
@@ -100,7 +99,6 @@ struct mpentry {
 =09char * wwid;
 =09char * alias;
 =09char * uid_attribute;
-=09char * getuid;
 =09char * selector;
 =09char * features;
=20
@@ -201,7 +199,6 @@ struct config {
 =09char * selector;
 =09struct _vector uid_attrs;
 =09char * uid_attribute;
-=09char * getuid;
 =09char * features;
 =09char * hwhandler;
 =09char * bindings_file;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c380350..ad049cc 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -635,13 +635,6 @@ declare_ovr_snprint(uid_attribute, print_str)
 declare_hw_handler(uid_attribute, set_str)
 declare_hw_snprint(uid_attribute, print_str)
=20
-declare_def_handler(getuid, set_str)
-declare_def_snprint(getuid, print_str)
-declare_ovr_handler(getuid, set_str)
-declare_ovr_snprint(getuid, print_str)
-declare_hw_handler(getuid, set_str)
-declare_hw_snprint(getuid, print_str)
-
 declare_def_handler(prio_name, set_str)
 declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
 declare_ovr_handler(prio_name, set_str)
@@ -1990,6 +1983,8 @@ snprint_deprecated (struct config *conf, struct strbu=
f *buff, const void * data)
 =09return 0;
 }
=20
+declare_deprecated_handler(getuid_callout)
+
 /*
  * If you add or remove a keyword also update multipath/multipath.conf.5
  */
@@ -2006,7 +2001,7 @@ init_keywords(vector keywords)
 =09install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint=
_def_pgpolicy);
 =09install_keyword("uid_attrs", &uid_attrs_handler, &snprint_uid_attrs);
 =09install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_d=
ef_uid_attribute);
-=09install_keyword("getuid_callout", &def_getuid_handler, &snprint_def_get=
uid);
+=09install_keyword("getuid_callout", &deprecated_getuid_callout_handler, &=
snprint_deprecated);
 =09install_keyword("prio", &def_prio_name_handler, &snprint_def_prio_name)=
;
 =09install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_=
args);
 =09install_keyword("features", &def_features_handler, &snprint_def_feature=
s);
@@ -2107,7 +2102,7 @@ init_keywords(vector keywords)
 =09install_keyword("product_blacklist", &hw_bl_product_handler, &snprint_h=
w_bl_product);
 =09install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_=
hw_pgpolicy);
 =09install_keyword("uid_attribute", &hw_uid_attribute_handler, &snprint_hw=
_uid_attribute);
-=09install_keyword("getuid_callout", &hw_getuid_handler, &snprint_hw_getui=
d);
+=09install_keyword("getuid_callout", &deprecated_getuid_callout_handler, &=
snprint_deprecated);
 =09install_keyword("path_selector", &hw_selector_handler, &snprint_hw_sele=
ctor);
 =09install_keyword("path_checker", &hw_checker_name_handler, &snprint_hw_c=
hecker_name);
 =09install_keyword("checker", &hw_checker_name_handler, NULL);
@@ -2151,7 +2146,7 @@ init_keywords(vector keywords)
 =09install_keyword_root("overrides", &overrides_handler);
 =09install_keyword("path_grouping_policy", &ovr_pgpolicy_handler, &snprint=
_ovr_pgpolicy);
 =09install_keyword("uid_attribute", &ovr_uid_attribute_handler, &snprint_o=
vr_uid_attribute);
-=09install_keyword("getuid_callout", &ovr_getuid_handler, &snprint_ovr_get=
uid);
+=09install_keyword("getuid_callout", &deprecated_getuid_callout_handler, &=
snprint_deprecated);
 =09install_keyword("path_selector", &ovr_selector_handler, &snprint_ovr_se=
lector);
 =09install_keyword("path_checker", &ovr_checker_name_handler, &snprint_ovr=
_checker_name);
 =09install_keyword("checker", &ovr_checker_name_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ec4151c..0d8a558 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -21,7 +21,6 @@
 #include "structs.h"
 #include "config.h"
 #include "blacklist.h"
-#include "callout.h"
 #include "debug.h"
 #include "propsel.h"
 #include "sg_include.h"
@@ -2210,7 +2209,7 @@ get_uid (struct path * pp, int path_state, struct ude=
v_device *udev,
 =09int used_fallback =3D 0;
 =09size_t i;
=20
-=09if (!pp->uid_attribute && !pp->getuid) {
+=09if (!pp->uid_attribute) {
 =09=09conf =3D get_multipath_config();
 =09=09pthread_cleanup_push(put_multipath_config, conf);
 =09=09select_getuid(conf, pp);
@@ -2219,24 +2218,7 @@ get_uid (struct path * pp, int path_state, struct ud=
ev_device *udev,
 =09}
=20
 =09memset(pp->wwid, 0, WWID_SIZE);
-=09if (pp->getuid) {
-=09=09char buff[CALLOUT_MAX_SIZE];
-
-=09=09/* Use 'getuid' callout, deprecated */
-=09=09condlog(1, "%s: using deprecated getuid callout", pp->dev);
-=09=09if (path_state !=3D PATH_UP) {
-=09=09=09condlog(3, "%s: path inaccessible", pp->dev);
-=09=09=09len =3D -EWOULDBLOCK;
-=09=09} else if (apply_format(pp->getuid, &buff[0], pp)) {
-=09=09=09condlog(0, "error formatting uid callout command");
-=09=09=09len =3D -EINVAL;
-=09=09} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-=09=09=09condlog(3, "error calling out %s", buff);
-=09=09=09len =3D -EIO;
-=09=09} else
-=09=09=09len =3D strlen(pp->wwid);
-=09=09origin =3D "callout";
-=09} else if (pp->uid_attribute) {
+=09if (pp->uid_attribute) {
 =09=09/* if the uid_attribute is an empty string skip udev checking */
 =09=09bool check_uid_attr =3D udev && *pp->uid_attribute;
=20
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 84da96e..50d0b5c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -589,20 +589,14 @@ int select_getuid(struct config *conf, struct path *p=
p)
 =09=09goto out;
 =09}
=20
-=09pp_set_ovr(getuid);
 =09pp_set_ovr(uid_attribute);
-=09pp_set_hwe(getuid);
 =09pp_set_hwe(uid_attribute);
-=09pp_set_conf(getuid);
 =09pp_set_conf(uid_attribute);
 =09pp_set_default(uid_attribute, DEFAULT_UID_ATTRIBUTE);
 out:
 =09if (pp->uid_attribute)
 =09=09condlog(3, "%s: uid_attribute =3D %s %s", pp->dev,
 =09=09=09pp->uid_attribute, origin);
-=09else if (pp->getuid)
-=09=09condlog(3, "%s: getuid =3D \"%s\" %s", pp->dev, pp->getuid,
-=09=09=09origin);
 =09return 0;
 }
=20
@@ -617,7 +611,7 @@ int select_recheck_wwid(struct config *conf, struct pat=
h * pp)
 =09pp_set_default(recheck_wwid, DEFAULT_RECHECK_WWID);
 out:
 =09if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
-=09    (pp->bus !=3D SYSFS_BUS_SCSI || pp->getuid !=3D NULL ||
+=09    (pp->bus !=3D SYSFS_BUS_SCSI ||
 =09     !has_uid_fallback(pp))) {
 =09=09pp->recheck_wwid =3D RECHECK_WWID_OFF;
 =09=09origin =3D "(setting: unsupported by device type/config)";
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 2c9be04..49621cb 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -139,7 +139,6 @@ uninitialize_path(struct path *pp)
=20
 =09pp->dmstate =3D PSTATE_UNDEF;
 =09pp->uid_attribute =3D NULL;
-=09pp->getuid =3D NULL;
=20
 =09if (checker_selected(&pp->checker))
 =09=09checker_put(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 38aba34..a6a0944 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -329,7 +329,6 @@ struct path {
 =09int detect_checker;
 =09int tpgs;
 =09const char *uid_attribute;
-=09char * getuid;
 =09struct prio prio;
 =09struct checker checker;
 =09struct multipath * mpp;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b81fc9b..fe838e3 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -283,12 +283,7 @@ The default is: \fBID_WWN\fR, for NVMe devices
 .
 .TP
 .B getuid_callout
-(Superseded by \fIuid_attribute\fR) The default program and args to callou=
t
-to obtain a unique path identifier. Should be specified with an absolute p=
ath.
-.RS
-.TP
-The default is: \fB<unset>\fR
-.RE
+This option is not supported any more. The value is ignored.
 .
 .
 .TP
@@ -1598,8 +1593,6 @@ section:
 .TP
 .B uid_attribute
 .TP
-.B getuid_callout
-.TP
 .B path_selector
 .TP
 .B path_checker
@@ -1682,8 +1675,6 @@ the values are taken from the \fIdevices\fR or \fIdef=
aults\fR sections:
 .TP
 .B uid_attribute
 .TP
-.B getuid_callout
-.TP
 .B path_selector
 .TP
 .B path_checker
@@ -1800,18 +1791,9 @@ The WWID is generated by four methods (in the order =
of preference):
 The WWID is derived from udev attributes by matching the device node name;=
 cf
 \fIuid_attrs\fR above.
 .TP
-.B getuid_callout
-Use the specified external program; cf \fIgetuid_callout\fR above.
-Care should be taken when using this method; the external program
-needs to be loaded from disk for execution, which might lead to
-deadlock situations in an all-paths-down scenario.
-.TP
 .B uid_attribute
 Use the value of the specified udev attribute; cf \fIuid_attribute\fR
-above. This method is preferred to \fIgetuid_callout\fR as multipath
-does not need to call any external programs here. However, under
-certain circumstances udev might not be able to generate the requested
-variable.
+above.
 .TP
 .B sysfs
 Try to determine the WWID from sysfs attributes.
--=20
2.35.1


--===============2312294308822304188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2312294308822304188==--

