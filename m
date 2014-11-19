From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/6] libmultipath: add overrides section to
	multipath.conf
Date: Wed, 19 Nov 2014 00:17:36 -0600
Message-ID: <1416377859-15073-4-git-send-email-bmarzins@redhat.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
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

Sometimes users want to be able to set a configuration value for all their
devices (for instance, they may want all devices to set no_path_retry to
fail). The builtin device configurations make this tricky, since users need
to change each device configuration individually. To avoid that, this patch
adds a new section to multipath.conf, "overrides".  This section has all of
the attributes that are in both the devices and defaults section.
Attributes set in the overrides section have a higher priority that those
in the devices section. With this section added, the multipath
configuration order now goes:

multipaths > overrides > devices > defaults

I also made want_user_friendly_names print out where the configuration came
from, and I made made select_hwhandler and select_selector always strdup
the string, instead of only on the defaults.  Since multipathd will update
the device strings from the kernel anyway, the old way just added
complexity without saving any memory.

To store the overrides configuration, I used a hwentry structure. We may
want to make a new overrides structure, so that we set any of the defaults
values in overrides.  That way, users could skip using defaults and just
use overrides if they wanted. However, this would take some additional
changes to make sure that all the defaults options can undefined, which
they can't currently be.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 +
 libmultipath/dict.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.c       | 30 ++++++++++++++
 libmultipath/print.h       |  1 +
 libmultipath/propsel.c     | 55 +++++++++++++++++++++-----
 libmultipath/structs.c     |  9 +----
 multipath.conf.annotated   | 18 ++++++++-
 multipath.conf.defaults    |  2 +
 multipath.conf.synthetic   |  3 ++
 multipath/main.c           |  6 +++
 multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++
 multipathd/cli_handlers.c  | 10 +++++
 13 files changed, 273 insertions(+), 18 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index bfd8ee8..7f7bd5a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -523,6 +523,7 @@ free_config (struct config * conf)
 
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
+	free_hwe(conf->overrides);
 	free_keywords(conf->keywords);
 	FREE(conf);
 }
diff --git a/libmultipath/config.h b/libmultipath/config.h
index c57ab31..ef1d7c3 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -145,6 +145,7 @@ struct config {
 	vector keywords;
 	vector mptable;
 	vector hwtable;
+	struct hwentry *overrides;
 
 	vector blist_devnode;
 	vector blist_wwid;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 98cbe48..737c9b0 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -181,6 +181,22 @@ snprint_hw_ ## option (char * buff, int len, void * data)		\
 	return function (buff, len, &hwe->option);			\
 }
 
+#define declare_ovr_handler(option, function)				\
+static int								\
+ovr_ ## option ## _handler (vector strvec)				\
+{									\
+	if (!conf->overrides)						\
+		return 1;						\
+	return function (strvec, &conf->overrides->option);		\
+}
+
+#define declare_ovr_snprint(option, function)				\
+static int								\
+snprint_ovr_ ## option (char * buff, int len, void * data)		\
+{									\
+	return function (buff, len, &conf->overrides->option);		\
+}
+
 #define declare_mp_handler(option, function)				\
 static int								\
 mp_ ## option ## _handler (vector strvec)				\
@@ -218,21 +234,29 @@ declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
 declare_hw_handler(selector, set_str)
 declare_hw_snprint(selector, print_str)
+declare_ovr_handler(selector, set_str)
+declare_ovr_snprint(selector, print_str)
 declare_mp_handler(selector, set_str)
 declare_mp_snprint(selector, print_str)
 
 declare_def_handler(uid_attribute, set_str)
 declare_def_snprint_defstr(uid_attribute, print_str, DEFAULT_UID_ATTRIBUTE)
+declare_ovr_handler(uid_attribute, set_str)
+declare_ovr_snprint(uid_attribute, print_str)
 declare_hw_handler(uid_attribute, set_str)
 declare_hw_snprint(uid_attribute, print_str)
 
 declare_def_handler(getuid, set_str)
 declare_def_snprint(getuid, print_str)
+declare_ovr_handler(getuid, set_str)
+declare_ovr_snprint(getuid, print_str)
 declare_hw_handler(getuid, set_str)
 declare_hw_snprint(getuid, print_str)
 
 declare_def_handler(prio_name, set_str)
 declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
