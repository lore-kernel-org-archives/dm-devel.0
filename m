Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8880C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-dWSZUTFGPnyOucB7uz5O2w-1; Thu, 14 Apr 2022 09:18:26 -0400
X-MC-Unique: dWSZUTFGPnyOucB7uz5O2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DDCF1C068F4;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E6CBE40D1B98;
	Thu, 14 Apr 2022 13:18:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B91841940344;
	Thu, 14 Apr 2022 13:18:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8219619451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34C1542B922; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30657428F14
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 147F286B8A5
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-x5B8os1SOp-7ZPSwS2SAbg-1; Thu, 14 Apr 2022 09:18:19 -0400
X-MC-Unique: x5B8os1SOp-7ZPSwS2SAbg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id F404821617;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C13B4132C0;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id qHGQLRkfWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:06 +0200
Message-Id: <20220414131811.2551-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 2/7] multipath-tools: make multipath_dir a
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8916872029647078442=="

--===============8916872029647078442==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

There should be no reason to change this at runtime. Make it
configurable at runtime instead, using the make variable
"plugindir".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc               |  3 ++-
 README.md                  |  3 +++
 libmultipath/checkers.c    | 20 ++++++++++----------
 libmultipath/checkers.h    |  4 ++--
 libmultipath/config.c      |  7 +------
 libmultipath/config.h      |  1 -
 libmultipath/defaults.h    |  1 -
 libmultipath/dict.c        | 31 ++-----------------------------
 libmultipath/foreign.c     | 11 ++++++-----
 libmultipath/foreign.h     |  2 +-
 libmultipath/prio.c        | 19 ++++++++++---------
 libmultipath/prio.h        |  6 +++---
 libmultipath/propsel.c     | 31 ++++++++++++++-----------------
 multipath/main.c           |  6 +++---
 multipath/multipath.conf.5 |  8 +-------
 multipathd/main.c          |  6 +++---
 16 files changed, 61 insertions(+), 98 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 03f73e4..05ea737 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -96,6 +96,7 @@ libdmmpdir=09=3D $(TOPDIR)/libdmmp
 nvmedir=09=09=3D $(TOPDIR)/libmultipath/nvme
 includedir=09=3D $(prefix)/usr/include
 pkgconfdir=09=3D $(usrlibdir)/pkgconfig
+plugindir       :=3D $(prefix)/$(LIB)/multipath
=20
 GZIP_PROG=09=3D gzip -9 -c
 RM=09=09=3D rm -f
@@ -126,7 +127,7 @@ WARNFLAGS=09:=3D -Werror -Wall -Wextra -Wformat=3D2 $(W=
FORMATOVERFLOW) -Werror=3Dimplici
 =09=09  $(WNOCLOBBERED) -Werror=3Dcast-qual $(ERROR_DISCARDED_QUALIFIERS)
 CPPFLAGS=09:=3D -D_FORTIFY_SOURCE=3D2
 CFLAGS=09=09:=3D --std=3Dgnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
-=09=09   -DBIN_DIR=3D\"$(bindir)\" -DLIB_STRING=3D\"${LIB}\" -DRUN_DIR=3D\=
"${RUN}\" \
+=09=09   -DBIN_DIR=3D\"$(bindir)\" -DMULTIPATH_DIR=3D\"$(plugindir)\" -DRU=
N_DIR=3D\"${RUN}\" \
 =09=09   -DEXTRAVERSION=3D\"$(EXTRAVERSION)\" -MMD -MP
 BIN_CFLAGS=09=3D -fPIE -DPIE
 LIB_CFLAGS=09=3D -fPIC
diff --git a/README.md b/README.md
index 1547862..e0d5e11 100644
--- a/README.md
+++ b/README.md
@@ -72,6 +72,9 @@ Customizing the build
=20
 The following variables can be passed to the `make` command line:
=20
+ * `plugindir=3D"/some/path"`: directory where libmultipath plugins (path
+   checkers, prioritizers, and foreign multipath support) will be looked u=
p.
+   This used to be the run-time option `multipath_dir` in earlier versions=
.
  * `ENABLE_LIBDMMP=3D0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=3D0`: disable support for the device-mapper event
    polling API. For use with pre-5.0 kernels that don't supprt dmevent pol=
ling
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 00554d6..fdb91e1 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -12,6 +12,8 @@
 #include "vector.h"
 #include "util.h"
=20
+static const char * const checker_dir =3D MULTIPATH_DIR;
+
 struct checker_class {
 =09struct list_head node;
 =09void *handle;
@@ -133,8 +135,7 @@ void reset_checker_classes(void)
 =09}
 }
