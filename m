From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/3] libmultipath: cleanup propsel.c with macros
	for common actions
Date: Wed,  1 Oct 2014 19:55:58 -0500
Message-ID: <1412211359-24766-3-git-send-email-bmarzins@redhat.com>
References: <1412211359-24766-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412211359-24766-1-git-send-email-bmarzins@redhat.com>
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
Cc: Nir Soffer <nsoffer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Many of the functions in propsel.c are nearly identical, except for the
names of the variables that they are dealing with.  Also, some variables
that the user configured with a keyword were just printing the variable
as an integer, which isn't very helpful without looking at the code to
see what the number stands for. They were using the variable names
instead of the config file names as well.  This patch tries to simplify
the file by using macros for the repetitive work of the functions, and
standardizes and clarifies the debug messages by using the print functions
from dict.c

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c       |  14 +-
 libmultipath/dict.h       |   7 +
 libmultipath/pgpolicies.c |   2 +-
 libmultipath/propsel.c    | 712 +++++++++++++++++-----------------------------
 4 files changed, 282 insertions(+), 453 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e88c122..98cbe48 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -496,7 +496,7 @@ set_fast_io_fail(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_fast_io_fail(char * buff, int len, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
@@ -534,7 +534,7 @@ set_dev_loss(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_dev_loss(char * buff, int len, void *ptr)
 {
 	unsigned int *uint_ptr = (unsigned int *)ptr;
@@ -567,7 +567,7 @@ set_pgpolicy(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_pgpolicy(char * buff, int len, void *ptr)
 {
 	char str[POLICY_NAME_SIZE];
@@ -683,7 +683,7 @@ set_rr_weight(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_rr_weight (char * buff, int len, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
@@ -727,7 +727,7 @@ set_pgfailback(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_pgfailback (char * buff, int len, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
@@ -774,7 +774,7 @@ set_no_path_retry(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_no_path_retry(char * buff, int len, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
@@ -873,7 +873,7 @@ set_reservation_key(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
+int
 print_reservation_key(char * buff, int len, void * ptr)
 {
 	unsigned char **uchar_ptr = (unsigned char **)ptr;
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 688eab7..84b6180 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -7,5 +7,12 @@
 
 void init_keywords(void);
 int get_sys_max_fds(int *);
+int print_rr_weight (char * buff, int len, void *ptr);
+int print_pgfailback (char * buff, int len, void *ptr);
+int print_pgpolicy(char * buff, int len, void *ptr);
+int print_no_path_retry(char * buff, int len, void *ptr);
+int print_fast_io_fail(char * buff, int len, void *ptr);
+int print_dev_loss(char * buff, int len, void *ptr);
+int print_reservation_key(char * buff, int len, void * ptr);
 
 #endif /* _DICT_H */
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index f76ad60..2981d51 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -27,7 +27,7 @@ get_pgpolicy_id (char * str)
 	if (0 == strncmp(str, "group_by_node_name", 18))
 		return GROUP_BY_NODE_NAME;
 
-	return -1;
+	return IOPOLICY_UNDEF;
 }
 
 extern int
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 7a966bb..f2ab7d2 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -17,6 +17,7 @@
 #include "devmapper.h"
 #include "prio.h"
 #include "discovery.h"
+#include "dict.h"
 #include "prioritizers/alua_rtpg.h"
 #include <inttypes.h>
 
@@ -29,57 +30,92 @@ pgpolicyfn *pgpolicies[] = {
 	group_by_node_name
 };
 
+#define do_set(var, src, dest, msg)					\
+do {									\
+	if (src && src->var) {						\
+		dest = src->var;					\
+		origin = msg;						\
+		goto out;						\
+	}								\
+} while(0)
+#define do_default(dest, value)						\
+do {									\
+	dest = value;							\
+	origin = "(internal default)";					\
+} while(0)
+
+#define mp_set_mpe(var)							\
+do_set(var, mp->mpe, mp->var, "(LUN setting)")
+#define mp_set_hwe(var)							\
+do_set(var, mp->hwe, mp->var, "(controller setting)")
+#define mp_set_conf(var)						\
+do_set(var, conf, mp->var, "(config file default)")
+#define mp_set_default(var, value)					\
+do_default(mp->var, value)
+
+#define pp_set_mpe(var)							\
+do_set(var, mpe, pp->var, "(LUN setting)")
+#define pp_set_hwe(var)							\
+do_set(var, pp->hwe, pp->var, "(controller setting)")
+#define pp_set_conf(var)						\
+do_set(var, conf, pp->var, "(config file default)")
+#define pp_set_default(var, value)					\
+do_default(pp->var, value)
+
+#define do_attr_set(var, src, shift, msg)				\
+do {									\
+	if (src && (src->attribute_flags & (1 << shift))) {		\
+		mp->attribute_flags |= (1 << shift);			\
+		mp->var = src->var;					\
+		origin = msg;						\
+		goto out;						\
+	}								\
+} while(0)
+
+#define set_attr_mpe(var, shift)					\
+do_attr_set(var, mp->mpe, shift, "(LUN setting)")
+#define set_attr_conf(var, shift)					\
+do_attr_set(var, conf, shift, "(config file default)")
+
 extern int
 select_mode (struct multipath *mp)
 {
-	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_MODE))) {
-		mp->attribute_flags |= (1 << ATTR_MODE);
-		mp->mode = mp->mpe->mode;
-		condlog(3, "mode = 0%o (LUN setting)", mp->mode);
-	}
-	else if (conf->attribute_flags & (1 << ATTR_MODE)) {
-		mp->attribute_flags |= (1 << ATTR_MODE);
-		mp->mode = conf->mode;
-		condlog(3, "mode = 0%o (config file default)", mp->mode);
-	}
-	else
-		mp->attribute_flags &= ~(1 << ATTR_MODE);
+	char *origin;
+
+	set_attr_mpe(mode, ATTR_MODE);
+	set_attr_conf(mode, ATTR_MODE);
+	mp->attribute_flags &= ~(1 << ATTR_MODE);
+	return 0;
+out:
+	condlog(3, "%s: mode = 0%o %s", mp->alias, mp->mode, origin);
 	return 0;
 }
 
 extern int
 select_uid (struct multipath *mp)
 {
-	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_UID))) {
-		mp->attribute_flags |= (1 << ATTR_UID);
-		mp->uid = mp->mpe->uid;
-		condlog(3, "uid = %u (LUN setting)", mp->uid);
-	}
-	else if (conf->attribute_flags & (1 << ATTR_UID)) {
-		mp->attribute_flags |= (1 << ATTR_UID);
-		mp->uid = conf->uid;
-		condlog(3, "uid = %u (config file default)", mp->uid);
-	}
-	else
-		mp->attribute_flags &= ~(1 << ATTR_UID);
+	char *origin;
+
+	set_attr_mpe(uid, ATTR_UID);
+	set_attr_conf(uid, ATTR_UID);
+	mp->attribute_flags &= ~(1 << ATTR_UID);
+	return 0;
+out:
+	condlog(3, "%s: uid = 0%o %s", mp->alias, mp->uid, origin);
 	return 0;
 }
 
 extern int
 select_gid (struct multipath *mp)
 {
-	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_GID))) {
-		mp->attribute_flags |= (1 << ATTR_GID);
-		mp->gid = mp->mpe->gid;
-		condlog(3, "gid = %u (LUN setting)", mp->gid);
-	}
-	else if (conf->attribute_flags & (1 << ATTR_GID)) {
-		mp->attribute_flags |= (1 << ATTR_GID);
-		mp->gid = conf->gid;
-		condlog(3, "gid = %u (config file default)", mp->gid);
-	}
-	else
-		mp->attribute_flags &= ~(1 << ATTR_GID);
+	char *origin;
+
+	set_attr_mpe(gid, ATTR_GID);
+	set_attr_conf(gid, ATTR_GID);
+	mp->attribute_flags &= ~(1 << ATTR_GID);
+	return 0;
+out:
+	condlog(3, "%s: gid = 0%o %s", mp->alias, mp->gid, origin);
 	return 0;
 }
 
@@ -91,151 +127,80 @@ select_gid (struct multipath *mp)
 extern int
 select_rr_weight (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->rr_weight) {
-		mp->rr_weight = mp->mpe->rr_weight;
-		condlog(3, "%s: rr_weight = %i (LUN setting)",
-			mp->alias, mp->rr_weight);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->rr_weight) {
-		mp->rr_weight = mp->hwe->rr_weight;
-		condlog(3, "%s: rr_weight = %i (controller setting)",
-			mp->alias, mp->rr_weight);
-		return 0;
-	}
-	if (conf->rr_weight) {
-		mp->rr_weight = conf->rr_weight;
-		condlog(3, "%s: rr_weight = %i (config file default)",
-			mp->alias, mp->rr_weight);
-		return 0;
-	}
-	mp->rr_weight = RR_WEIGHT_NONE;
-	condlog(3, "%s: rr_weight = %i (internal default)",
-		mp->alias, mp->rr_weight);
+	char *origin, buff[13];
+
+	mp_set_mpe(rr_weight);
+	mp_set_hwe(rr_weight);
+	mp_set_conf(rr_weight);
+	mp_set_default(rr_weight, RR_WEIGHT_NONE);
+out:
+	print_rr_weight(buff, 13, &mp->rr_weight);
+	condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
 extern int
 select_pgfailback (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->pgfailback != FAILBACK_UNDEF) {
-		mp->pgfailback = mp->mpe->pgfailback;
-		condlog(3, "%s: pgfailback = %i (LUN setting)",
-			mp->alias, mp->pgfailback);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->pgfailback != FAILBACK_UNDEF) {
-		mp->pgfailback = mp->hwe->pgfailback;
-		condlog(3, "%s: pgfailback = %i (controller setting)",
-			mp->alias, mp->pgfailback);
-		return 0;
-	}
-	if (conf->pgfailback != FAILBACK_UNDEF) {
-		mp->pgfailback = conf->pgfailback;
-		condlog(3, "%s: pgfailback = %i (config file default)",
-			mp->alias, mp->pgfailback);
-		return 0;
-	}
-	mp->pgfailback = DEFAULT_FAILBACK;
-	condlog(3, "%s: pgfailover = %i (internal default)",
-		mp->alias, mp->pgfailback);
+	char *origin, buff[13];
+
+	mp_set_mpe(pgfailback);
+	mp_set_hwe(pgfailback);
+	mp_set_conf(pgfailback);
+	mp_set_default(pgfailback, DEFAULT_FAILBACK);
+out:
+	print_pgfailback(buff, 13, &mp->pgfailback);
+	condlog(3, "%s: failback = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
 extern int
 select_pgpolicy (struct multipath * mp)
 {
-	char pgpolicy_name[POLICY_NAME_SIZE];
+	char *origin, buff[POLICY_NAME_SIZE];
 
 	if (conf->pgpolicy_flag > 0) {
 		mp->pgpolicy = conf->pgpolicy_flag;
-		mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-		get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
-				  mp->pgpolicy);
-		condlog(3, "%s: pgpolicy = %s (cmd line flag)",
-			mp->alias, pgpolicy_name);
-		return 0;
-	}
-	if (mp->mpe && mp->mpe->pgpolicy > 0) {
-		mp->pgpolicy = mp->mpe->pgpolicy;
-		mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-		get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
-				  mp->pgpolicy);
-		condlog(3, "%s: pgpolicy = %s (LUN setting)",
-			mp->alias, pgpolicy_name);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->pgpolicy > 0) {
-		mp->pgpolicy = mp->hwe->pgpolicy;
-		mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-		get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
-				  mp->pgpolicy);
-		condlog(3, "%s: pgpolicy = %s (controller setting)",
-			mp->alias, pgpolicy_name);
-		return 0;
-	}
-	if (conf->pgpolicy > 0) {
-		mp->pgpolicy = conf->pgpolicy;
-		mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-		get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
-				  mp->pgpolicy);
-		condlog(3, "%s: pgpolicy = %s (config file default)",
-			mp->alias, pgpolicy_name);
-		return 0;
+		origin = "(cmd line flag)";
+		goto out;
 	}
-	mp->pgpolicy = DEFAULT_PGPOLICY;
+	mp_set_mpe(pgpolicy);
+	mp_set_hwe(pgpolicy);
+	mp_set_conf(pgpolicy);
+	mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
+out:
 	mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
-	get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE, mp->pgpolicy);
-	condlog(3, "%s: pgpolicy = %s (internal default)",
-		mp->alias, pgpolicy_name);
+	get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgpolicy);
+	condlog(3, "%s: path_grouping_policy = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
 extern int
 select_selector (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->selector) {
-		mp->selector = mp->mpe->selector;
-		condlog(3, "%s: selector = %s (LUN setting)",
-			mp->alias, mp->selector);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->selector) {
-		mp->selector = mp->hwe->selector;
-		condlog(3, "%s: selector = %s (controller setting)",
-			mp->alias, mp->selector);
-		return 0;
-	}
-	if (conf->selector) {
-		mp->selector = conf->selector;
-		condlog(3, "%s: selector = %s (config file default)",
-			mp->alias, mp->selector);
-		return 0;
-	}
-	mp->selector = set_default(DEFAULT_SELECTOR);
-	condlog(3, "%s: selector = %s (internal default)",
-		mp->alias, mp->selector);
+	char *origin;
+
+	mp_set_mpe(selector);
+	mp_set_hwe(selector);
+	mp_set_conf(selector);
+	mp_set_default(selector, set_default(DEFAULT_SELECTOR));
+out:
+	condlog(3, "%s: path_selector = \"%s\" %s", mp->alias, mp->selector,
+		origin);
 	return 0;
 }
 
 static void
 select_alias_prefix (struct multipath * mp)
 {
-	if (mp->hwe && mp->hwe->alias_prefix) {
-		mp->alias_prefix = mp->hwe->alias_prefix;
-		condlog(3, "%s: alias_prefix = %s (controller setting)",
-			mp->wwid, mp->alias_prefix);
-		return;
-	}
-	if (conf->alias_prefix) {
-		mp->alias_prefix = conf->alias_prefix;
-		condlog(3, "%s: alias_prefix = %s (config file default)",
-			mp->wwid, mp->alias_prefix);
-		return;
-	}
-	mp->alias_prefix = set_default(DEFAULT_ALIAS_PREFIX);
-	condlog(3, "%s: alias_prefix = %s (internal default)",
-		mp->wwid, mp->alias_prefix);
+	char *origin;
+
+	mp_set_hwe(alias_prefix);
+	mp_set_conf(alias_prefix);
+	mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
+out:
+	condlog(3, "%s: alias_prefix = %s %s", mp->wwid, mp->alias_prefix,
+		origin);
 }
 
 static int