+declare_ovr_handler(prio_name, set_str)
+declare_ovr_snprint(prio_name, print_str)
 declare_hw_handler(prio_name, set_str)
 declare_hw_snprint(prio_name, print_str)
 declare_mp_handler(prio_name, set_str)
@@ -240,11 +264,15 @@ declare_mp_snprint(prio_name, print_str)
 
 declare_def_handler(alias_prefix, set_str)
 declare_def_snprint_defstr(alias_prefix, print_str, DEFAULT_ALIAS_PREFIX)
+declare_ovr_handler(alias_prefix, set_str)
+declare_ovr_snprint(alias_prefix, print_str)
 declare_hw_handler(alias_prefix, set_str)
 declare_hw_snprint(alias_prefix, print_str)
 
 declare_def_handler(prio_args, set_str)
 declare_def_snprint_defstr(prio_args, print_str, DEFAULT_PRIO_ARGS)
+declare_ovr_handler(prio_args, set_str)
+declare_ovr_snprint(prio_args, print_str)
 declare_hw_handler(prio_args, set_str)
 declare_hw_snprint(prio_args, print_str)
 declare_mp_handler(prio_args, set_str)
@@ -252,6 +280,8 @@ declare_mp_snprint(prio_args, print_str)
 
 declare_def_handler(features, set_str)
 declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
+declare_ovr_handler(features, set_str)
+declare_ovr_snprint(features, print_str)
 declare_hw_handler(features, set_str)
 declare_hw_snprint(features, print_str)
 declare_mp_handler(features, set_str)
@@ -259,11 +289,15 @@ declare_mp_snprint(features, print_str)
 
 declare_def_handler(checker_name, set_str)
 declare_def_snprint_defstr(checker_name, print_str, DEFAULT_CHECKER)
+declare_ovr_handler(checker_name, set_str)
+declare_ovr_snprint(checker_name, print_str)
 declare_hw_handler(checker_name, set_str)
 declare_hw_snprint(checker_name, print_str)
 
 declare_def_handler(minio, set_int)
 declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
+declare_ovr_handler(minio, set_int)
+declare_ovr_snprint(minio, print_nonzero)
 declare_hw_handler(minio, set_int)
 declare_hw_snprint(minio, print_nonzero)
 declare_mp_handler(minio, set_int)
@@ -271,6 +305,8 @@ declare_mp_snprint(minio, print_nonzero)
 
 declare_def_handler(minio_rq, set_int)
 declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
+declare_ovr_handler(minio_rq, set_int)
+declare_ovr_snprint(minio_rq, print_nonzero)
 declare_hw_handler(minio_rq, set_int)
 declare_hw_snprint(minio_rq, print_nonzero)
 declare_mp_handler(minio_rq, set_int)
@@ -296,6 +332,8 @@ declare_def_snprint(checker_timeout, print_nonzero)
 
 declare_def_handler(flush_on_last_del, set_yes_no_undef)
 declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
+declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
 declare_hw_handler(flush_on_last_del, set_yes_no_undef)
 declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
 declare_mp_handler(flush_on_last_del, set_yes_no_undef)
@@ -303,6 +341,8 @@ declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
 
 declare_def_handler(user_friendly_names, set_yes_no_undef)
 declare_def_snprint_defint(user_friendly_names, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(user_friendly_names, set_yes_no_undef)
+declare_ovr_snprint(user_friendly_names, print_yes_no_undef)
 declare_hw_handler(user_friendly_names, set_yes_no_undef)
 declare_hw_snprint(user_friendly_names, print_yes_no_undef)
 declare_mp_handler(user_friendly_names, set_yes_no_undef)
@@ -316,11 +356,15 @@ declare_def_snprint(wwids_file, print_str)
 
 declare_def_handler(retain_hwhandler, set_yes_no_undef)
 declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
+declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)
 declare_hw_handler(retain_hwhandler, set_yes_no_undef)
 declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
 
 declare_def_handler(detect_prio, set_yes_no_undef)
 declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(detect_prio, set_yes_no_undef)