=20
-static struct checker_class *add_checker_class(const char *multipath_dir,
-=09=09=09=09=09       const char *name)
+static struct checker_class *add_checker_class(const char *name)
 {
 =09char libname[LIB_CHECKER_NAMELEN];
 =09struct stat stbuf;
@@ -148,10 +149,10 @@ static struct checker_class *add_checker_class(const =
char *multipath_dir,
 =09if (!strncmp(c->name, NONE, 4))
 =09=09goto done;
 =09snprintf(libname, LIB_CHECKER_NAMELEN, "%s/libcheck%s.so",
-=09=09 multipath_dir, name);
+=09=09 checker_dir, name);
 =09if (stat(libname,&stbuf) < 0) {
 =09=09condlog(0,"Checker '%s' not found in %s",
-=09=09=09name, multipath_dir);
+=09=09=09name, checker_dir);
 =09=09goto out;
 =09}
 =09condlog(3, "loading %s checker", libname);
@@ -409,8 +410,7 @@ void checker_clear_message (struct checker *c)
 =09c->msgid =3D CHECKER_MSGID_NONE;
 }
=20
-void checker_get(const char *multipath_dir, struct checker *dst,
-=09=09 const char *name)
+void checker_get(struct checker *dst, const char *name)
 {
 =09struct checker_class *src =3D NULL;
=20
@@ -420,7 +420,7 @@ void checker_get(const char *multipath_dir, struct chec=
ker *dst,
 =09if (name && strlen(name)) {
 =09=09src =3D checker_class_lookup(name);
 =09=09if (!src)
-=09=09=09src =3D add_checker_class(multipath_dir, name);
+=09=09=09src =3D add_checker_class(name);
 =09}
 =09dst->cls =3D src;
 =09if (!src)
@@ -429,7 +429,7 @@ void checker_get(const char *multipath_dir, struct chec=
ker *dst,
 =09(void)checker_class_ref(dst->cls);
 }
=20
-int init_checkers(const char *multipath_dir)
+int init_checkers(void)
 {
 #ifdef LOAD_ALL_SHARED_LIBS
 =09static const char *const all_checkers[] =3D {
@@ -444,9 +444,9 @@ int init_checkers(const char *multipath_dir)
 =09unsigned int i;
=20
 =09for (i =3D 0; i < ARRAY_SIZE(all_checkers); i++)
-=09=09add_checker_class(multipath_dir, all_checkers[i]);
+=09=09add_checker_class(all_checkers[i]);
 #else
-=09if (!add_checker_class(multipath_dir, DEFAULT_CHECKER))
+=09if (!add_checker_class(DEFAULT_CHECKER))
 =09=09return 1;
 #endif
 =09return 0;
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 5d25a42..ea1e8af 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -135,7 +135,7 @@ static inline int checker_selected(const struct checker=
 *c)
 }
=20
 const char *checker_state_name(int);
-int init_checkers(const char *);
+int init_checkers(void);
 void cleanup_checkers (void);
 int checker_init (struct checker *, void **);
 int checker_mp_init(struct checker *, void **);
@@ -179,7 +179,7 @@ void reset_checker_classes(void);
  */
 const char *checker_message(const struct checker *);
 void checker_clear_message (struct checker *c);
-void checker_get(const char *, struct checker *, const char *);
+void checker_get(struct checker *, const char *);
=20
 /* Prototypes for symbols exported by path checker dynamic libraries (.so)=
 */
 int libcheck_check(struct checker *);
diff --git a/libmultipath/config.c b/libmultipath/config.c
index c3cfa11..faf4d8a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -732,9 +732,6 @@ static void _uninit_config(struct config *conf)
 =09if (!conf)
 =09=09conf =3D &__internal_config;
=20
-=09if (conf->multipath_dir)
-=09=09free(conf->multipath_dir);
-
 =09if (conf->selector)
 =09=09free(conf->selector);
=20
@@ -929,7 +926,6 @@ int _init_config (const char *file, struct config *conf=
)
 =09conf->bindings_file =3D set_default(DEFAULT_BINDINGS_FILE);
 =09conf->wwids_file =3D set_default(DEFAULT_WWIDS_FILE);
 =09conf->prkeys_file =3D set_default(DEFAULT_PRKEYS_FILE);
-=09conf->multipath_dir =3D set_default(DEFAULT_MULTIPATHDIR);
 =09conf->attribute_flags =3D 0;
 =09conf->reassign_maps =3D DEFAULT_REASSIGN_MAPS;
 =09conf->checkint =3D CHECKINT_UNDEF;
@@ -1089,8 +1085,7 @@ int _init_config (const char *file, struct config *co=
nf)
 =09if (conf->bindings_file =3D=3D NULL)
 =09=09conf->bindings_file =3D set_default(DEFAULT_BINDINGS_FILE);
=20
-=09if (!conf->multipath_dir || !conf->bindings_file ||
-=09    !conf->wwids_file || !conf->prkeys_file)
+=09if (!conf->bindings_file || !conf->wwids_file || !conf->prkeys_file)
 =09=09goto out;
=20
 =09libmp_verbosity =3D conf->verbosity;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 4f1a18a..2cb9e97 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -198,7 +198,6 @@ struct config {
 =09unsigned int sequence_nr;
 =09int recheck_wwid;
=20
-=09char * multipath_dir;
 =09char * selector;
 =09struct _vector uid_attrs;
 =09char * uid_attribute;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 7d95413..72dcae2 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -11,7 +11,6 @@
 #define DEFAULT_NVME_UID_ATTRIBUTE=09"ID_WWN"
 #define DEFAULT_DASD_UID_ATTRIBUTE=09"ID_UID"
 #define DEFAULT_UDEVDIR=09=09"/dev"
-#define DEFAULT_MULTIPATHDIR=09"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR=09"service-time 0"
 #define DEFAULT_ALIAS_PREFIX=09"mpath"
 #define DEFAULT_FEATURES=09"0"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0be4309..4e58d51 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -115,32 +115,6 @@ set_str(vector strvec, void *ptr, const char *file, in=
t line_nr)
 =09return 0;
 }
=20
-static int
-set_dir(vector strvec, void *ptr, const char *file, int line_nr)
-{
-=09char **str_ptr =3D (char **)ptr;
-=09char *old_str =3D *str_ptr;
-=09struct stat sb;
-
-=09*str_ptr =3D set_value(strvec);
-=09if (!*str_ptr) {
-=09=09free(old_str);
-=09=09return 1;
-=09}
-=09if ((*str_ptr)[0] !=3D '/'){
-=09=09condlog(1, "%s line %d, %s is not an absolute directory path. Ignori=
ng", file, line_nr, *str_ptr);
-=09=09*str_ptr =3D old_str;
-=09} else {
-=09=09if (stat(*str_ptr, &sb) =3D=3D 0 && S_ISDIR(sb.st_mode))
-=09=09=09free(old_str);
-=09=09else {
-=09=09=09condlog(1, "%s line %d, %s is not an existing directory. Ignoring=
", file, line_nr, *str_ptr);
-=09=09=09*str_ptr =3D old_str;
-=09=09}
-=09}
-=09return 0;
-}
-
 static int
 set_path(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -479,8 +453,7 @@ declare_def_snprint(verbosity, print_int)
 declare_def_handler(reassign_maps, set_yes_no)
 declare_def_snprint(reassign_maps, print_yes_no)
=20
-declare_def_warn_handler(multipath_dir, set_dir)
-declare_def_snprint(multipath_dir, print_str)
+declare_deprecated_handler(multipath_dir)
=20
 static int def_partition_delim_handler(struct config *conf, vector strvec,
 =09=09=09=09       const char *file, int line_nr)
@@ -2048,7 +2021,7 @@ init_keywords(vector keywords)
 =09install_keyword("polling_interval", &checkint_handler, &snprint_def_che=
ckint);
 =09install_keyword("max_polling_interval", &def_max_checkint_handler, &snp=
rint_def_max_checkint);
 =09install_keyword("reassign_maps", &def_reassign_maps_handler, &snprint_d=
ef_reassign_maps);
-=09install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_d=
ef_multipath_dir);
+=09install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_d=
eprecated);
 =09install_keyword("path_selector", &def_selector_handler, &snprint_def_se=
lector);
 =09install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint=
_def_pgpolicy);
 =09install_keyword("uid_attrs", &uid_attrs_handler, &snprint_uid_attrs);
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index e80eb3e..d01a5ef 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -37,6 +37,7 @@
 #include "strbuf.h"
=20
 static vector foreigns;
+static const char *const foreign_dir =3D MULTIPATH_DIR;
=20
 /* This protects vector foreigns */
 static pthread_rwlock_t foreign_lock =3D PTHREAD_RWLOCK_INITIALIZER;
@@ -125,7 +126,7 @@ static void free_pre(void *arg)
 =09}
 }