@@ -253,8 +218,11 @@ want_user_friendly_names(struct multipath * mp)
 extern int
 select_alias (struct multipath * mp)
 {
+	char *origin;
+
 	if (mp->mpe && mp->mpe->alias) {
 		mp->alias = STRDUP(mp->mpe->alias);
+		origin = "(LUN setting)";
 		goto out;
 	}
 
@@ -269,39 +237,37 @@ select_alias (struct multipath * mp)
 				mp->alias_old, mp->alias_prefix,
 				conf->bindings_read_only);
 		memset (mp->alias_old, 0, WWID_SIZE);
+		origin = "(using existing alias)";
 	}
 
-	if (mp->alias == NULL)
+	if (mp->alias == NULL) {
 		mp->alias = get_user_friendly_alias(mp->wwid,
 				conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
+		origin = "(user_friendly_name)";
+	}
 out:
-	if (mp->alias == NULL)
+	if (mp->alias == NULL) {
 		mp->alias = STRDUP(mp->wwid);
-
+		origin = "(default to wwid)";
+	}
+	if (mp->alias)
+		condlog(3, "%s: alias = %s %s", mp->wwid, mp->alias, origin);
 	return mp->alias ? 0 : 1;
 }
 
 extern int
 select_features (struct multipath * mp)
 {
-	struct mpentry * mpe;
 	char *origin;
 
-	if ((mpe = find_mpe(mp->wwid)) && mpe->features) {
-		mp->features = STRDUP(mpe->features);
-		origin = "LUN setting";
-	} else if (mp->hwe && mp->hwe->features) {
-		mp->features = STRDUP(mp->hwe->features);
-		origin = "controller setting";
-	} else if (conf->features) {
-		mp->features = STRDUP(conf->features);
-		origin = "config file default";
-	} else {
-		mp->features = set_default(DEFAULT_FEATURES);
-		origin = "internal default";
-	}
-	condlog(3, "%s: features = %s (%s)",
-		mp->alias, mp->features, origin);
+	mp_set_mpe(features);
+	mp_set_hwe(features);
+	mp_set_conf(features);
+	mp_set_default(features, DEFAULT_FEATURES);
+out:
+	mp->features = STRDUP(mp->features);
+	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
+
 	if (strstr(mp->features, "queue_if_no_path")) {
 		if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
 			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
@@ -317,45 +283,29 @@ select_features (struct multipath * mp)
 extern int
 select_hwhandler (struct multipath * mp)
 {
-	if (mp->hwe && mp->hwe->hwhandler) {
-		mp->hwhandler = mp->hwe->hwhandler;
-		condlog(3, "%s: hwhandler = %s (controller setting)",
-			mp->alias, mp->hwhandler);
-		return 0;
-	}
-	if (conf->hwhandler) {
-		mp->hwhandler = conf->hwhandler;
-		condlog(3, "%s: hwhandler = %s (config file default)",
-			mp->alias, mp->hwhandler);
-		return 0;
-	}
-	mp->hwhandler = set_default(DEFAULT_HWHANDLER);
-	condlog(3, "%s: hwhandler = %s (internal default)",
-		mp->alias, mp->hwhandler);
+	char *origin;
+
+	mp_set_hwe(hwhandler);
+	mp_set_conf(hwhandler);
+	mp_set_default(hwhandler, set_default(DEFAULT_HWHANDLER));
+out:
+	condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias, mp->hwhandler,
+		origin);
 	return 0;
 }
 
 extern int
 select_checker(struct path *pp)
 {
+	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
-	if (pp->hwe && pp->hwe->checker_name) {
-		checker_get(c, pp->hwe->checker_name);
-		condlog(3, "%s: path checker = %s (controller setting)",
-			pp->dev, checker_name(c));
-		goto out;
-	}
-	if (conf->checker_name) {
-		checker_get(c, conf->checker_name);
-		condlog(3, "%s: path checker = %s (config file default)",
-			pp->dev, checker_name(c));
-		goto out;
-	}
-	checker_get(c, DEFAULT_CHECKER);
-	condlog(3, "%s: path checker = %s (internal default)",
-		pp->dev, checker_name(c));
+	do_set(checker_name, pp->hwe, checker_name, "(controller setting)");
+	do_set(checker_name, conf, checker_name, "(config file setting)");
+	do_default(checker_name, DEFAULT_CHECKER);
 out:
+	checker_get(c, checker_name);
+	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
 	if (conf->checker_timeout) {
 		c->timeout = conf->checker_timeout;
 		condlog(3, "%s: checker timeout = %u s (config file default)",
@@ -375,33 +325,20 @@ out:
 extern int
 select_getuid (struct path * pp)
 {
-	if (pp->hwe && pp->hwe->uid_attribute) {
-		pp->uid_attribute = pp->hwe->uid_attribute;
-		condlog(3, "%s: uid_attribute = %s (controller setting)",
-			pp->dev, pp->uid_attribute);
-		return 0;
-	}
-	if (pp->hwe && pp->hwe->getuid) {
-		pp->getuid = pp->hwe->getuid;
-		condlog(3, "%s: getuid = %s (deprecated) (controller setting)",
-			pp->dev, pp->getuid);
-		return 0;
-	}
-	if (conf->uid_attribute) {
-		pp->uid_attribute = conf->uid_attribute;
-		condlog(3, "%s: uid_attribute = %s (config file default)",
-			pp->dev, pp->uid_attribute);
-		return 0;
-	}
-	if (conf->getuid) {
-		pp->getuid = conf->getuid;
-		condlog(3, "%s: getuid = %s (deprecated) (config file default)",
-			pp->dev, pp->getuid);
-		return 0;
-	}
-	pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
-	condlog(3, "%s: uid_attribute = %s (internal default)",
-		pp->dev, pp->uid_attribute);
+	char *origin;
+
+	pp_set_hwe(uid_attribute);
+	pp_set_hwe(getuid);
+	pp_set_conf(uid_attribute);
+	pp_set_conf(getuid);
+	pp_set_default(uid_attribute, DEFAULT_UID_ATTRIBUTE);
+out:
+	if (pp->uid_attribute)
+		condlog(3, "%s: uid_attribute = %s %s", pp->dev,
+			pp->uid_attribute, origin);
+	else if (pp->getuid)
+		condlog(3, "%s: getuid = \"%s\" %s", pp->dev, pp->getuid,
+			origin);
 	return 0;
 }
 
@@ -421,140 +358,94 @@ detect_prio(struct path * pp)
 	prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
 
+#define set_prio(src, msg)						\
+do {									\
+	if (src && src->prio_name) {					\
+		prio_get(p, src->prio_name, src->prio_args);		\
+		origin = msg;						\
+		goto out;						\
+	}								\
+} while(0)
+
 extern int
 select_prio (struct path * pp)
 {
+	char *origin;
 	struct mpentry * mpe;
 	struct prio * p = &pp->prio;
 
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(pp);
 		if (prio_selected(p)) {
-			condlog(3, "%s: prio = %s (detected setting)",
-				pp->dev, prio_name(p));
-			return 0;
-		}
-	}
-
-	if ((mpe = find_mpe(pp->wwid))) {
-		if (mpe->prio_name) {
-			prio_get(p, mpe->prio_name, mpe->prio_args);
-			condlog(3, "%s: prio = %s (LUN setting)",
-				pp->dev, prio_name(p));
-			return 0;
+			origin = "(detected setting)";
+			goto out;
 		}
 	}
-
-	if (pp->hwe && pp->hwe->prio_name) {
-		prio_get(p, pp->hwe->prio_name, pp->hwe->prio_args);
-		condlog(3, "%s: prio = %s (controller setting)",
-			pp->dev, pp->hwe->prio_name);
-		condlog(3, "%s: prio args = %s (controller setting)",
-			pp->dev, pp->hwe->prio_args);
-		return 0;
-	}
-	if (conf->prio_name) {
-		prio_get(p, conf->prio_name, conf->prio_args);
-		condlog(3, "%s: prio = %s (config file default)",
-			pp->dev, conf->prio_name);
-		condlog(3, "%s: prio args = %s (config file default)",
-			pp->dev, conf->prio_args);
-		return 0;
-	}
+	mpe = find_mpe(pp->wwid);
+	set_prio(mpe, "(LUN setting)");
+	set_prio(pp->hwe, "controller setting)");
+	set_prio(conf, "(config file default)");
 	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
-	condlog(3, "%s: prio = %s (internal default)",
-		pp->dev, DEFAULT_PRIO);
-	condlog(3, "%s: prio args = %s (internal default)",
-		pp->dev, DEFAULT_PRIO_ARGS);
+	origin = "(internal default)";
+out:
+	condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
+	condlog(3, "%s: prio args = \"%s\" %s", pp->dev, prio_args(p), origin);
 	return 0;
 }
 
 extern int
 select_no_path_retry(struct multipath *mp)
 {
+	char *origin = NULL;
+	char buff[12];
+
 	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
 		condlog(0, "flush_on_last_del in progress");
 		mp->no_path_retry = NO_PATH_RETRY_FAIL;
 		return 0;
 	}
-	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		mp->no_path_retry = mp->mpe->no_path_retry;
-		condlog(3, "%s: no_path_retry = %i (multipath setting)",
-			mp->alias, mp->no_path_retry);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		mp->no_path_retry = mp->hwe->no_path_retry;
-		condlog(3, "%s: no_path_retry = %i (controller setting)",
-			mp->alias, mp->no_path_retry);
-		return 0;
-	}
-	if (conf->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		mp->no_path_retry = conf->no_path_retry;
-		condlog(3, "%s: no_path_retry = %i (config file default)",
-			mp->alias, mp->no_path_retry);
-		return 0;
-	}
-	if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
-		condlog(3, "%s: no_path_retry = %i (inherited setting)",
-			mp->alias, mp->no_path_retry);
+	mp_set_mpe(no_path_retry);
+	mp_set_hwe(no_path_retry);
+	mp_set_conf(no_path_retry);
+out:
+	print_no_path_retry(buff, 12, &mp->no_path_retry);
+	if (origin)
+		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
+			origin);
+	else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
+		condlog(3, "%s: no_path_retry = %s (inheritied setting)",
+			mp->alias, buff);
 	else
-		condlog(3, "%s: no_path_retry = %i (internal default)",
-			mp->alias, mp->no_path_retry);
+		condlog(3, "%s: no_path_retry = undef (internal default)",
+			mp->alias);
 	return 0;
 }
 
 int
 select_minio_rq (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->minio_rq) {
-		mp->minio = mp->mpe->minio_rq;
-		condlog(3, "%s: minio = %i rq (LUN setting)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->minio_rq) {
-		mp->minio = mp->hwe->minio_rq;
-		condlog(3, "%s: minio = %i rq (controller setting)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	if (conf->minio) {
-		mp->minio = conf->minio_rq;
-		condlog(3, "%s: minio = %i rq (config file default)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	mp->minio = DEFAULT_MINIO_RQ;
-	condlog(3, "%s: minio = %i rq (internal default)",
-		mp->alias, mp->minio);
+	char *origin;
+
+	do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
+	do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
+	do_set(minio_rq, conf, mp->minio, "(config file setting)");
+	do_default(mp->minio, DEFAULT_MINIO_RQ);
+out:
+	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
 	return 0;
 }
 
 int
 select_minio_bio (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->minio) {
-		mp->minio = mp->mpe->minio;
-		condlog(3, "%s: minio = %i (LUN setting)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->minio) {
-		mp->minio = mp->hwe->minio;
-		condlog(3, "%s: minio = %i (controller setting)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	if (conf->minio) {
-		mp->minio = conf->minio;
-		condlog(3, "%s: minio = %i (config file default)",
-			mp->alias, mp->minio);
-		return 0;
-	}
-	mp->minio = DEFAULT_MINIO;
-	condlog(3, "%s: minio = %i (internal default)",
-		mp->alias, mp->minio);
+	char *origin;
+
+	mp_set_mpe(minio);
+	mp_set_hwe(minio);
+	mp_set_conf(minio);
+	mp_set_default(minio, DEFAULT_MINIO);
+out:
+	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
 	return 0;
 }
 
@@ -572,164 +463,95 @@ select_minio (struct multipath * mp)
 extern int
 select_fast_io_fail(struct multipath *mp)
 {
-	if (mp->hwe && mp->hwe->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
-		mp->fast_io_fail = mp->hwe->fast_io_fail;
-		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-			condlog(3, "%s: fast_io_fail_tmo = off "
-				"(controller setting)", mp->alias);
-		else
-			condlog(3, "%s: fast_io_fail_tmo = %d "
-				"(controller setting)", mp->alias,
-				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
-		return 0;
-	}
-	if (conf->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
-		mp->fast_io_fail = conf->fast_io_fail;
-		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-			condlog(3, "%s: fast_io_fail_tmo = off "
-				"(config file default)", mp->alias);
-		else
-			condlog(3, "%s: fast_io_fail_tmo = %d "
-				"(config file default)", mp->alias,
-				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
-		return 0;
-	}
-	mp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
+	char *origin, buff[12];
+
+	mp_set_hwe(fast_io_fail);
+	mp_set_conf(fast_io_fail);
+	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
+out:
+	print_fast_io_fail(buff, 12, &mp->fast_io_fail);
+	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
 extern int
 select_dev_loss(struct multipath *mp)
 {
-	if (mp->hwe && mp->hwe->dev_loss) {
-		mp->dev_loss = mp->hwe->dev_loss;
-		condlog(3, "%s: dev_loss_tmo = %u (controller default)",
-			mp->alias, mp->dev_loss);
-		return 0;
-	}
-	if (conf->dev_loss) {
-		mp->dev_loss = conf->dev_loss;
-		condlog(3, "%s: dev_loss_tmo = %u (config file default)",
-			mp->alias, mp->dev_loss);
-		return 0;
-	}
+	char *origin, buff[12];
+
+	mp_set_hwe(dev_loss);
+	mp_set_conf(dev_loss);
 	mp->dev_loss = 0;
 	return 0;
+out:
+	print_dev_loss(buff, 12, &mp->dev_loss);
+	condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias, buff, origin);
+	return 0;
 }
 
 extern int
 select_flush_on_last_del(struct multipath *mp)
 {
+	char *origin;
+
 	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
 		return 0;
-	if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
-		mp->flush_on_last_del = mp->mpe->flush_on_last_del;
-		condlog(3, "%s: flush_on_last_del = %i (multipath setting)",
-			mp->alias, mp->flush_on_last_del);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
-		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
-		condlog(3, "%s: flush_on_last_del = %i (controller setting)",
-			mp->alias, mp->flush_on_last_del);
-		return 0;
-	}
-	if (conf->flush_on_last_del != FLUSH_UNDEF) {
-		mp->flush_on_last_del = conf->flush_on_last_del;
-		condlog(3, "%s: flush_on_last_del = %i (config file default)",
-			mp->alias, mp->flush_on_last_del);
-		return 0;
-	}
-	mp->flush_on_last_del = FLUSH_UNDEF;
-	condlog(3, "%s: flush_on_last_del = DISABLED (internal default)",
-		mp->alias);
+	mp_set_mpe(flush_on_last_del);
+	mp_set_hwe(flush_on_last_del);
+	mp_set_conf(flush_on_last_del);
+	mp_set_default(flush_on_last_del, FLUSH_DISABLED);
+out:
+	condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
+		(mp->flush_on_last_del == FLUSH_ENABLED)? "yes" : "no", origin);
 	return 0;
 }
 
 extern int
 select_reservation_key (struct multipath * mp)
 {
-	int j;
-	unsigned char *keyp;
-	uint64_t prkey = 0;
+	char *origin, buff[12];
 
+	mp_set_mpe(reservation_key);
+	mp_set_conf(reservation_key);
 	mp->reservation_key = NULL;
-
-	if (mp->mpe && mp->mpe->reservation_key) {
-		keyp =  mp->mpe->reservation_key;
-		for (j = 0; j < 8; ++j) {
-			if (j > 0)
-				prkey <<= 8;
-			prkey |= *keyp;
-			++keyp;
-		}
-
-		condlog(3, "%s: reservation_key = 0x%" PRIx64 " "
-				"(multipath setting)",  mp->alias, prkey);
-
-		mp->reservation_key = mp->mpe->reservation_key;
-		return 0;
-	}
-
-	if (conf->reservation_key) {
-		keyp = conf->reservation_key;
-		for (j = 0; j < 8; ++j) {
-			if (j > 0)
-				prkey <<= 8;
-			prkey |= *keyp;
-			++keyp;
-		}
-
-		condlog(3, "%s: reservation_key  = 0x%" PRIx64
-				" (config file default)", mp->alias, prkey);
-
-		mp->reservation_key = conf->reservation_key;
-		return 0;
-	}
-
+	return 0;
+out:
+	print_reservation_key(buff, 12, &mp->reservation_key);
+	condlog(3, "%s: reservation_key = %s %s", mp->alias, buff, origin);
 	return 0;
 }
 
 extern int
 select_retain_hwhandler (struct multipath * mp)
 {
+	char *origin;
 	unsigned int minv_dm_retain[3] = {1, 5, 0};
 
 	if (!VERSION_GE(conf->version, minv_dm_retain)) {
 		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-		condlog(3, "%s: retain_attached_hw_handler disabled (requires kernel version >= 1.5.0)", mp->alias);
-		return 0;
-	}
-
-	if (mp->hwe && mp->hwe->retain_hwhandler) {
-		mp->retain_hwhandler = mp->hwe->retain_hwhandler;
-		condlog(3, "%s: retain_attached_hw_handler = %d (controller default)", mp->alias, mp->retain_hwhandler);
-		return 0;
-	}
-	if (conf->retain_hwhandler) {
-		mp->retain_hwhandler = conf->retain_hwhandler;
-		condlog(3, "%s: retain_attached_hw_handler = %d (config file default)", mp->alias, mp->retain_hwhandler);
-		return 0;
+		origin = "(requires kernel version >= 1.5.0)";
+		goto out;
 	}
-	mp->retain_hwhandler = 0;
-	condlog(3, "%s: retain_attached_hw_handler = %d (compiled in default)", mp->alias, mp->retain_hwhandler);
+	mp_set_hwe(retain_hwhandler);
+	mp_set_conf(retain_hwhandler);
+	mp_set_default(retain_hwhandler, DEFAULT_RETAIN_HWHANDLER);
+out:
+	condlog(3, "%s: retain_attached_hw_handler = %s %s", mp->alias,
+		(mp->retain_hwhandler == RETAIN_HWHANDLER_ON)? "yes" : "no",
+		origin);
 	return 0;
 }
 
 extern int
 select_detect_prio (struct path * pp)
 {
-	if (pp->hwe && pp->hwe->detect_prio) {
-		pp->detect_prio = pp->hwe->detect_prio;
-		condlog(3, "%s: detect_prio = %d (controller default)", pp->dev, pp->detect_prio);
-		return 0;
-	}
-	if (conf->detect_prio) {
-		pp->detect_prio = conf->detect_prio;
-		condlog(3, "%s: detect_prio = %d (config file default)", pp->dev, pp->detect_prio);
-		return 0;
-	}
-	pp->detect_prio = 0;
-	condlog(3, "%s: detect_prio = %d (compiled in default)", pp->dev, pp->detect_prio);
+	char *origin;
+
+	pp_set_hwe(detect_prio);
+	pp_set_conf(detect_prio);
+	pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
+out:
+	condlog(3, "%s: detect_prio = %s %s", pp->dev,
+		(pp->detect_prio == DETECT_PRIO_ON)? "yes" : "no", origin);
 	return 0;
 }
-- 
1.8.3.1