+declare_ovr_snprint(detect_prio, print_yes_no_undef)
 declare_hw_handler(detect_prio, set_yes_no_undef)
 declare_hw_snprint(detect_prio, print_yes_no_undef)
 
@@ -512,6 +556,8 @@ print_fast_io_fail(char * buff, int len, void *ptr)
 
 declare_def_handler(fast_io_fail, set_fast_io_fail)
 declare_def_snprint(fast_io_fail, print_fast_io_fail)
+declare_ovr_handler(fast_io_fail, set_fast_io_fail)
+declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
 declare_hw_handler(fast_io_fail, set_fast_io_fail)
 declare_hw_snprint(fast_io_fail, print_fast_io_fail)
 
@@ -548,6 +594,8 @@ print_dev_loss(char * buff, int len, void *ptr)
 
 declare_def_handler(dev_loss, set_dev_loss)
 declare_def_snprint(dev_loss, print_dev_loss)
+declare_ovr_handler(dev_loss, set_dev_loss)
+declare_ovr_snprint(dev_loss, print_dev_loss)
 declare_hw_handler(dev_loss, set_dev_loss)
 declare_hw_snprint(dev_loss, print_dev_loss)
 
@@ -583,6 +631,8 @@ print_pgpolicy(char * buff, int len, void *ptr)
 
 declare_def_handler(pgpolicy, set_pgpolicy)
 declare_def_snprint_defint(pgpolicy, print_pgpolicy, DEFAULT_PGPOLICY)
+declare_ovr_handler(pgpolicy, set_pgpolicy)
+declare_ovr_snprint(pgpolicy, print_pgpolicy)
 declare_hw_handler(pgpolicy, set_pgpolicy)
 declare_hw_snprint(pgpolicy, print_pgpolicy)
 declare_mp_handler(pgpolicy, set_pgpolicy)
@@ -700,6 +750,8 @@ print_rr_weight (char * buff, int len, void *ptr)
 
 declare_def_handler(rr_weight, set_rr_weight)
 declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE)
+declare_ovr_handler(rr_weight, set_rr_weight)
+declare_ovr_snprint(rr_weight, print_rr_weight)
 declare_hw_handler(rr_weight, set_rr_weight)
 declare_hw_snprint(rr_weight, print_rr_weight)
 declare_mp_handler(rr_weight, set_rr_weight)
@@ -748,6 +800,8 @@ print_pgfailback (char * buff, int len, void *ptr)
 
 declare_def_handler(pgfailback, set_pgfailback)
 declare_def_snprint_defint(pgfailback, print_pgfailback, DEFAULT_FAILBACK)
+declare_ovr_handler(pgfailback, set_pgfailback)
+declare_ovr_snprint(pgfailback, print_pgfailback)
 declare_hw_handler(pgfailback, set_pgfailback)
 declare_hw_snprint(pgfailback, print_pgfailback)
 declare_mp_handler(pgfailback, set_pgfailback)
@@ -793,6 +847,8 @@ print_no_path_retry(char * buff, int len, void *ptr)
 
 declare_def_handler(no_path_retry, set_no_path_retry)
 declare_def_snprint(no_path_retry, print_no_path_retry)
+declare_ovr_handler(no_path_retry, set_no_path_retry)
+declare_ovr_snprint(no_path_retry, print_no_path_retry)
 declare_hw_handler(no_path_retry, set_no_path_retry)
 declare_hw_snprint(no_path_retry, print_no_path_retry)
 declare_mp_handler(no_path_retry, set_no_path_retry)
@@ -1061,6 +1117,25 @@ declare_hw_handler(hwhandler, set_str)
 declare_hw_snprint(hwhandler, print_str)
 
 /*
+ * overrides handlers
+ */
+static int
+overrides_handler(vector strvec)
+{
+	struct hwentry * overrides;
+
+	overrides = alloc_hwe();
+
+	if (!overrides)
+		return 1;
+
+	conf->overrides = overrides;
+	return 0;
+}
+
+
+
+/*
  * multipaths block handlers
  */
 static int
@@ -1236,6 +1311,29 @@ init_keywords(void)
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_sublevel_end();
 