=20
-static int _init_foreign(const char *multipath_dir, const char *enable)
+static int _init_foreign(const char *enable)
 {
 =09char pathbuf[PATH_MAX];
 =09struct dirent **di;
@@ -153,7 +154,7 @@ static int _init_foreign(const char *multipath_dir, con=
st char *enable)
 =09=09}
 =09}
=20
-=09r =3D scandir(multipath_dir, &di, select_foreign_libs, alphasort);
+=09r =3D scandir(foreign_dir, &di, select_foreign_libs, alphasort);
=20
 =09if (r =3D=3D 0) {
 =09=09condlog(3, "%s: no foreign multipath libraries found",
@@ -208,7 +209,7 @@ static int _init_foreign(const char *multipath_dir, con=
st char *enable)
 =09=09=09=09=09__func__, ret, fgn->name);
 =09=09}
=20
-=09=09snprintf(pathbuf, sizeof(pathbuf), "%s/%s", multipath_dir, fn);
+=09=09snprintf(pathbuf, sizeof(pathbuf), "%s/%s", foreign_dir, fn);
 =09=09fgn->handle =3D dlopen(pathbuf, RTLD_NOW|RTLD_LOCAL);
 =09=09msg =3D dlerror();
 =09=09if (fgn->handle =3D=3D NULL) {
@@ -257,7 +258,7 @@ out_free_pre:
 =09return r;
 }
