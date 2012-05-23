From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Allow user_friendly_names in more
	config	sections
Date: Wed, 23 May 2012 15:36:30 -0500
Message-ID: <20120523203630.GF9924@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds support for setting user_friendly_names in the devices and
multipaths config sections.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c  |    2 +
 libmultipath/config.h  |    2 +
 libmultipath/dict.c    |   94 +++++++++++++++++++++++++++++++++++++++++++++----
 libmultipath/propsel.c |   14 ++++++-
 libmultipath/structs.h |    6 +++
 5 files changed, 110 insertions(+), 8 deletions(-)

Index: multipath-tools-120518/libmultipath/config.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/config.c
+++ multipath-tools-120518/libmultipath/config.c
@@ -325,6 +325,7 @@ merge_hwe (struct hwentry * dst, struct
 	merge_num(flush_on_last_del);
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
+	merge_num(user_friendly_names);
 
 	return 0;
 }
@@ -383,6 +384,7 @@ store_hwe (vector hwtable, struct hwentr
 	hwe->flush_on_last_del = dhwe->flush_on_last_del;
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
+	hwe->user_friendly_names = dhwe->user_friendly_names;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
Index: multipath-tools-120518/libmultipath/config.h
===================================================================
--- multipath-tools-120518.orig/libmultipath/config.h
+++ multipath-tools-120518/libmultipath/config.h
@@ -44,6 +44,7 @@ struct hwentry {
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int user_friendly_names;
 	char * bl_product;
 };
 
@@ -66,6 +67,7 @@ struct mpentry {
 	int pg_timeout;
 	int flush_on_last_del;
 	int attribute_flags;
+	int user_friendly_names;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
Index: multipath-tools-120518/libmultipath/dict.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/dict.c
+++ multipath-tools-120518/libmultipath/dict.c
@@ -583,7 +583,7 @@ def_reservation_key_handler(vector strve
 }
 
 static int
-names_handler(vector strvec)
+def_names_handler(vector strvec)
 {
 	char * buff;
 
@@ -594,10 +594,12 @@ names_handler(vector strvec)
 
 	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
 	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->user_friendly_names = 0;
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
 	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
 		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->user_friendly_names = 1;
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		conf->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
 
 	FREE(buff);
 	return 0;
@@ -1207,6 +1209,32 @@ hw_flush_on_last_del_handler(vector strv
 	return 0;
 }
 
+static int
+hw_names_handler(vector strvec)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+		 (strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		hwe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * multipaths block handlers
  */
@@ -1654,6 +1682,31 @@ mp_reservation_key_handler (vector strve
 	return 0;
 }
 
+static int
+mp_names_handler(vector strvec)
+{
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+	char * buff;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+		 (strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
+	else
+		mpe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
 
 /*
  * config file keywords printing
@@ -1884,6 +1937,18 @@ snprint_mp_reservation_key (char * buff,
 	return snprintf(buff, len, "%s" , mpe->reservation_key);
 }
 
+	static int
+snprint_mp_user_friendly_names (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
+		return 0;
+	else if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return snprintf(buff, len, "yes");
+}
 
 static int
 snprint_hw_fast_io_fail(char * buff, int len, void * data)
@@ -2174,6 +2239,19 @@ snprint_hw_path_checker (char * buff, in
 	return snprintf(buff, len, "%s", hwe->checker_name);
 }
 
+	static int
+snprint_hw_user_friendly_names (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
+		return 0;
+	else if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return snprintf(buff, len, "yes");
+}
+
 static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
@@ -2461,10 +2539,10 @@ snprint_def_log_checker_err (char * buff
 static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
-	if (!conf->user_friendly_names)
+	if (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON)
+		return snprintf(buff, len, "yes");
+	else
 		return snprintf(buff, len, "no");
-
-	return snprintf(buff, len, "yes");
 }
 
 static int
@@ -2547,7 +2625,7 @@ init_keywords(void)
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
-	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
+	install_keyword("user_friendly_names", &def_names_handler, &snprint_def_user_friendly_names);
 	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
 	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
 	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
@@ -2616,6 +2694,7 @@ init_keywords(void)
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
+	install_keyword("user_friendly_names", &hw_names_handler, &snprint_hw_user_friendly_names);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
@@ -2639,5 +2718,6 @@ init_keywords(void)
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
 	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
+	install_keyword("user_friendly_names", &mp_names_handler, &snprint_mp_user_friendly_names);
 	install_sublevel_end();
 }
Index: multipath-tools-120518/libmultipath/propsel.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/propsel.c
+++ multipath-tools-120518/libmultipath/propsel.c
@@ -237,6 +237,18 @@ select_alias_prefix (struct multipath *
 		mp->wwid, mp->alias_prefix);
 }
 
+static int
+want_user_friendly_names(struct multipath * mp)
+{
+	if (mp->mpe &&
+	    mp->mpe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
+		return (mp->mpe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
+	if (mp->hwe &&
+	    mp->hwe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
+		return (mp->hwe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
+	return (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON);
+}
+
 extern int
 select_alias (struct multipath * mp)
 {
@@ -244,7 +256,7 @@ select_alias (struct multipath * mp)
 		mp->alias = STRDUP(mp->mpe->alias);
 	else {
 		mp->alias = NULL;
-		if (conf->user_friendly_names) {
+		if (want_user_friendly_names(mp)) {
 			select_alias_prefix(mp);
 			mp->alias = get_user_friendly_alias(mp->wwid,
 					conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
Index: multipath-tools-120518/libmultipath/structs.h
===================================================================
--- multipath-tools-120518.orig/libmultipath/structs.h
+++ multipath-tools-120518/libmultipath/structs.h
@@ -92,6 +92,12 @@ enum log_checker_err_states {
 	LOG_CHKR_ERR_ONCE,
 };
 
+enum user_friendly_names_states {
+	USER_FRIENDLY_NAMES_UNDEF,
+	USER_FRIENDLY_NAMES_OFF,
+	USER_FRIENDLY_NAMES_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