+	install_keyword_root("overrides", &overrides_handler);
+	install_keyword("path_grouping_policy", &ovr_pgpolicy_handler, &snprint_ovr_pgpolicy);
+	install_keyword("uid_attribute", &ovr_uid_attribute_handler, &snprint_ovr_uid_attribute);
+	install_keyword("getuid_callout", &ovr_getuid_handler, &snprint_ovr_getuid);
+	install_keyword("path_selector", &ovr_selector_handler, &snprint_ovr_selector);
+	install_keyword("path_checker", &ovr_checker_name_handler, &snprint_ovr_checker_name);
+	install_keyword("checker", &ovr_checker_name_handler, NULL);
+	install_keyword("alias_prefix", &ovr_alias_prefix_handler, &snprint_ovr_alias_prefix);
+	install_keyword("features", &ovr_features_handler, &snprint_ovr_features);
+	install_keyword("prio", &ovr_prio_name_handler, &snprint_ovr_prio_name);
+	install_keyword("prio_args", &ovr_prio_args_handler, &snprint_ovr_prio_args);
+	install_keyword("failback", &ovr_pgfailback_handler, &snprint_ovr_pgfailback);
+	install_keyword("rr_weight", &ovr_rr_weight_handler, &snprint_ovr_rr_weight);
+	install_keyword("no_path_retry", &ovr_no_path_retry_handler, &snprint_ovr_no_path_retry);
+	install_keyword("rr_min_io", &ovr_minio_handler, &snprint_ovr_minio);
+	install_keyword("rr_min_io_rq", &ovr_minio_rq_handler, &snprint_ovr_minio_rq);
+	install_keyword("flush_on_last_del", &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
+	install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
+	install_keyword("dev_loss_tmo", &ovr_dev_loss_handler, &snprint_ovr_dev_loss);
+	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
+	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
+	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
+
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
 	install_sublevel();
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 383eae4..ade3841 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1080,6 +1080,36 @@ snprint_mptable (char * buff, int len, vector mptable)
 }
 
 extern int