=20
-int init_foreign(const char *multipath_dir, const char *enable)
+int init_foreign(const char *enable)
 {
 =09int ret;
=20
@@ -270,7 +271,7 @@ int init_foreign(const char *multipath_dir, const char =
*enable)
 =09}
=20
 =09pthread_cleanup_push(unlock_foreigns, NULL);
-=09ret =3D _init_foreign(multipath_dir, enable);
+=09ret =3D _init_foreign(enable);
 =09pthread_cleanup_pop(1);
=20
 =09return ret;
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index f547c14..b9cdb36 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -198,7 +198,7 @@ struct foreign {
  * @param enable: regex to match foreign library name ("*" above) against
  * @returns: 0 on success, negative value on failure.
  */
-int init_foreign(const char *multipath_dir, const char *enable);
+int init_foreign(const char *enable);
=20
 /**
  * cleanup_foreign(dir)
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index ef68cd0..cdd3752 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -8,6 +8,7 @@
 #include "util.h"
 #include "prio.h"
=20
+static const char * const prio_dir =3D MULTIPATH_DIR;
 static LIST_HEAD(prioritizers);
=20
 unsigned int get_prio_timeout(unsigned int timeout_ms,
@@ -18,7 +19,7 @@ unsigned int get_prio_timeout(unsigned int timeout_ms,
 =09return default_timeout;
 }
=20
-int init_prio (const char *multipath_dir)
+int init_prio(void)
 {
 #ifdef LOAD_ALL_SHARED_LIBS
 =09static const char *const all_prios[] =3D {
@@ -39,9 +40,9 @@ int init_prio (const char *multipath_dir)
 =09unsigned int i;
=20
 =09for  (i =3D 0; i < ARRAY_SIZE(all_prios); i++)
-=09=09add_prio(multipath_dir, all_prios[i]);
+=09=09add_prio(all_prios[i]);
 #else
-=09if (!add_prio(multipath_dir, DEFAULT_PRIO))
+=09if (!add_prio(DEFAULT_PRIO))
 =09=09return 1;
 #endif
 =09return 0;
@@ -90,7 +91,7 @@ void cleanup_prio(void)
 =09}
 }
=20
-static struct prio * prio_lookup (char * name)
+static struct prio *prio_lookup(const char *name)
 {
 =09struct prio * p;
=20
@@ -109,7 +110,7 @@ int prio_set_args (struct prio * p, const char * args)
 =09return snprintf(p->args, PRIO_ARGS_LEN, "%s", args);
 }
=20
-struct prio * add_prio (const char *multipath_dir, const char * name)
+struct prio *add_prio (const char *name)
 {
 =09char libname[LIB_PRIO_NAMELEN];
 =09struct stat stbuf;
@@ -121,10 +122,10 @@ struct prio * add_prio (const char *multipath_dir, co=
nst char * name)
 =09=09return NULL;
 =09snprintf(p->name, PRIO_NAME_LEN, "%s", name);
 =09snprintf(libname, LIB_PRIO_NAMELEN, "%s/libprio%s.so",
-=09=09 multipath_dir, name);
+=09=09 prio_dir, name);
 =09if (stat(libname,&stbuf) < 0) {
 =09=09condlog(0,"Prioritizer '%s' not found in %s",
-=09=09=09name, multipath_dir);
+=09=09=09name, prio_dir);
 =09=09goto out;
 =09}
 =09condlog(3, "loading %s prioritizer", libname);
@@ -170,7 +171,7 @@ const char * prio_args (const struct prio * p)
 =09return p->args;
 }
=20
-void prio_get (char *multipath_dir, struct prio * dst, char * name, char *=
 args)
+void prio_get(struct prio *dst, const char *name, const char *args)
 {
 =09struct prio * src =3D NULL;
=20
@@ -180,7 +181,7 @@ void prio_get (char *multipath_dir, struct prio * dst, =
char * name, char * args)
 =09if (name && strlen(name)) {
 =09=09src =3D prio_lookup(name);
 =09=09if (!src)
-=09=09=09src =3D add_prio(multipath_dir, name);
+=09=09=09src =3D add_prio(name);
 =09}
 =09if (!src) {
 =09=09dst->getprio =3D NULL;
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 66c7936..184bf65 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -54,11 +54,11 @@ struct prio {
=20
 unsigned int get_prio_timeout(unsigned int checker_timeout,
 =09=09=09      unsigned int default_timeout);
-int init_prio (const char *);
+int init_prio(void);
 void cleanup_prio (void);
-struct prio * add_prio (const char *, const char *);
+struct prio * add_prio (const char *);
 int prio_getprio (struct prio *, struct path *, unsigned int);
-void prio_get (char *, struct prio *, char *, char *);
+void prio_get (struct prio *, const char *, const char *);
 void prio_put (struct prio *);
 int prio_selected (const struct prio *);
 const char * prio_name (const struct prio *);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 72b4299..84da96e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -560,7 +560,7 @@ int select_checker(struct config *conf, struct path *pp=
)
 =09do_set(checker_name, conf, ckr_name, conf_origin);
 =09do_default(ckr_name, DEFAULT_CHECKER);
 out:
-=09checker_get(conf->multipath_dir, c, ckr_name);
+=09checker_get(c, ckr_name);
 =09condlog(3, "%s: path_checker =3D %s %s", pp->dev,
 =09=09checker_name(c), origin);
 =09if (conf->checker_timeout) {
@@ -627,8 +627,7 @@ out:
 =09return 0;
 }
=20
-void
-detect_prio(struct config *conf, struct path * pp)
+void detect_prio(struct path *pp)
 {
 =09struct prio *p =3D &pp->prio;
 =09char buff[512];
@@ -654,19 +653,19 @@ detect_prio(struct config *conf, struct path * pp)
 =09default:
 =09=09return;
 =09}
-=09prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
+=09prio_get(p, default_prio, DEFAULT_PRIO_ARGS);
 }
=20
-#define set_prio(dir, src, msg)=09=09=09=09=09\
+#define set_prio(src, msg)=09=09=09=09=09=09\
 do {=09=09=09=09=09=09=09=09=09\
 =09if (src && src->prio_name) {=09=09=09=09=09\
-=09=09prio_get(dir, p, src->prio_name, src->prio_args);=09\
+=09=09prio_get(p, src->prio_name, src->prio_args);=09=09\
 =09=09origin =3D msg;=09=09=09=09=09=09\
 =09=09goto out;=09=09=09=09=09=09\
 =09}=09=09=09=09=09=09=09=09\
 } while(0)
=20
-#define set_prio_from_vec(type, dir, src, msg, p)=09=09=09\
+#define set_prio_from_vec(type, src, msg, p)=09=09=09=09\
 do {=09=09=09=09=09=09=09=09=09\
 =09type *_p;=09=09=09=09=09=09=09\
 =09int i;=09=09=09=09=09=09=09=09\
@@ -679,7 +678,7 @@ do {=09=09=09=09=09=09=09=09=09\
 =09=09=09prio_args =3D _p->prio_args;=09=09=09\
 =09}=09=09=09=09=09=09=09=09\
 =09if (prio_name !=3D NULL) {=09=09=09=09=09\
-=09=09prio_get(dir, p, prio_name, prio_args);=09=09=09\
+=09=09prio_get(p, prio_name, prio_args);=09=09=09\
 =09=09origin =3D msg;=09=09=09=09=09=09\
 =09=09goto out;=09=09=09=09=09=09\
 =09}=09=09=09=09=09=09=09=09\
@@ -693,19 +692,18 @@ int select_prio(struct config *conf, struct path *pp)
 =09int log_prio =3D 3;
=20
 =09if (pp->detect_prio =3D=3D DETECT_PRIO_ON) {
-=09=09detect_prio(conf, pp);
+=09=09detect_prio(pp);
 =09=09if (prio_selected(p)) {
 =09=09=09origin =3D autodetect_origin;
 =09=09=09goto out;
 =09=09}
 =09}
 =09mpe =3D find_mpe(conf->mptable, pp->wwid);
-=09set_prio(conf->multipath_dir, mpe, multipaths_origin);
-=09set_prio(conf->multipath_dir, conf->overrides, overrides_origin);
-=09set_prio_from_vec(struct hwentry, conf->multipath_dir,
-=09=09=09  pp->hwe, hwe_origin, p);
-=09set_prio(conf->multipath_dir, conf, conf_origin);
-=09prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
+=09set_prio(mpe, multipaths_origin);
+=09set_prio(conf->overrides, overrides_origin);
+=09set_prio_from_vec(struct hwentry, pp->hwe, hwe_origin, p);
+=09set_prio(conf, conf_origin);
+=09prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 =09origin =3D default_origin;
 out:
 =09/*
@@ -715,8 +713,7 @@ out:
 =09=09int tpgs =3D path_get_tpgs(pp);
=20
 =09=09if (tpgs =3D=3D TPGS_NONE) {
-=09=09=09prio_get(conf->multipath_dir,
-=09=09=09=09 p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
+=09=09=09prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 =09=09=09origin =3D "(setting: emergency fallback - alua failed)";
 =09=09=09log_prio =3D 1;
 =09=09}
diff --git a/multipath/main.c b/multipath/main.c
index 01eba9a..034dd2f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -988,11 +988,11 @@ main (int argc, char *argv[])
=20
 =09libmp_udev_set_sync_support(1);
=20
-=09if (init_checkers(conf->multipath_dir)) {
+=09if (init_checkers()) {
 =09=09condlog(0, "failed to initialize checkers");
 =09=09goto out;
 =09}
-=09if (init_prio(conf->multipath_dir)) {
+=09if (init_prio()) {
 =09=09condlog(0, "failed to initialize prioritizers");
 =09=09goto out;
 =09}
@@ -1001,7 +1001,7 @@ main (int argc, char *argv[])
 =09=09conf->enable_foreign =3D strdup("");
=20
 =09/* Failing here is non-fatal */
-=09init_foreign(conf->multipath_dir, conf->enable_foreign);
+=09init_foreign(conf->enable_foreign);
 =09if (cmd =3D=3D CMD_USABLE_PATHS) {
 =09=09r =3D check_usable_paths(conf, dev, dev_type) ?
 =09=09=09RTVL_FAIL : RTVL_OK;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ca25c61..4032641 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -178,13 +178,7 @@ The default is: \fBno\fR
 .
 .TP
 .B multipath_dir
-This option is deprecated, and will be removed in a future release.
-Directory where the dynamic shared objects are stored. Defined at compile =
time,
-commonly \fI/lib64/multipath/\fR or \fI/lib/multipath/\fR.
-.RS
-.TP
-The default is: \fB<system dependent>\fR
-.RE
+This option is not supported any more. The value is ignored.
 .
 .
 .TP
diff --git a/multipathd/main.c b/multipathd/main.c
index 6808ad1..2f2b9d4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3308,17 +3308,17 @@ child (__attribute__((unused)) void *param)
 =09=09conf->bindings_read_only =3D bindings_read_only;
 =09uxsock_timeout =3D conf->uxsock_timeout;
 =09rcu_assign_pointer(multipath_conf, conf);
-=09if (init_checkers(conf->multipath_dir)) {
+=09if (init_checkers()) {
 =09=09condlog(0, "failed to initialize checkers");
 =09=09goto failed;
 =09}
-=09if (init_prio(conf->multipath_dir)) {
+=09if (init_prio()) {
 =09=09condlog(0, "failed to initialize prioritizers");
 =09=09goto failed;
 =09}
 =09/* Failing this is non-fatal */
=20
-=09init_foreign(conf->multipath_dir, conf->enable_foreign);
+=09init_foreign(conf->enable_foreign);
=20
 =09if (poll_dmevents)
 =09=09poll_dmevents =3D dmevent_poll_supported();
--=20
2.35.1


--===============8916872029647078442==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8916872029647078442==--