+snprint_overrides (char * buff, int len, struct hwentry *overrides)
+{
+	int fwd = 0;
+	int i;
+	struct keyword *rootkw;
+	struct keyword *kw;
+
+	rootkw = find_keyword(NULL, "overrides");
+	if (!rootkw)
+		return 0;
+
+	fwd += snprintf(buff + fwd, len - fwd, "overrides {\n");
+	if (fwd > len)
+		return len;
+	if (!overrides)
+		goto out;
+	iterate_sub_keywords(rootkw, kw, i) {
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, NULL);
+		if (fwd > len)
+			return len;
+	}
+out:
+	fwd += snprintf(buff + fwd, len - fwd, "}\n");
+	if (fwd > len)
+		return len;
+	return fwd;
+}
+
+extern int
 snprint_defaults (char * buff, int len)
 {
 	int fwd = 0;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index aef182b..a3c3319 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -50,6 +50,7 @@ int snprint_status (char *, int, struct vectors *);
 int snprint_devices (char *, int, struct vectors *);
 int snprint_hwtable (char *, int, vector);
 int snprint_mptable (char *, int, vector);
+int snprint_overrides (char *, int, struct hwentry *);
 
 void print_multipath_topology (struct multipath * mpp, int verbosity);
 void print_path (struct path * pp, char * style);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f2ab7d2..440802c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -48,6 +48,8 @@ do {									\
 do_set(var, mp->mpe, mp->var, "(LUN setting)")
 #define mp_set_hwe(var)							\
 do_set(var, mp->hwe, mp->var, "(controller setting)")
+#define mp_set_ovr(var)							\
+do_set(var, conf->overrides, mp->var, "(overrides setting)")
 #define mp_set_conf(var)						\
 do_set(var, conf, mp->var, "(config file default)")
 #define mp_set_default(var, value)					\
@@ -59,6 +61,8 @@ do_set(var, mpe, pp->var, "(LUN setting)")
 do_set(var, pp->hwe, pp->var, "(controller setting)")
 #define pp_set_conf(var)						\
 do_set(var, conf, pp->var, "(config file default)")
+#define pp_set_ovr(var)							\
+do_set(var, conf->overrides, pp->var, "(overrides setting)")
 #define pp_set_default(var, value)					\
 do_default(pp->var, value)
 
@@ -130,6 +134,7 @@ select_rr_weight (struct multipath * mp)
 	char *origin, buff[13];
 
 	mp_set_mpe(rr_weight);
+	mp_set_ovr(rr_weight);
 	mp_set_hwe(rr_weight);
 	mp_set_conf(rr_weight);
 	mp_set_default(rr_weight, RR_WEIGHT_NONE);
@@ -145,6 +150,7 @@ select_pgfailback (struct multipath * mp)
 	char *origin, buff[13];
 
 	mp_set_mpe(pgfailback);
+	mp_set_ovr(pgfailback);
 	mp_set_hwe(pgfailback);
 	mp_set_conf(pgfailback);
 	mp_set_default(pgfailback, DEFAULT_FAILBACK);
@@ -165,6 +171,7 @@ select_pgpolicy (struct multipath * mp)
 		goto out;
 	}
 	mp_set_mpe(pgpolicy);
+	mp_set_ovr(pgpolicy);
 	mp_set_hwe(pgpolicy);
 	mp_set_conf(pgpolicy);
 	mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
@@ -181,10 +188,12 @@ select_selector (struct multipath * mp)
 	char *origin;
 
 	mp_set_mpe(selector);
+	mp_set_ovr(selector);
 	mp_set_hwe(selector);
 	mp_set_conf(selector);
-	mp_set_default(selector, set_default(DEFAULT_SELECTOR));
+	mp_set_default(selector, DEFAULT_SELECTOR);
 out:
+	mp->selector = STRDUP(mp->selector);
 	condlog(3, "%s: path_selector = \"%s\" %s", mp->alias, mp->selector,
 		origin);
 	return 0;
@@ -195,6 +204,7 @@ select_alias_prefix (struct multipath * mp)
 {
 	char *origin;
 
+	mp_set_ovr(alias_prefix);
 	mp_set_hwe(alias_prefix);
 	mp_set_conf(alias_prefix);
 	mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
@@ -206,19 +216,30 @@ out:
 static int
 want_user_friendly_names(struct multipath * mp)
 {
-	if (mp->mpe &&
-	    mp->mpe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
-		return (mp->mpe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
-	if (mp->hwe &&
-	    mp->hwe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
-		return (mp->hwe->user_friendly_names == USER_FRIENDLY_NAMES_ON);
-	return (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON);
+
+	char *origin;
+	int user_friendly_names;
+
+	do_set(user_friendly_names, mp->mpe, user_friendly_names,
+	       "(LUN setting)");
+	do_set(user_friendly_names, conf->overrides, user_friendly_names,
+	       "(overrides setting)");
+	do_set(user_friendly_names, mp->hwe, user_friendly_names,
+	       "(controller setting)");
+	do_set(user_friendly_names, conf, user_friendly_names,
+	       "(config file setting)");
+	do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
+out:
+	condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
+		(user_friendly_names == USER_FRIENDLY_NAMES_ON)? "yes" : "no",
+		origin);
+	return (user_friendly_names == USER_FRIENDLY_NAMES_ON);
 }
 
 extern int
 select_alias (struct multipath * mp)
 {
-	char *origin;
+	char *origin = NULL;
 
 	if (mp->mpe && mp->mpe->alias) {
 		mp->alias = STRDUP(mp->mpe->alias);
@@ -261,6 +282,7 @@ select_features (struct multipath * mp)
 	char *origin;
 
 	mp_set_mpe(features);
+	mp_set_ovr(features);
 	mp_set_hwe(features);
 	mp_set_conf(features);
 	mp_set_default(features, DEFAULT_FEATURES);
@@ -287,8 +309,9 @@ select_hwhandler (struct multipath * mp)
 
 	mp_set_hwe(hwhandler);
 	mp_set_conf(hwhandler);
-	mp_set_default(hwhandler, set_default(DEFAULT_HWHANDLER));
+	mp_set_default(hwhandler, DEFAULT_HWHANDLER);
 out:
+	mp->hwhandler = STRDUP(mp->hwhandler);
 	condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias, mp->hwhandler,
 		origin);
 	return 0;
@@ -300,6 +323,7 @@ select_checker(struct path *pp)
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
+	do_set(checker_name, conf->overrides, checker_name, "(overrides setting)");
 	do_set(checker_name, pp->hwe, checker_name, "(controller setting)");
 	do_set(checker_name, conf, checker_name, "(config file setting)");
 	do_default(checker_name, DEFAULT_CHECKER);
@@ -327,6 +351,8 @@ select_getuid (struct path * pp)
 {
 	char *origin;
 
+	pp_set_ovr(uid_attribute);
+	pp_set_ovr(getuid);
 	pp_set_hwe(uid_attribute);
 	pp_set_hwe(getuid);
 	pp_set_conf(uid_attribute);
@@ -383,6 +409,7 @@ select_prio (struct path * pp)
 	}
 	mpe = find_mpe(pp->wwid);
 	set_prio(mpe, "(LUN setting)");
+	set_prio(conf->overrides, "(overrides setting)");
 	set_prio(pp->hwe, "controller setting)");
 	set_prio(conf, "(config file default)");
 	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
@@ -405,6 +432,7 @@ select_no_path_retry(struct multipath *mp)
 		return 0;
 	}
 	mp_set_mpe(no_path_retry);
+	mp_set_ovr(no_path_retry);
 	mp_set_hwe(no_path_retry);
 	mp_set_conf(no_path_retry);
 out:
@@ -427,6 +455,7 @@ select_minio_rq (struct multipath * mp)
 	char *origin;
 
 	do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
+	do_set(minio_rq, conf->overrides, mp->minio, "(overrides setting)");
 	do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
 	do_set(minio_rq, conf, mp->minio, "(config file setting)");
 	do_default(mp->minio, DEFAULT_MINIO_RQ);
@@ -441,6 +470,7 @@ select_minio_bio (struct multipath * mp)
 	char *origin;
 
 	mp_set_mpe(minio);
+	mp_set_ovr(minio);
 	mp_set_hwe(minio);
 	mp_set_conf(minio);
 	mp_set_default(minio, DEFAULT_MINIO);
@@ -465,6 +495,7 @@ select_fast_io_fail(struct multipath *mp)
 {
 	char *origin, buff[12];
 
+	mp_set_ovr(fast_io_fail);
 	mp_set_hwe(fast_io_fail);
 	mp_set_conf(fast_io_fail);
 	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
@@ -479,6 +510,7 @@ select_dev_loss(struct multipath *mp)
 {
 	char *origin, buff[12];
 
+	mp_set_ovr(dev_loss);
 	mp_set_hwe(dev_loss);
 	mp_set_conf(dev_loss);
 	mp->dev_loss = 0;
@@ -497,6 +529,7 @@ select_flush_on_last_del(struct multipath *mp)
 	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
 		return 0;
 	mp_set_mpe(flush_on_last_del);
+	mp_set_ovr(flush_on_last_del);
 	mp_set_hwe(flush_on_last_del);
 	mp_set_conf(flush_on_last_del);
 	mp_set_default(flush_on_last_del, FLUSH_DISABLED);
@@ -532,6 +565,7 @@ select_retain_hwhandler (struct multipath * mp)
 		origin = "(requires kernel version >= 1.5.0)";
 		goto out;
 	}
+	mp_set_ovr(retain_hwhandler);
 	mp_set_hwe(retain_hwhandler);
 	mp_set_conf(retain_hwhandler);
 	mp_set_default(retain_hwhandler, DEFAULT_RETAIN_HWHANDLER);
@@ -547,6 +581,7 @@ select_detect_prio (struct path * pp)
 {
 	char *origin;
 
+	pp_set_ovr(detect_prio);
 	pp_set_hwe(detect_prio);
 	pp_set_conf(detect_prio);
 	pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 30d247d..0538327 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -206,10 +206,7 @@ free_multipath_attributes (struct multipath * mpp)
 	if (!mpp)
 		return;
 
-	if (mpp->selector &&
-	    mpp->selector != conf->selector &&
-	    (!mpp->mpe || (mpp->mpe && mpp->selector != mpp->mpe->selector)) &&
-	    (!mpp->hwe || (mpp->hwe && mpp->selector != mpp->hwe->selector))) {
+	if (mpp->selector) {
 		FREE(mpp->selector);
 		mpp->selector = NULL;
 	}
@@ -219,9 +216,7 @@ free_multipath_attributes (struct multipath * mpp)
 		mpp->features = NULL;
 	}
 
-	if (mpp->hwhandler &&
-	    mpp->hwhandler != conf->hwhandler &&
-	    (!mpp->hwe || (mpp->hwe && mpp->hwhandler != mpp->hwe->hwhandler))) {
+	if (mpp->hwhandler) {
 		FREE(mpp->hwhandler);
 		mpp->hwhandler = NULL;
 	}
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 0af1d4c..71afc0a 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -485,7 +485,8 @@
 ## scope : multipath & multipathd
 ## desc  : list of per storage controller settings
 ##	  overrides default settings (device_maps block)
-##         overriden by per multipath settings (multipaths block)
+##        overriden by per multipath settings (multipaths block)
+##	  and the overrides settings (overrides block)
 ##
 #devices {
 #	#
@@ -651,3 +652,18 @@
 #		rr_weight		priorities
 #	}
 #}
+#
+##
+## name  : devices
+## scope : multipath & multipathd
+## desc  : list of settings to override all hadware settings for all devices
+##	  overrides default settings (device_maps block)
+##	  and per device type settings (devices block)
+##        overriden by per multipath settings (multipaths block)
+##
+#	attributes and values are identical to the device block
+#
+#overrides {
+#	dev_loss_tmo		60
+#	no_path_retry		fail
+#}
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 654be97..1c65e02 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -912,3 +912,5 @@
 #}
 #multipaths {
 #}
+#overrides {
+#}
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index bda1b75..f7b9b8a 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -72,3 +72,6 @@
 #		path_grouping_policy	multibus
 #	}
 #}
+#overrides {
+#	no_path_retry			fail
+#}
diff --git a/multipath/main.c b/multipath/main.c
index fd6262f..ea453b4 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -405,6 +405,12 @@ dump_config (void)
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
+		c += snprint_overrides(c, reply + maxlen - c, conf->overrides);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
 		c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
 		again = ((c - reply) == maxlen);
 		if (again)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index cadb34d..b823990 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -61,6 +61,10 @@ the udev attribute given by the
 .TP
 .B devices
 This section defines the device-specific settings.
+.TP
+.B overrides
+This section defines values for attributes that should override the
+device-specific settings for all devices.
 .RE
 .LP
 .SH "defaults section"
@@ -629,6 +633,59 @@ section:
 .RE
 .PD
 .LP
+.SH "overrides section"
+The overrides section recognizes the following optional attributes; if not set
+the values are taken from the
+.I devices
+or
+.I defaults
+sections:
+.sp 1
+.PD .1v
+.RS
+.TP 18
+.B path_grouping_policy
+.TP
+.B uid_attribute
+.TP
+.B getuid_callout
+.TP
+.B path_selector
+.TP
+.B path_checker
+.TP
+.B alias_prefix
+.TP
+.B features
+.TP
+.B prio
+.TP
+.B prio_args
+.TP
+.B failback
+.TP
+.B rr_weight
+.TP
+.B no_path_retry
+.TP
+.B rr_min_io
+.TP
+.B rr_min_io_rq
+.TP
+.B flush_on_last_del
+.TP
+.B fast_io_fail_tmo
+.TP
+.B dev_loss_tmo
+.TP
+.B user_friendly_names
+.TP
+.B retain_attached_hw_handler
+.TP
+.B detect_prio
+.RE
+.PD
+.LP
 .SH "KNOWN ISSUES"
 The usage of
 .B queue_if_no_path
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b086340..0ce1408 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -190,6 +190,16 @@ show_config (char ** r, int * len)
 			maxlen *= 2;
 			continue;
 		}
+		c += snprint_overrides(c, reply + maxlen - c, conf->overrides);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen * 2);
+			if (!reply)
+				return 1;
+			memset(reply + maxlen, 0, maxlen);
+			maxlen *= 2;
+			continue;
+		}
 		c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
-- 
1.8.3.1
