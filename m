From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/3] libmultipath: rewrite dict.c with function
	generation macros
Date: Wed,  1 Oct 2014 19:55:57 -0500
Message-ID: <1412211359-24766-2-git-send-email-bmarzins@redhat.com>
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

dict.c is full of nearly identical functions for setting and printing the
configuration. Many options use the exact same function with just the
variable name changing.  For options that exist in multiple sections of
multipath.conf, the functions for setting and printing the option are also
nearly identical, except for the config structure that is used.

In order to avoid this massive amount of code duplication, and also to
standardize and avoid copy/paste errors, I've written some standard
functions with the most common setting and printing code, and some macros
that take the setting and printing functions, and add the boilerplate code
that is necessary for the different sections. This means that there is
at most one unique function to set and print an option, regardless of
home many sections is appears in.  Options that just set a string or
integer don't even need their own function. They can use one of the generic
ones.

There's one trade-off that I'm not sure I chose the right way on. In
order to keep the number of macros down, I made them transfer the
data using void pointers. This means that the macro works regardless
of whether the data is a signed or unsigned int or a string or whatever.
The downside to this is that there isn't type checking.  This means that
if, for instance, someone called a function that expected a string, but
passed in an integer. The complier wouldn't catch the error.

declare_def_snprint(verbosity, print_str)

as an example, would happily treat &conf->verbosity as a string pointer.
I'm not sure how worried people are about this, but it wouldn't be too
hard to add a bunch more declare_* macros so that each was typed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c   |    5 +-
 libmultipath/defaults.h |    2 -
 libmultipath/dict.c     | 3097 +++++++++++------------------------------------
 libmultipath/structs.h  |   44 +-
 4 files changed, 719 insertions(+), 2429 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 39963b4..bfd8ee8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -556,7 +556,7 @@ load_config (char * file, struct udev *udev)
 	conf->attribute_flags = 0;
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
 	conf->checkint = DEFAULT_CHECKINT;
-	conf->max_checkint = MAX_CHECKINT(conf->checkint);
+	conf->max_checkint = 0;
 	conf->pgfailback = DEFAULT_FAILBACK;
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
@@ -599,7 +599,8 @@ load_config (char * file, struct udev *udev)
 	} else {
 		init_keywords();
 	}
-
+	if (conf->max_checkint == 0)
+		conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	/*
 	 * fill the voids left in the config file
 	 */
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b83d9fb..99cf4b1 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -11,8 +11,6 @@
 #define DEFAULT_FAILBACK       -FAILBACK_MANUAL
 #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
-#define DEFAULT_PGTIMEOUT      -PGTIMEOUT_NONE
-#define DEFAULT_USER_FRIENDLY_NAMES    0
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
 #define DEFAULT_FAST_IO_FAIL	5
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7de7a67..e88c122 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -22,245 +22,572 @@
 #include "errno.h"
 #include <inttypes.h>
 
-/*
- * default block handlers
- */
 static int
-polling_interval_handler(vector strvec)
+set_int(vector strvec, void *ptr)
 {
+	int *int_ptr = (int *)ptr;
 	char * buff;
 
 	buff = VECTOR_SLOT(strvec, 1);
-	conf->checkint = atoi(buff);
-	conf->max_checkint = MAX_CHECKINT(conf->checkint);
+	*int_ptr = atoi(buff);
 
 	return 0;
 }
 
 static int
-def_fast_io_fail_handler(vector strvec)
+set_str(vector strvec, void *ptr)
 {
-	char * buff;
+	char **str_ptr = (char **)ptr;
+	*str_ptr = set_value(strvec);
 
-	buff = set_value(strvec);
-	if (!buff)
+	if (!*str_ptr)
 		return 1;
 
-	if (strlen(buff) == 3 && !strcmp(buff, "off"))
-		conf->fast_io_fail = MP_FAST_IO_FAIL_OFF;
-	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
-		 conf->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
-		conf->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
-	else if (conf->fast_io_fail == 0)
-		conf->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
-
-	FREE(buff);
 	return 0;
 }
 
 static int
-def_dev_loss_handler(vector strvec)
+set_yes_no(vector strvec, void *ptr)
 {
 	char * buff;
+	int *int_ptr = (int *)ptr;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 8 && !strcmp(buff, "infinity"))
-		conf->dev_loss = MAX_DEV_LOSS_TMO;
-	else if (sscanf(buff, "%u", &conf->dev_loss) != 1)
-		conf->dev_loss = 0;
+	if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+		*int_ptr = YN_YES;
+	else
+		*int_ptr = YN_NO;
 
 	FREE(buff);
 	return 0;
 }
 
 static int
-verbosity_handler(vector strvec)
+set_yes_no_undef(vector strvec, void *ptr)
 {
 	char * buff;
+	int *int_ptr = (int *)ptr;
 
-	buff = VECTOR_SLOT(strvec, 1);
-	conf->verbosity = atoi(buff);
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
 
+	if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
+		*int_ptr = YNU_NO;
+	else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+		*int_ptr = YNU_YES;
+	else
+		*int_ptr = YNU_UNDEF;
+
+	FREE(buff);
 	return 0;
 }
 
 static int
-max_polling_interval_handler(vector strvec)
+print_int (char *buff, int len, void *ptr)
 {
-	char *buff;
-
-	buff = VECTOR_SLOT(strvec, 1);
-	conf->max_checkint = atoi(buff);
+	int *int_ptr = (int *)ptr;
+	return snprintf(buff, len, "%i", *int_ptr);
+}
 
-	return 0;
+static int
+print_nonzero (char *buff, int len, void *ptr)
+{
+	int *int_ptr = (int *)ptr;
+	if (!*int_ptr)
+		return 0;
+	return snprintf(buff, len, "%i", *int_ptr);
 }
 
 static int
-reassign_maps_handler(vector strvec)
+print_str (char *buff, int len, void *ptr)
 {
-	char * buff;
+	char **str_ptr = (char **)ptr;
+	if (!*str_ptr)
+		return 0;
+	return snprintf(buff, len, "\"%s\"", *str_ptr);
+}
 
-	buff = set_value(strvec);
-	if (!strcmp(buff, "yes"))
-		conf->reassign_maps = 1;
-	else if (!strcmp(buff, "no"))
-		conf->reassign_maps = 0;
-	else
-		return 1;
+static int
+print_yes_no (char *buff, int len, void *ptr)
+{
+	int *int_ptr = (int *)ptr;
+	return snprintf(buff, len, "\"%s\"",
+			(*int_ptr == YN_NO)? "no" : "yes");
+}
 
-	return 0;
+static int
+print_yes_no_undef (char *buff, int len, void *ptr)
+{
+	int *int_ptr = (int *)ptr;
+	if (!*int_ptr)
+		return 0;
+	return snprintf(buff, len, "\"%s\"",
+			(*int_ptr == YNU_NO)? "no" : "yes");
 }
 
+#define declare_def_handler(option, function)				\
+static int								\
+def_ ## option ## _handler (vector strvec)				\
+{									\
+	return function (strvec, &conf->option);			\
+}
+
+#define declare_def_snprint(option, function)				\
+static int								\
+snprint_def_ ## option (char * buff, int len, void * data)		\
+{									\
+	return function (buff, len, &conf->option);			\
+}
+
+#define declare_def_snprint_defint(option, function, value)		\
+static int								\
+snprint_def_ ## option (char * buff, int len, void * data)		\
+{									\
+	int i = value;							\
+	if (!conf->option)						\
+		return function (buff, len, &i);			\
+	return function (buff, len, &conf->option);			\
+}
+
+#define declare_def_snprint_defstr(option, function, value)		\
+static int								\
+snprint_def_ ## option (char * buff, int len, void * data)		\
+{									\
+	char *s = value;						\
+	if (!conf->option)						\
+		return function (buff, len, &s);			\
+	return function (buff, len, &conf->option);			\
+}
+
+#define declare_hw_handler(option, function)				\
+static int								\
+hw_ ## option ## _handler (vector strvec)				\
+{									\
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
+	if (!hwe)							\
+		return 1;						\
+	return function (strvec, &hwe->option);				\
+}
+
+#define declare_hw_snprint(option, function)				\
+static int								\
+snprint_hw_ ## option (char * buff, int len, void * data)		\
+{									\
+	struct hwentry * hwe = (struct hwentry *)data;			\
+	return function (buff, len, &hwe->option);			\
+}
+
+#define declare_mp_handler(option, function)				\
+static int								\
+mp_ ## option ## _handler (vector strvec)				\
+{									\
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
+	if (!mpe)							\
+		return 1;						\
+	return function (strvec, &mpe->option);				\
+}
+
+#define declare_mp_snprint(option, function)				\
+static int								\
+snprint_mp_ ## option (char * buff, int len, void * data)		\
+{									\
+	struct mpentry * mpe = (struct mpentry *)data;			\
+	return function (buff, len, &mpe->option);			\
+}
+
+declare_def_handler(checkint, set_int)
+declare_def_snprint(checkint, print_int)
+
+declare_def_handler(max_checkint, set_int)
+declare_def_snprint(max_checkint, print_int)
+
+declare_def_handler(verbosity, set_int)
+declare_def_snprint(verbosity, print_int)
+
+declare_def_handler(reassign_maps, set_yes_no)
+declare_def_snprint(reassign_maps, print_yes_no)
+
+declare_def_handler(multipath_dir, set_str)
+declare_def_snprint(multipath_dir, print_str)
+
+declare_def_handler(selector, set_str)
+declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
+declare_hw_handler(selector, set_str)
+declare_hw_snprint(selector, print_str)
+declare_mp_handler(selector, set_str)
+declare_mp_snprint(selector, print_str)
+
+declare_def_handler(uid_attribute, set_str)
+declare_def_snprint_defstr(uid_attribute, print_str, DEFAULT_UID_ATTRIBUTE)
+declare_hw_handler(uid_attribute, set_str)
+declare_hw_snprint(uid_attribute, print_str)
+
+declare_def_handler(getuid, set_str)
+declare_def_snprint(getuid, print_str)
+declare_hw_handler(getuid, set_str)
+declare_hw_snprint(getuid, print_str)
+
+declare_def_handler(prio_name, set_str)
+declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
+declare_hw_handler(prio_name, set_str)
+declare_hw_snprint(prio_name, print_str)
+declare_mp_handler(prio_name, set_str)
+declare_mp_snprint(prio_name, print_str)
+
+declare_def_handler(alias_prefix, set_str)
+declare_def_snprint_defstr(alias_prefix, print_str, DEFAULT_ALIAS_PREFIX)
+declare_hw_handler(alias_prefix, set_str)
+declare_hw_snprint(alias_prefix, print_str)
+
+declare_def_handler(prio_args, set_str)
+declare_def_snprint_defstr(prio_args, print_str, DEFAULT_PRIO_ARGS)
+declare_hw_handler(prio_args, set_str)
+declare_hw_snprint(prio_args, print_str)
+declare_mp_handler(prio_args, set_str)
+declare_mp_snprint(prio_args, print_str)
+
+declare_def_handler(features, set_str)
+declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
+declare_hw_handler(features, set_str)
+declare_hw_snprint(features, print_str)
+declare_mp_handler(features, set_str)
+declare_mp_snprint(features, print_str)
+
+declare_def_handler(checker_name, set_str)
+declare_def_snprint_defstr(checker_name, print_str, DEFAULT_CHECKER)
+declare_hw_handler(checker_name, set_str)
+declare_hw_snprint(checker_name, print_str)
+
+declare_def_handler(minio, set_int)
+declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
+declare_hw_handler(minio, set_int)
+declare_hw_snprint(minio, print_nonzero)
+declare_mp_handler(minio, set_int)
+declare_mp_snprint(minio, print_nonzero)
+
+declare_def_handler(minio_rq, set_int)
+declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
+declare_hw_handler(minio_rq, set_int)
+declare_hw_snprint(minio_rq, print_nonzero)
+declare_mp_handler(minio_rq, set_int)
+declare_mp_snprint(minio_rq, print_nonzero)
+
+declare_def_handler(queue_without_daemon, set_yes_no)
 static int
-multipath_dir_handler(vector strvec)
+snprint_def_queue_without_daemon (char * buff, int len, void * data)
 {
-	conf->multipath_dir = set_value(strvec);
+	switch (conf->queue_without_daemon) {
+	case QUE_NO_DAEMON_OFF:
+		return snprintf(buff, len, "\"no\"");
+	case QUE_NO_DAEMON_ON:
+		return snprintf(buff, len, "\"yes\"");
+	case QUE_NO_DAEMON_FORCE:
+		return snprintf(buff, len, "\"forced\"");
+	}
+	return 0;
+}
 
-	if (!conf->multipath_dir)
-		return 1;
+declare_def_handler(checker_timeout, set_int)
+declare_def_snprint(checker_timeout, print_nonzero)
 
-	return 0;
+declare_def_handler(flush_on_last_del, set_yes_no_undef)
+declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, YNU_NO)
+declare_hw_handler(flush_on_last_del, set_yes_no_undef)
+declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
+declare_mp_handler(flush_on_last_del, set_yes_no_undef)
+declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
+
+declare_def_handler(user_friendly_names, set_yes_no_undef)
+declare_def_snprint_defint(user_friendly_names, print_yes_no_undef, YNU_NO)
+declare_hw_handler(user_friendly_names, set_yes_no_undef)
+declare_hw_snprint(user_friendly_names, print_yes_no_undef)
+declare_mp_handler(user_friendly_names, set_yes_no_undef)
+declare_mp_snprint(user_friendly_names, print_yes_no_undef)
+
+declare_def_handler(bindings_file, set_str)
+declare_def_snprint(bindings_file, print_str)
+
+declare_def_handler(wwids_file, set_str)
+declare_def_snprint(wwids_file, print_str)
+
+declare_def_handler(retain_hwhandler, set_yes_no_undef)
+declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_NO)
+declare_hw_handler(retain_hwhandler, set_yes_no_undef)
+declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
+
+declare_def_handler(detect_prio, set_yes_no_undef)
+declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)
+declare_hw_handler(detect_prio, set_yes_no_undef)
+declare_hw_snprint(detect_prio, print_yes_no_undef)
+
+declare_def_handler(force_sync, set_yes_no)
+declare_def_snprint(force_sync, print_yes_no)
+
+#define declare_def_attr_handler(option, function)			\
+static int								\
+def_ ## option ## _handler (vector strvec)				\
+{									\
+	return function (strvec, &conf->option, &conf->attribute_flags);\
 }
 
-static int
-def_selector_handler(vector strvec)
-{
-	conf->selector = set_value(strvec);
+#define declare_def_attr_snprint(option, function)			\
+static int								\
+snprint_def_ ## option (char * buff, int len, void * data)		\
+{									\
+	return function (buff, len, &conf->option,			\
+			 &conf->attribute_flags);			\
+}
 
-	if (!conf->selector)
-		return 1;
+#define declare_mp_attr_handler(option, function)			\
+static int								\
+mp_ ## option ## _handler (vector strvec)				\
+{									\
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
+	if (!mpe)							\
+		return 1;						\
+	return function (strvec, &mpe->option, &mpe->attribute_flags);	\
+}
 
-	return 0;
+#define declare_mp_attr_snprint(option, function)			\
+static int								\
+snprint_mp_ ## option (char * buff, int len, void * data)		\
+{									\
+	struct mpentry * mpe = (struct mpentry *)data;			\
+	return function (buff, len, &mpe->option,			\
+			 &mpe->attribute_flags);			\
 }
 
 static int
-def_pgpolicy_handler(vector strvec)
+set_mode(vector strvec, void *ptr, int *flags)
 {
-	char * buff;
+	mode_t mode;
+	mode_t *mode_ptr = (mode_t *)ptr;
+	char *buff;
 
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
 
-	conf->pgpolicy = get_pgpolicy_id(buff);
-	FREE(buff);
+	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
+		*flags |= (1 << ATTR_MODE);
+		*mode_ptr = mode;
+	}
 
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_uid_attribute_handler(vector strvec)
+set_uid(vector strvec, void *ptr, int *flags)
 {
-	conf->uid_attribute = set_value(strvec);
+	uid_t uid;
+	uid_t *uid_ptr = (uid_t *)ptr;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
 
-	if (!conf->uid_attribute)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		*flags |= (1 << ATTR_UID);
+		*uid_ptr = info.pw_uid;
+	}
+	else if (sscanf(buff, "%u", &uid) == 1){
+		*flags |= (1 << ATTR_UID);
+		*uid_ptr = uid;
+	}
 
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_getuid_callout_handler(vector strvec)
+set_gid(vector strvec, void *ptr, int *flags)
 {
-	conf->getuid = set_value(strvec);
+	gid_t gid;
+	gid_t *gid_ptr = (gid_t *)ptr;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
 
-	if (!conf->getuid)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
 
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		*flags |= (1 << ATTR_GID);
+		*gid_ptr = info.pw_gid;
+	}
+	else if (sscanf(buff, "%u", &gid) == 1){
+		*flags |= (1 << ATTR_GID);
+		*gid_ptr = gid;
+	}
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_prio_handler(vector strvec)
+print_mode(char * buff, int len, void *ptr, int *flags)
 {
-	conf->prio_name = set_value(strvec);
+	mode_t *mode_ptr = (mode_t *)ptr;
+	if ((*flags & (1 << ATTR_MODE)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", *mode_ptr);
+}
 
-	if (!conf->prio_name)
-		return 1;
+static int
+print_uid(char * buff, int len, void *ptr, int *flags)
+{
+	uid_t *uid_ptr = (uid_t *)ptr;
+	if ((*flags & (1 << ATTR_UID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", *uid_ptr);
+}
 
-	return 0;
+static int
+print_gid(char * buff, int len, void *ptr, int *flags)
+{
+	gid_t *gid_ptr = (gid_t *)ptr;
+	if ((*flags & (1 << ATTR_GID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", *gid_ptr);
 }
 
+declare_def_attr_handler(mode, set_mode)
+declare_def_attr_snprint(mode, print_mode)
+declare_mp_attr_handler(mode, set_mode)
+declare_mp_attr_snprint(mode, print_mode)
+
+declare_def_attr_handler(uid, set_uid)
+declare_def_attr_snprint(uid, print_uid)
+declare_mp_attr_handler(uid, set_uid)
+declare_mp_attr_snprint(uid, print_uid)
+
+declare_def_attr_handler(gid, set_gid)
+declare_def_attr_snprint(gid, print_gid)
+declare_mp_attr_handler(gid, set_gid)
+declare_mp_attr_snprint(gid, print_gid)
+
 static int
-def_alias_prefix_handler(vector strvec)
+set_fast_io_fail(vector strvec, void *ptr)
 {
-	conf->alias_prefix = set_value(strvec);
+	char * buff;
+	int *int_ptr = (int *)ptr;
 
-	if (!conf->alias_prefix)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
 
+	if (strcmp(buff, "off") == 0)
+		*int_ptr = MP_FAST_IO_FAIL_OFF;
+	else if (sscanf(buff, "%d", int_ptr) != 1 ||
+		 *int_ptr < MP_FAST_IO_FAIL_ZERO)
+		*int_ptr = MP_FAST_IO_FAIL_UNSET;
+	else if (*int_ptr == 0)
+		*int_ptr = MP_FAST_IO_FAIL_ZERO;
+
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_prio_args_handler(vector strvec)
+print_fast_io_fail(char * buff, int len, void *ptr)
 {
-	conf->prio_args = set_value(strvec);
+	int *int_ptr = (int *)ptr;
 
-	if (!conf->prio_args)
-		return 1;
-
-	return 0;
+	if (*int_ptr == MP_FAST_IO_FAIL_UNSET)
+		return 0;
+	if (*int_ptr == MP_FAST_IO_FAIL_OFF)
+		return snprintf(buff, len, "\"off\"");
+	if (*int_ptr == MP_FAST_IO_FAIL_ZERO)
+		return snprintf(buff, len, "0");
+	return snprintf(buff, len, "%d", *int_ptr);
 }
 
+declare_def_handler(fast_io_fail, set_fast_io_fail)
+declare_def_snprint(fast_io_fail, print_fast_io_fail)
+declare_hw_handler(fast_io_fail, set_fast_io_fail)
+declare_hw_snprint(fast_io_fail, print_fast_io_fail)
+
 static int
-def_features_handler(vector strvec)
+set_dev_loss(vector strvec, void *ptr)
 {
-	conf->features = set_value(strvec);
+	char * buff;
+	unsigned int *uint_ptr = (unsigned int *)ptr;
 
-	if (!conf->features)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
 
+	if (!strcmp(buff, "infinity"))
+		*uint_ptr = MAX_DEV_LOSS_TMO;
+	else if (sscanf(buff, "%u", uint_ptr) != 1)
+		*uint_ptr = 0;
+
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_path_checker_handler(vector strvec)
+print_dev_loss(char * buff, int len, void *ptr)
 {
-	conf->checker_name = set_value(strvec);
+	unsigned int *uint_ptr = (unsigned int *)ptr;
 
-	if (!conf->checker_name)
-		return 1;
-
-	return 0;
+	if (!*uint_ptr)
+		return 0;
+	if (*uint_ptr >= MAX_DEV_LOSS_TMO)
+		return snprintf(buff, len, "\"infinity\"");
+	return snprintf(buff, len, "%u", *uint_ptr);
 }
 
+declare_def_handler(dev_loss, set_dev_loss)
+declare_def_snprint(dev_loss, print_dev_loss)
+declare_hw_handler(dev_loss, set_dev_loss)
+declare_hw_snprint(dev_loss, print_dev_loss)
+
 static int
-def_minio_handler(vector strvec)
+set_pgpolicy(vector strvec, void *ptr)
 {
 	char * buff;
+	int *int_ptr = (int *)ptr;
 
 	buff = set_value(strvec);
-
 	if (!buff)
 		return 1;
 
-	conf->minio = atoi(buff);
+	*int_ptr = get_pgpolicy_id(buff);
 	FREE(buff);
 
 	return 0;
 }
 
 static int
-def_minio_rq_handler(vector strvec)
+print_pgpolicy(char * buff, int len, void *ptr)
 {
-	char * buff;
-
-	buff = set_value(strvec);
+	char str[POLICY_NAME_SIZE];
+	int pgpolicy = *(int *)ptr;
 
-	if (!buff)
-		return 1;
+	if (!pgpolicy)
+		return 0;
 
-	conf->minio_rq = atoi(buff);
-	FREE(buff);
+	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
 
-	return 0;
+	return snprintf(buff, len, "\"%s\"", str);
 }
 
+declare_def_handler(pgpolicy, set_pgpolicy)
+declare_def_snprint_defint(pgpolicy, print_pgpolicy, DEFAULT_PGPOLICY)
+declare_hw_handler(pgpolicy, set_pgpolicy)
+declare_hw_snprint(pgpolicy, print_pgpolicy)
+declare_mp_handler(pgpolicy, set_pgpolicy)
+declare_mp_snprint(pgpolicy, print_pgpolicy)
+
 int
 get_sys_max_fds(int *max_fds)
 {
@@ -320,111 +647,80 @@ max_fds_handler(vector strvec)
 }
 
 static int
-def_mode_handler(vector strvec)
+snprint_max_fds (char * buff, int len, void * data)
 {
-	mode_t mode;
-	char *buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
+	int r = 0, max_fds;
 
-	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
-		conf->attribute_flags |= (1 << ATTR_MODE);
-		conf->mode = mode;
-	}
+	if (!conf->max_fds)
+		return 0;
 
-	FREE(buff);
-	return 0;
+	r = get_sys_max_fds(&max_fds);
+	if (!r && conf->max_fds >= max_fds)
+		return snprintf(buff, len, "\"max\"");
+	else
+		return snprintf(buff, len, "%d", conf->max_fds);
 }
 
 static int
-def_uid_handler(vector strvec)
+set_rr_weight(vector strvec, void *ptr)
 {
-	uid_t uid;
-	char *buff;
-	char passwd_buf[1024];
-	struct passwd info, *found;
+	int *int_ptr = (int *)ptr;
+	char * buff;
 
 	buff = set_value(strvec);
+
 	if (!buff)
 		return 1;
-	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
-		conf->attribute_flags |= (1 << ATTR_UID);
-		conf->uid = info.pw_uid;
-	}
-	else if (sscanf(buff, "%u", &uid) == 1){
-		conf->attribute_flags |= (1 << ATTR_UID);
-		conf->uid = uid;
-	}
-
-	FREE(buff);
-	return 0;
-}
 
-static int
-def_gid_handler(vector strvec)
-{
-	gid_t gid;
-	char *buff;
-	char passwd_buf[1024];
-	struct passwd info, *found;
+	if (!strcmp(buff, "priorities"))
+		*int_ptr = RR_WEIGHT_PRIO;
 
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
+	if (!strcmp(buff, "uniform"))
+		*int_ptr = RR_WEIGHT_NONE;
 
-	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
-		conf->attribute_flags |= (1 << ATTR_GID);
-		conf->gid = info.pw_gid;
-	}
-	else if (sscanf(buff, "%u", &gid) == 1){
-		conf->attribute_flags |= (1 << ATTR_GID);
-		conf->gid = gid;
-	}
 	FREE(buff);
+
 	return 0;
 }
 
 static int
-def_weight_handler(vector strvec)
+print_rr_weight (char * buff, int len, void *ptr)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if (strlen(buff) == 10 &&
-	    !strcmp(buff, "priorities"))
-		conf->rr_weight = RR_WEIGHT_PRIO;
-
-	if (strlen(buff) == strlen("uniform") &&
-	    !strcmp(buff, "uniform"))
-		conf->rr_weight = RR_WEIGHT_NONE;
+	int *int_ptr = (int *)ptr;
 
-	FREE(buff);
+	if (!*int_ptr)
+		return 0;
+	if (*int_ptr == RR_WEIGHT_PRIO)
+		return snprintf(buff, len, "\"priorities\"");
+	if (*int_ptr == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "\"uniform\"");
 
 	return 0;
 }
 
+declare_def_handler(rr_weight, set_rr_weight)
+declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE)
+declare_hw_handler(rr_weight, set_rr_weight)
+declare_hw_snprint(rr_weight, print_rr_weight)
+declare_mp_handler(rr_weight, set_rr_weight)
+declare_mp_snprint(rr_weight, print_rr_weight)
+
 static int
-default_failback_handler(vector strvec)
+set_pgfailback(vector strvec, void *ptr)
 {
+	int *int_ptr = (int *)ptr;
 	char * buff;
 
 	buff = set_value(strvec);
 
 	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
-		conf->pgfailback = -FAILBACK_MANUAL;
+		*int_ptr = -FAILBACK_MANUAL;
 	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
-		conf->pgfailback = -FAILBACK_IMMEDIATE;
+		*int_ptr = -FAILBACK_IMMEDIATE;
 	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
-		conf->pgfailback = -FAILBACK_FOLLOWOVER;
+		*int_ptr = -FAILBACK_FOLLOWOVER;
 	else
-		conf->pgfailback = atoi(buff);
+		*int_ptr = atoi(buff);
 
 	FREE(buff);
 
@@ -432,66 +728,78 @@ default_failback_handler(vector strvec)
 }
 
 static int
-def_no_path_retry_handler(vector strvec)
+print_pgfailback (char * buff, int len, void *ptr)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
+	int *int_ptr = (int *)ptr;
 
-	if ((strlen(buff) == 4 && !strcmp(buff, "fail")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->no_path_retry = NO_PATH_RETRY_FAIL;
-	else if (strlen(buff) == 5 && !strcmp(buff, "queue"))
-		conf->no_path_retry = NO_PATH_RETRY_QUEUE;
-	else if ((conf->no_path_retry = atoi(buff)) < 1)
-		conf->no_path_retry = NO_PATH_RETRY_UNDEF;
-
-	FREE(buff);
-	return 0;
+	switch(*int_ptr) {
+	case  FAILBACK_UNDEF:
+		return 0;
+	case -FAILBACK_MANUAL:
+		return snprintf(buff, len, "\"manual\"");
+	case -FAILBACK_IMMEDIATE:
+		return snprintf(buff, len, "\"immediate\"");
+	case -FAILBACK_FOLLOWOVER:
+		return snprintf(buff, len, "\"followover\"");
+	default:
+		return snprintf(buff, len, "%i", *int_ptr);
+	}
 }
 
+declare_def_handler(pgfailback, set_pgfailback)
+declare_def_snprint_defint(pgfailback, print_pgfailback, DEFAULT_FAILBACK)
+declare_hw_handler(pgfailback, set_pgfailback)
+declare_hw_snprint(pgfailback, print_pgfailback)
+declare_mp_handler(pgfailback, set_pgfailback)
+declare_mp_snprint(pgfailback, print_pgfailback)
+
 static int
-def_queue_without_daemon(vector strvec)
+set_no_path_retry(vector strvec, void *ptr)
 {
+	int *int_ptr = (int *)ptr;
 	char * buff;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
-		 !strncmp(buff, "1", 1))
-		conf->queue_without_daemon = QUE_NO_DAEMON_ON;
-	else
-		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	if (!strcmp(buff, "fail") || !strcmp(buff, "0"))
+		*int_ptr = NO_PATH_RETRY_FAIL;
+	else if (!strcmp(buff, "queue"))
+		*int_ptr = NO_PATH_RETRY_QUEUE;
+	else if ((*int_ptr = atoi(buff)) < 1)
+		*int_ptr = NO_PATH_RETRY_UNDEF;
 
-	free(buff);
+	FREE(buff);
 	return 0;
 }
 
 static int
-def_checker_timeout_handler(vector strvec)
+print_no_path_retry(char * buff, int len, void *ptr)
 {
-	unsigned int checker_timeout;
-	char *buff;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
+	int *int_ptr = (int *)ptr;
 
-	if (sscanf(buff, "%u", &checker_timeout) == 1)
-		conf->checker_timeout = checker_timeout;
-	else
-		conf->checker_timeout = 0;
-
-	free(buff);
-	return 0;
+	switch(*int_ptr) {
+	case NO_PATH_RETRY_UNDEF:
+		return 0;
+	case NO_PATH_RETRY_FAIL:
+		return snprintf(buff, len, "\"fail\"");
+	case NO_PATH_RETRY_QUEUE:
+		return snprintf(buff, len, "\"queue\"");
+	default:
+		return snprintf(buff, len, "%i", *int_ptr);
+	}
 }
 
+declare_def_handler(no_path_retry, set_no_path_retry)
+declare_def_snprint(no_path_retry, print_no_path_retry)
+declare_hw_handler(no_path_retry, set_no_path_retry)
+declare_hw_snprint(no_path_retry, print_no_path_retry)
+declare_mp_handler(no_path_retry, set_no_path_retry)
+declare_mp_snprint(no_path_retry, print_no_path_retry)
+
 static int
-def_pg_timeout_handler(vector strvec)
+def_log_checker_err_handler(vector strvec)
 {
 	char * buff;
 
@@ -500,56 +808,27 @@ def_pg_timeout_handler(vector strvec)
 	if (!buff)
 		return 1;
 
-	/* Deprecated; device-mapper support has been removed */
+	if (strlen(buff) == 4 && !strcmp(buff, "once"))
+		conf->log_checker_err = LOG_CHKR_ERR_ONCE;
+	else if (strlen(buff) == 6 && !strcmp(buff, "always"))
+		conf->log_checker_err = LOG_CHKR_ERR_ALWAYS;
 
-	FREE(buff);
+	free(buff);
 	return 0;
 }
 
 static int
-def_flush_on_last_del_handler(vector strvec)
+snprint_def_log_checker_err (char * buff, int len, void * data)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
-		conf->flush_on_last_del = FLUSH_DISABLED;
-	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
-		conf->flush_on_last_del = FLUSH_ENABLED;
-	else
-		conf->flush_on_last_del = FLUSH_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-def_log_checker_err_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if (strlen(buff) == 4 && !strcmp(buff, "once"))
-		conf->log_checker_err = LOG_CHKR_ERR_ONCE;
-	else if (strlen(buff) == 6 && !strcmp(buff, "always"))
-		conf->log_checker_err = LOG_CHKR_ERR_ALWAYS;
-
-	free(buff);
-	return 0;
+	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+		return snprintf(buff, len, "once");
+	return snprintf(buff, len, "always");
 }
 
 static int
-def_reservation_key_handler(vector strvec)
+set_reservation_key(vector strvec, void *ptr)
 {
+	unsigned char **uchar_ptr = (unsigned char **)ptr;
 	char *buff;
 	char *tbuff;
 	int j, k;
@@ -580,13 +859,13 @@ def_reservation_key_handler(vector strvec)
 		return 1;
 	}
 
-	if (!conf->reservation_key)
-		conf->reservation_key = (unsigned char *) malloc(8);
+	if (!*uchar_ptr)
+		*uchar_ptr = (unsigned char *) malloc(8);
 
-	memset(conf->reservation_key, 0, 8);
+	memset(*uchar_ptr, 0, 8);
 
 	for (j = 7; j >= 0; --j) {
-		conf->reservation_key[j] = (prkey & 0xff);
+		(*uchar_ptr)[j] = (prkey & 0xff);
 		prkey >>= 8;
 	}
 
@@ -595,118 +874,29 @@ def_reservation_key_handler(vector strvec)
 }
 
 static int
-def_names_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->user_friendly_names = USER_FRIENDLY_NAMES_ON;
-	else
-		conf->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-bindings_file_handler(vector strvec)
-{
-	conf->bindings_file = set_value(strvec);
-
-	if (!conf->bindings_file)
-		return 1;
-
-	return 0;
-}
-
-static int
-wwids_file_handler(vector strvec)
-{
-	conf->wwids_file = set_value(strvec);
-
-	if (!conf->wwids_file)
-		return 1;
-
-	return 0;
-}
-
-static int
-def_retain_hwhandler_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->retain_hwhandler = RETAIN_HWHANDLER_ON;
-	else
-		conf->retain_hwhandler = RETAIN_HWHANDLER_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-def_detect_prio_handler(vector strvec)
+print_reservation_key(char * buff, int len, void * ptr)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->detect_prio = DETECT_PRIO_OFF;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->detect_prio = DETECT_PRIO_ON;
-	else
-		conf->detect_prio = DETECT_PRIO_UNDEF;
+	unsigned char **uchar_ptr = (unsigned char **)ptr;
+	int i;
+	unsigned char *keyp;
+	uint64_t prkey = 0;
 
-	FREE(buff);
-	return 0;
+	if (!*uchar_ptr)
+		return 0;
+	keyp = (unsigned char *)(*uchar_ptr);
+	for (i = 0; i < 8; i++) {
+		if (i > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		keyp++;
+	}
+	return snprintf(buff, len, "0x%" PRIx64, prkey);
 }
 
-static int
-def_force_sync_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		conf->force_sync = 0;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		conf->force_sync = 1;
-	else
-		conf->force_sync = 0;
-
-	FREE(buff);
-	return 0;
-}
+declare_def_handler(reservation_key, set_reservation_key)
+declare_def_snprint(reservation_key, print_reservation_key)
+declare_mp_handler(reservation_key, set_reservation_key)
+declare_mp_snprint(reservation_key, print_reservation_key)
 
 /*
  * blacklist block handlers
@@ -741,82 +931,51 @@ blacklist_exceptions_handler(vector strvec)
 	return 0;
 }
 
-static int
-ble_devnode_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return store_ble(conf->blist_devnode, buff, ORIGIN_CONFIG);
-}
-
-static int
-ble_except_devnode_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return store_ble(conf->elist_devnode, buff, ORIGIN_CONFIG);
-}
-
-static int
-ble_wwid_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return store_ble(conf->blist_wwid, buff, ORIGIN_CONFIG);
+#define declare_ble_handler(option)					\
+static int								\
+ble_ ## option ## _handler (vector strvec)				\
+{									\
+	char * buff;							\
+									\
+	if (!conf->option)						\
+		return 1;						\
+									\
+	buff = set_value(strvec);					\
+	if (!buff)							\
+		return 1;						\
+									\
+	return store_ble(conf->option, buff, ORIGIN_CONFIG);		\
 }
 
-static int
-ble_except_wwid_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return store_ble(conf->elist_wwid, buff, ORIGIN_CONFIG);
+#define declare_ble_device_handler(name, option, vend, prod)		\
+static int								\
+ble_ ## option ## _ ## name ## _handler (vector strvec)			\
+{									\
+	char * buff;							\
+									\
+	if (!conf->option)						\
+		return 1;						\
+									\
+	buff = set_value(strvec);					\
+	if (!buff)							\
+		return 1;						\
+									\
+	return set_ble_device(conf->option, vend, prod, ORIGIN_CONFIG);	\
 }
 
-static int
-ble_property_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return store_ble(conf->blist_property, buff, ORIGIN_CONFIG);
-}
+declare_ble_handler(blist_devnode)
+declare_ble_handler(elist_devnode)
+declare_ble_handler(blist_wwid)
+declare_ble_handler(elist_wwid)
+declare_ble_handler(blist_property)
+declare_ble_handler(elist_property)
 
 static int
-ble_except_property_handler(vector strvec)
+snprint_ble_simple (char * buff, int len, void * data)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
+	struct blentry * ble = (struct blentry *)data;
 
-	return store_ble(conf->elist_property, buff, ORIGIN_CONFIG);
+	return snprintf(buff, len, "\"%s\"", ble->str);
 }
 
 static int
@@ -831,56 +990,25 @@ ble_except_device_handler(vector strvec)
 	return alloc_ble_device(conf->elist_device);
 }
 
-static int
-ble_vendor_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return set_ble_device(conf->blist_device, buff, NULL, ORIGIN_CONFIG);
-}
-
-static int
-ble_except_vendor_handler(vector strvec)
-{
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	return set_ble_device(conf->elist_device, buff, NULL, ORIGIN_CONFIG);
-}
+declare_ble_device_handler(vendor, blist_device, buff, NULL)
+declare_ble_device_handler(vendor, elist_device, buff, NULL)
+declare_ble_device_handler(product, blist_device, NULL, buff)
+declare_ble_device_handler(product, elist_device, NULL, buff)
 
 static int
-ble_product_handler(vector strvec)
+snprint_bled_vendor (char * buff, int len, void * data)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
+	struct blentry_device * bled = (struct blentry_device *)data;
 
-	return set_ble_device(conf->blist_device, NULL, buff, ORIGIN_CONFIG);
+	return snprintf(buff, len, "\"%s\"", bled->vendor);
 }
 
 static int
-ble_except_product_handler(vector strvec)
+snprint_bled_product (char * buff, int len, void * data)
 {
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
+	struct blentry_device * bled = (struct blentry_device *)data;
 
-	return set_ble_device(conf->elist_device, NULL, buff, ORIGIN_CONFIG);
+	return snprintf(buff, len, "\"%s\"", bled->product);
 }
 
 /*
@@ -917,1995 +1045,152 @@ device_handler(vector strvec)
 	return 0;
 }
 
-static int
-vendor_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+declare_hw_handler(vendor, set_str)
+declare_hw_snprint(vendor, print_str)
 
-	if (!hwe)
-		return 1;
+declare_hw_handler(product, set_str)
+declare_hw_snprint(product, print_str)
 
-	hwe->vendor = set_value(strvec);
+declare_hw_handler(revision, set_str)
+declare_hw_snprint(revision, print_str)
 
-	if (!hwe->vendor)
-		return 1;
+declare_hw_handler(bl_product, set_str)
+declare_hw_snprint(bl_product, print_str)
 
-	return 0;
-}
+declare_hw_handler(hwhandler, set_str)
+declare_hw_snprint(hwhandler, print_str)
 
+/*
+ * multipaths block handlers
+ */
 static int
-product_handler(vector strvec)
+multipaths_handler(vector strvec)
 {
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->product = set_value(strvec);
+	conf->mptable = vector_alloc();
 
-	if (!hwe->product)
+	if (!conf->mptable)
 		return 1;
 
 	return 0;
 }
 
 static int
-revision_handler(vector strvec)
+multipath_handler(vector strvec)
 {
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->revision = set_value(strvec);
-
-	if (!hwe->revision)
-		return 1;
-
-	return 0;
-}
+	struct mpentry * mpe;
 
-static int
-bl_product_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	mpe = alloc_mpe();
 
-	if (!hwe)
+	if (!mpe)
 		return 1;
 
-	hwe->bl_product = set_value(strvec);
-	if (!hwe->bl_product)
+	if (!vector_alloc_slot(conf->mptable)) {
+		free_mpe(mpe);
 		return 1;
+	}
+	vector_set_slot(conf->mptable, mpe);
 
 	return 0;
 }
 
-static int
-hw_fast_io_fail_handler(vector strvec)
-{
-	char * buff;
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+declare_mp_handler(wwid, set_str)
+declare_mp_snprint(wwid, print_str)
 
-	buff = set_value(strvec);
-	if (strlen(buff) == 3 && !strcmp(buff, "off"))
-		hwe->fast_io_fail = MP_FAST_IO_FAIL_OFF;
-	else if (sscanf(buff, "%d", &hwe->fast_io_fail) != 1 ||
-		 hwe->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
-		hwe->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
-	else if (hwe->fast_io_fail == 0)
-		hwe->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
+declare_mp_handler(alias, set_str)
+declare_mp_snprint(alias, print_str)
 
-	FREE(buff);
-	return 0;
-}
+/*
+ * deprecated handlers
+ */
 
 static int
-hw_dev_loss_handler(vector strvec)
+deprecated_handler(vector strvec)
 {
 	char * buff;
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 
 	buff = set_value(strvec);
+
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 8 && !strcmp(buff, "infinity"))
-		hwe->dev_loss = MAX_DEV_LOSS_TMO;
-	else if (sscanf(buff, "%u", &hwe->dev_loss) != 1)
-		hwe->dev_loss = 0;
-
 	FREE(buff);
 	return 0;
 }
 
 static int
-hw_pgpolicy_handler(vector strvec)
+snprint_deprecated (char * buff, int len, void * data)
 {
-	char * buff;
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	hwe->pgpolicy = get_pgpolicy_id(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-hw_uid_attribute_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	hwe->uid_attribute = set_value(strvec);
-
-	if (!hwe->uid_attribute)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_getuid_callout_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	hwe->getuid = set_value(strvec);
-
-	if (!hwe->getuid)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_selector_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->selector = set_value(strvec);
-
-	if (!hwe->selector)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_path_checker_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->checker_name = set_value(strvec);
-
-	if (!hwe->checker_name)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_features_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->features = set_value(strvec);
-
-	if (!hwe->features)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_handler_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->hwhandler = set_value(strvec);
-
-	if (!hwe->hwhandler)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_prio_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->prio_name = set_value(strvec);
-
-	if (!hwe->prio_name)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_alias_prefix_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->alias_prefix = set_value(strvec);
-
-	if (!hwe->alias_prefix)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_prio_args_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-
-	if (!hwe)
-		return 1;
-
-	hwe->prio_args = set_value(strvec);
-
-	if (!hwe->prio_args)
-		return 1;
-
-	return 0;
-}
-
-static int
-hw_failback_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
-		hwe->pgfailback = -FAILBACK_MANUAL;
-	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
-		hwe->pgfailback = -FAILBACK_IMMEDIATE;
-	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
-		hwe->pgfailback = -FAILBACK_FOLLOWOVER;
-	else
-		hwe->pgfailback = atoi(buff);
-
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-hw_weight_handler(vector strvec)
-{
-	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if (strlen(buff) == 10 &&
-	    !strcmp(buff, "priorities"))
-		hwe->rr_weight = RR_WEIGHT_PRIO;
-
-	if (strlen(buff) == strlen("uniform") &&
-	    !strcmp(buff, "uniform"))
-		hwe->rr_weight = RR_WEIGHT_NONE;
-
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-hw_no_path_retry_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char *buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 4 && !strcmp(buff, "fail")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		hwe->no_path_retry = NO_PATH_RETRY_FAIL;
-	else if (strlen(buff) == 5 && !strcmp(buff, "queue"))
-		hwe->no_path_retry = NO_PATH_RETRY_QUEUE;
-	else if ((hwe->no_path_retry = atoi(buff)) < 1)
-		hwe->no_path_retry = NO_PATH_RETRY_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-hw_minio_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	hwe->minio = atoi(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-hw_minio_rq_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	hwe->minio_rq = atoi(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-hw_pg_timeout_handler(vector strvec)
-{
-	char *buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	/* Deprecated; device-mapper support has been removed */
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-hw_flush_on_last_del_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
-		hwe->flush_on_last_del = FLUSH_DISABLED;
-	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
-		hwe->flush_on_last_del = FLUSH_ENABLED;
-	else
-		hwe->flush_on_last_del = FLUSH_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-hw_names_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
-		hwe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
-	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
-		 (strlen(buff) == 1 && strcmp(buff, "1") == 0))
-		hwe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
-	else
-		hwe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-hw_retain_hwhandler_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		hwe->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		hwe->retain_hwhandler = RETAIN_HWHANDLER_ON;
-	else
-		hwe->user_friendly_names = RETAIN_HWHANDLER_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-hw_detect_prio_handler(vector strvec)
-{
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
-	char * buff;
-
-	if (!hwe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		hwe->detect_prio = DETECT_PRIO_OFF;
-	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
-		 (strlen(buff) == 1 && !strcmp(buff, "1")))
-		hwe->detect_prio = DETECT_PRIO_ON;
-	else
-		hwe->detect_prio = DETECT_PRIO_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-/*
- * multipaths block handlers
- */
-static int
-multipaths_handler(vector strvec)
-{
-	conf->mptable = vector_alloc();
-
-	if (!conf->mptable)
-		return 1;
-
-	return 0;
-}
-
-static int
-multipath_handler(vector strvec)
-{
-	struct mpentry * mpe;
-
-	mpe = alloc_mpe();
-
-	if (!mpe)
-		return 1;
-
-	if (!vector_alloc_slot(conf->mptable)) {
-		free_mpe(mpe);
-		return 1;
-	}
-	vector_set_slot(conf->mptable, mpe);
-
-	return 0;
-}
-
-static int
-wwid_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->wwid = set_value(strvec);
-
-	if (!mpe->wwid)
-		return 1;
-
-	return 0;
-}
-
-static int
-alias_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->alias = set_value(strvec);
-
-	if (!mpe->alias)
-		return 1;
-
-	return 0;
-}
-
-static int
-mp_pgpolicy_handler(vector strvec)
-{
-	char * buff;
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	mpe->pgpolicy = get_pgpolicy_id(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-mp_selector_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->selector = set_value(strvec);
-
-	if (!mpe->selector)
-		return 1;
-
-	return 0;
-}
-
-static int
-mp_failback_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
-		mpe->pgfailback = -FAILBACK_MANUAL;
-	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
-		mpe->pgfailback = -FAILBACK_IMMEDIATE;
-	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
-		mpe->pgfailback = -FAILBACK_FOLLOWOVER;
-	else
-		mpe->pgfailback = atoi(buff);
-
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-mp_mode_handler(vector strvec)
-{
-	mode_t mode;
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char *buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
-		mpe->attribute_flags |= (1 << ATTR_MODE);
-		mpe->mode = mode;
-	}
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_uid_handler(vector strvec)
-{
-	uid_t uid;
-	char *buff;
-	char passwd_buf[1024];
-	struct passwd info, *found;
-
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
-		mpe->attribute_flags |= (1 << ATTR_UID);
-		mpe->uid = info.pw_uid;
-	}
-	else if (sscanf(buff, "%u", &uid) == 1){
-		mpe->attribute_flags |= (1 << ATTR_UID);
-		mpe->uid = uid;
-	}
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_gid_handler(vector strvec)
-{
-	gid_t gid;
-	char *buff;
-	char passwd_buf[1024];
-	struct passwd info, *found;
-
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
-		mpe->attribute_flags |= (1 << ATTR_GID);
-		mpe->gid = info.pw_gid;
-	}
-	else if (sscanf(buff, "%u", &gid) == 1) {
-		mpe->attribute_flags |= (1 << ATTR_GID);
-		mpe->gid = gid;
-	}
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_weight_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if (strlen(buff) == 10 &&
-	    !strcmp(buff, "priorities"))
-		mpe->rr_weight = RR_WEIGHT_PRIO;
-
-	if (strlen(buff) == strlen("uniform") &&
-	    !strcmp(buff, "uniform"))
-		mpe->rr_weight = RR_WEIGHT_NONE;
-
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-mp_no_path_retry_handler(vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char *buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 4 && !strcmp(buff, "fail")) ||
-	    (strlen(buff) == 1 && !strcmp(buff, "0")))
-		mpe->no_path_retry = NO_PATH_RETRY_FAIL;
-	else if (strlen(buff) == 5 && !strcmp(buff, "queue"))
-		mpe->no_path_retry = NO_PATH_RETRY_QUEUE;
-	else if ((mpe->no_path_retry = atoi(buff)) < 1)
-		mpe->no_path_retry = NO_PATH_RETRY_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_minio_handler(vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	mpe->minio = atoi(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-mp_minio_rq_handler(vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	mpe->minio_rq = atoi(buff);
-	FREE(buff);
-
-	return 0;
-}
-
-static int
-mp_pg_timeout_handler(vector strvec)
-{
-	char *buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	/* Deprecated; device-mapper support has been removed */
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_features_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->features = set_value(strvec);
-
-	if (!mpe->features)
-		return 1;
-
-	return 0;
-}
-
-static int
-mp_flush_on_last_del_handler(vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
-		mpe->flush_on_last_del = FLUSH_DISABLED;
-	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
-		mpe->flush_on_last_del = FLUSH_ENABLED;
-	else
-		mpe->flush_on_last_del = FLUSH_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-static int
-mp_prio_handler(vector strvec)
-{
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->prio_name = set_value(strvec);
-
-	if (!mpe->prio_name)
-		return 1;
-
-	return 0;
-}
-
-static int
-mp_prio_args_handler (vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	if (!mpe)
-		return 1;
-
-	mpe->prio_args = set_value(strvec);
-	if (!mpe->prio_args)
-		return 1;
-
-	return 0;
-}
-
-static int
-mp_reservation_key_handler (vector strvec)
-{
-	char *buff;
-	char *tbuff;
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-
-	int j, k, len;
-	uint64_t prkey;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	tbuff = buff;
-	if (!memcmp(buff, "0x", 2))
-		buff = buff + 2;
-
-	len = strlen(buff);
-
-	k = strspn(buff, "0123456789aAbBcCdDeEfF");
-	if (len != k) {
-		FREE(tbuff);
-		return 1;
-	}
-
-	if (1 != sscanf (buff, "%" SCNx64 "", &prkey))
-	{
-		FREE(tbuff);
-		return 1;
-	}
-
-	if (!mpe->reservation_key)
-		mpe->reservation_key = (unsigned char *) malloc(8);
-
-	memset(mpe->reservation_key, 0, 8);
-
-	for (j = 7; j >= 0; --j) {
-		mpe->reservation_key[j] = (prkey & 0xff);
-		prkey >>= 8;
-	}
-
-	FREE(tbuff);
-	return 0;
-}
-
-static int
-mp_names_handler(vector strvec)
-{
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
-	char * buff;
-
-	if (!mpe)
-		return 1;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
-	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
-		mpe->user_friendly_names = USER_FRIENDLY_NAMES_OFF;
-	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
-		 (strlen(buff) == 1 && strcmp(buff, "1") == 0))
-		mpe->user_friendly_names = USER_FRIENDLY_NAMES_ON;
-	else
-		mpe->user_friendly_names = USER_FRIENDLY_NAMES_UNDEF;
-
-	FREE(buff);
-	return 0;
-}
-
-/*
- * config file keywords printing
- */
-static int
-snprint_mp_wwid (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	return snprintf(buff, len, "%s", mpe->wwid);
-}
-
-static int
-snprint_mp_alias (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->alias)
-		return 0;
-
-	return snprintf(buff, len, "%s", mpe->alias);
-}
-
-static int
-snprint_mp_path_grouping_policy (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-	char str[POLICY_NAME_SIZE];
-
-	if (!mpe->pgpolicy)
-		return 0;
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, mpe->pgpolicy);
-
-	return snprintf(buff, len, "\"%s\"", str);
-}
-
-static int
-snprint_mp_selector (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->selector)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", mpe->selector);
-}
-
-static int
-snprint_mp_failback (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (mpe->pgfailback == FAILBACK_UNDEF ||
-	    mpe->pgfailback == DEFAULT_FAILBACK)
-		return 0;
-
-	switch(mpe->pgfailback) {
-	case -FAILBACK_MANUAL:
-		return snprintf(buff, len, "\"manual\"");
-	case -FAILBACK_IMMEDIATE:
-		return snprintf(buff, len, "\"immediate\"");
-	case -FAILBACK_FOLLOWOVER:
-		return snprintf(buff, len, "\"followover\"");
-	default:
-		return snprintf(buff, len, "%i", mpe->pgfailback);
-	}
-	return 0;
-}
-
-static int
-snprint_mp_mode(char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if ((mpe->attribute_flags & (1 << ATTR_MODE)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", mpe->mode);
-}
-
-static int
-snprint_mp_uid(char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if ((mpe->attribute_flags & (1 << ATTR_UID)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", mpe->uid);
-}
-
-static int
-snprint_mp_gid(char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if ((mpe->attribute_flags & (1 << ATTR_GID)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", mpe->gid);
-}
-
-static int
-snprint_mp_rr_weight (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->rr_weight)
-		return 0;
-	if (mpe->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "\"priorities\"");
-	if (mpe->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "\"uniform\"");
-
-	return 0;
-}
-
-static int
-snprint_mp_no_path_retry (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->no_path_retry)
-		return 0;
-
-	switch(mpe->no_path_retry) {
-	case NO_PATH_RETRY_UNDEF:
-		break;
-	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "\"fail\"");
-	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "\"queue\"");
-	default:
-		return snprintf(buff, len, "%i",
-				mpe->no_path_retry);
-	}
-	return 0;
-}
-
-static int
-snprint_mp_rr_min_io (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->minio)
-		return 0;
-
-	return snprintf(buff, len, "%u", mpe->minio);
-}
-
-static int
-snprint_mp_rr_min_io_rq (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->minio_rq)
-		return 0;
-
-	return snprintf(buff, len, "%u", mpe->minio_rq);
-}
-
-static int
-snprint_mp_pg_timeout (char * buff, int len, void * data)
-{
-	return 0;
-}
-
-static int
-snprint_mp_features (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->features)
-		return 0;
-	if (strlen(mpe->features) == strlen(conf->features) &&
-	    !strcmp(mpe->features, conf->features))
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", mpe->features);
-}
-
-static int
-snprint_mp_flush_on_last_del (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	switch (mpe->flush_on_last_del) {
-	case FLUSH_DISABLED:
-		return snprintf(buff, len, "\"no\"");
-	case FLUSH_ENABLED:
-		return snprintf(buff, len, "\"yes\"");
-	}
-	return 0;
-}
-
-static int
-snprint_mp_prio(char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->prio_name)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", mpe->prio_name);
-}
-
-static int
-snprint_mp_prio_args(char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->prio_args)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", mpe->prio_args);
-}
-
-static int
-snprint_mp_reservation_key (char * buff, int len, void * data)
-{
-	int i;
-	unsigned char *keyp;
-	uint64_t prkey = 0;
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (!mpe->reservation_key)
-		return 0;
-	keyp = (unsigned char *)mpe->reservation_key;
-	for (i = 0; i < 8; i++) {
-		if (i > 0)
-			prkey <<= 8;
-		prkey |= *keyp;
-		keyp++;
-	}
-
-	return snprintf(buff, len, "0x%" PRIx64, prkey);
-}
-
-	static int
-snprint_mp_user_friendly_names (char * buff, int len, void * data)
-{
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
-		return 0;
-	else if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
-		return snprintf(buff, len, "\"no\"");
-	else
-		return snprintf(buff, len, "\"yes\"");
-}
-
-static int
-snprint_hw_fast_io_fail(char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
-		return 0;
-	if (hwe->fast_io_fail == conf->fast_io_fail)
-		return 0;
-	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-		return snprintf(buff, len, "\"off\"");
-	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
-		return snprintf(buff, len, "0");
-	return snprintf(buff, len, "%d", hwe->fast_io_fail);
-}
-
-static int
-snprint_hw_dev_loss(char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-	if (!hwe->dev_loss)
-		return 0;
-	if (hwe->dev_loss == conf->dev_loss)
-		return 0;
-	if (hwe->dev_loss >= MAX_DEV_LOSS_TMO)
-		return snprintf(buff, len, "\"infinity\"");
-
-	return snprintf(buff, len, "%u", hwe->dev_loss);
-}
-
-static int
-snprint_hw_vendor (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->vendor)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->vendor);
-}
-
-static int
-snprint_hw_product (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->product)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->product);
-}
-
-static int
-snprint_hw_revision (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->revision)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->revision);
-}
-
-static int
-snprint_hw_bl_product (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->bl_product)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->bl_product);
-}
-
-static int
-snprint_hw_uid_attribute (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->uid_attribute)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->uid_attribute);
-}
-
-static int
-snprint_hw_getuid_callout (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->getuid)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->getuid);
-}
-
-static int
-snprint_hw_prio (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->prio_name)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->prio_name);
-}
-
-static int
-snprint_hw_alias_prefix (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->alias_prefix)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->alias_prefix);
-}
-
-static int
-snprint_hw_prio_args (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->prio_args)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->prio_args);
-}
-
-static int
-snprint_hw_features (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->features)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->features);
-}
-
-static int
-snprint_hw_hardware_handler (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->hwhandler)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->hwhandler);
-}
-
-static int
-snprint_hw_selector (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->selector)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->selector);
-}
-
-static int
-snprint_hw_path_grouping_policy (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	char str[POLICY_NAME_SIZE];
-
-	if (!hwe->pgpolicy)
-		return 0;
-
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, hwe->pgpolicy);
-
-	return snprintf(buff, len, "\"%s\"", str);
-}
-
-static int
-snprint_hw_failback (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (hwe->pgfailback == FAILBACK_UNDEF ||
-	    hwe->pgfailback == DEFAULT_FAILBACK)
-		return 0;
-
-	switch(hwe->pgfailback) {
-	case -FAILBACK_MANUAL:
-		return snprintf(buff, len, "\"manual\"");
-	case -FAILBACK_IMMEDIATE:
-		return snprintf(buff, len, "\"immediate\"");
-	case -FAILBACK_FOLLOWOVER:
-		return snprintf(buff, len, "\"followover\"");
-	default:
-		return snprintf(buff, len, "%i", hwe->pgfailback);
-	}
-	return 0;
-}
-
-static int
-snprint_hw_rr_weight (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->rr_weight)
-		return 0;
-	if (hwe->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "\"priorities\"");
-	if (hwe->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "\"uniform\"");
-
-	return 0;
-}
-
-static int
-snprint_hw_no_path_retry (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->no_path_retry)
-		return 0;
-
-	switch(hwe->no_path_retry) {
-	case NO_PATH_RETRY_UNDEF:
-		break;
-	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "\"fail\"");
-	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "\"queue\"");
-	default:
-		return snprintf(buff, len, "%i",
-				hwe->no_path_retry);
-	}
-	return 0;
-}
-
-static int
-snprint_hw_rr_min_io (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->minio)
-		return 0;
-
-	return snprintf(buff, len, "%u", hwe->minio);
-}
-
-static int
-snprint_hw_rr_min_io_rq (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->minio_rq)
-		return 0;
-
-	return snprintf(buff, len, "%u", hwe->minio_rq);
-}
-
-static int
-snprint_hw_pg_timeout (char * buff, int len, void * data)
-{
-	return 0;
-}
-
-static int
-snprint_hw_flush_on_last_del (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	switch (hwe->flush_on_last_del) {
-	case FLUSH_DISABLED:
-		return snprintf(buff, len, "\"no\"");
-	case FLUSH_ENABLED:
-		return snprintf(buff, len, "\"yes\"");
-	}
-	return 0;
-}
-
-static int
-snprint_hw_path_checker (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->checker_name)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", hwe->checker_name);
-}
-
-	static int
-snprint_hw_user_friendly_names (char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
-		return 0;
-	else if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
-		return snprintf(buff, len, "\"no\"");
-	else
-		return snprintf(buff, len, "\"yes\"");
-}
-
-static int
-snprint_hw_retain_hwhandler_handler(char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (hwe->retain_hwhandler == RETAIN_HWHANDLER_ON)
-		return snprintf(buff, len, "\"yes\"");
-	else if (hwe->retain_hwhandler == RETAIN_HWHANDLER_OFF)
-		return snprintf(buff, len, "\"no\"");
-	else
-		return 0;
-}
-
-static int
-snprint_detect_prio(char * buff, int len, void * data)
-{
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (hwe->detect_prio == DETECT_PRIO_ON)
-		return snprintf(buff, len, "\"yes\"");
-	else if (hwe->detect_prio == DETECT_PRIO_OFF)
-		return snprintf(buff, len, "\"no\"");
-	else
-		return 0;
-}
-
-static int
-snprint_def_polling_interval (char * buff, int len, void * data)
-{
-	return snprintf(buff, len, "%i", conf->checkint);
-}
-
-static int
-snprint_def_fast_io_fail(char * buff, int len, void * data)
-{
-	if (conf->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
-		return 0;
-	if (conf->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-		return snprintf(buff, len, "\"off\"");
-	if (conf->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
-		return snprintf(buff, len, "0");
-	return snprintf(buff, len, "%d", conf->fast_io_fail);
-}
-
-static int
-snprint_def_dev_loss(char * buff, int len, void * data)
-{
-	if (!conf->dev_loss)
-		return 0;
-	if (conf->dev_loss >= MAX_DEV_LOSS_TMO)
-		return snprintf(buff, len, "\"infinity\"");
-	return snprintf(buff, len, "%u", conf->dev_loss);
-}
-
-static int
-snprint_def_verbosity (char * buff, int len, void * data)
-{
-	return snprintf(buff, len, "%i", conf->verbosity);
-}
-
-static int
-snprint_def_max_polling_interval (char * buff, int len, void * data)
-{
-	return snprintf(buff, len, "%i", conf->max_checkint);
-}
-
-static int
-snprint_reassign_maps (char * buff, int len, void * data)
-{
-	return snprintf(buff, len, "\"%s\"",
-			conf->reassign_maps?"yes":"no");
-}
-
-static int
-snprint_def_multipath_dir (char * buff, int len, void * data)
-{
-	if (!conf->multipath_dir)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", conf->multipath_dir);
-}
-
-static int
-snprint_def_selector (char * buff, int len, void * data)
-{
-	if (!conf->selector)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_SELECTOR);
-
-	return snprintf(buff, len, "\"%s\"", conf->selector);
-}
-
-static int
-snprint_def_path_grouping_policy (char * buff, int len, void * data)
-{
-	char str[POLICY_NAME_SIZE];
-	int pgpolicy = conf->pgpolicy;
-
-	if (!pgpolicy)
-		pgpolicy = DEFAULT_PGPOLICY;
-
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
-
-	return snprintf(buff, len, "\"%s\"", str);
-}
-
-static int
-snprint_def_uid_attribute (char * buff, int len, void * data)
-{
-	if (!conf->uid_attribute)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_UID_ATTRIBUTE);
-
-	return snprintf(buff, len, "\"%s\"", conf->uid_attribute);
-}
-
-static int
-snprint_def_getuid_callout (char * buff, int len, void * data)
-{
-	if (!conf->getuid)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", conf->getuid);
-}
-
-static int
-snprint_def_prio (char * buff, int len, void * data)
-{
-	if (!conf->prio_name)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_PRIO);
-
-	return snprintf(buff, len, "\"%s\"", conf->prio_name);
-}
-
-static int
-snprint_def_prio_args (char * buff, int len, void * data)
-{
-	if (!conf->prio_args)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_PRIO_ARGS);
-
-	return snprintf(buff, len, "\"%s\"", conf->prio_args);
-}
-
-static int
-snprint_def_features (char * buff, int len, void * data)
-{
-	if (!conf->features)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_FEATURES);
-
-	return snprintf(buff, len, "\"%s\"", conf->features);
-}
-
-static int
-snprint_def_path_checker (char * buff, int len, void * data)
-{
-	if (!conf->checker_name)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_CHECKER);
-
-	return snprintf(buff, len, "\"%s\"", conf->checker_name);
-}
-
-static int
-snprint_def_failback (char * buff, int len, void * data)
-{
-	switch(conf->pgfailback) {
-	case  FAILBACK_UNDEF:
-		return snprintf(buff, len, "\"undef\"");
-	case -FAILBACK_MANUAL:
-		return snprintf(buff, len, "\"manual\"");
-	case -FAILBACK_IMMEDIATE:
-		return snprintf(buff, len, "\"immediate\"");
-	case -FAILBACK_FOLLOWOVER:
-		return snprintf(buff, len, "\"followover\"");
-	default:
-		return snprintf(buff, len, "%i", conf->pgfailback);
-	}
-	return 0;
-}
-
-static int
-snprint_def_rr_min_io (char * buff, int len, void * data)
-{
-	if (!conf->minio)
-		return 0;
-
-	return snprintf(buff, len, "%u", conf->minio);
-}
-
-static int
-snprint_def_rr_min_io_rq (char * buff, int len, void * data)
-{
-	if (!conf->minio_rq)
-		return 0;
-
-	return snprintf(buff, len, "%u", conf->minio_rq);
-}
-
-static int
-snprint_max_fds (char * buff, int len, void * data)
-{
-	int r = 0, max_fds;
-
-	if (!conf->max_fds)
-		return 0;
-
-	r = get_sys_max_fds(&max_fds);
-	if (!r && conf->max_fds >= max_fds)
-		return snprintf(buff, len, "\"max\"");
-	else
-		return snprintf(buff, len, "%d", conf->max_fds);
-}
-
-static int
-snprint_def_mode(char * buff, int len, void * data)
-{
-	if ((conf->attribute_flags & (1 << ATTR_MODE)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", conf->mode);
-}
-
-static int
-snprint_def_uid(char * buff, int len, void * data)
-{
-	if ((conf->attribute_flags & (1 << ATTR_UID)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", conf->uid);
-}
-
-static int
-snprint_def_gid(char * buff, int len, void * data)
-{
-	if ((conf->attribute_flags & (1 << ATTR_GID)) == 0)
-		return 0;
-	return snprintf(buff, len, "0%o", conf->gid);
-}
-
-static int
-snprint_def_rr_weight (char * buff, int len, void * data)
-{
-	if (!conf->rr_weight || conf->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "\"uniform\"");
-	if (conf->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "\"priorities\"");
-
-	return 0;
-}
-
-static int
-snprint_def_no_path_retry (char * buff, int len, void * data)
-{
-	switch(conf->no_path_retry) {
-	case NO_PATH_RETRY_UNDEF:
-		break;
-	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "\"fail\"");
-	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "\"queue\"");
-	default:
-		return snprintf(buff, len, "%i",
-				conf->no_path_retry);
-	}
-	return 0;
-}
-
-static int
-snprint_def_queue_without_daemon (char * buff, int len, void * data)
-{
-	switch (conf->queue_without_daemon) {
-	case QUE_NO_DAEMON_OFF:
-		return snprintf(buff, len, "\"no\"");
-	case QUE_NO_DAEMON_ON:
-		return snprintf(buff, len, "\"yes\"");
-	case QUE_NO_DAEMON_FORCE:
-		return snprintf(buff, len, "\"forced\"");
-	}
-	return 0;
-}
-
-static int
-snprint_def_checker_timeout (char *buff, int len, void *data)
-{
-	if (!conf->checker_timeout)
-		return 0;
-
-	return snprintf(buff, len, "%u", conf->checker_timeout);
-}
-
-static int
-snprint_def_pg_timeout (char * buff, int len, void * data)
-{
-	return 0;
-}
-
-static int
-snprint_def_flush_on_last_del (char * buff, int len, void * data)
-{
-	switch (conf->flush_on_last_del) {
-	case FLUSH_UNDEF:
-	case FLUSH_DISABLED:
-		return snprintf(buff, len, "\"no\"");
-	case FLUSH_ENABLED:
-	case FLUSH_IN_PROGRESS:
-		return snprintf(buff, len, "\"yes\"");
-	}
 	return 0;
 }
 
-static int
-snprint_def_log_checker_err (char * buff, int len, void * data)
-{
-	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
-		return snprintf(buff, len, "once");
-	return snprintf(buff, len, "always");
-}
-
-static int
-snprint_def_user_friendly_names (char * buff, int len, void * data)
-{
-	if (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON)
-		return snprintf(buff, len, "\"yes\"");
-	else
-		return snprintf(buff, len, "\"no\"");
-}
-
-static int
-snprint_def_alias_prefix (char * buff, int len, void * data)
-{
-	if (!conf->alias_prefix)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_ALIAS_PREFIX);
-	return snprintf(buff, len, "\"%s\"", conf->alias_prefix);
-}
-
-static int
-snprint_def_bindings_file (char * buff, int len, void * data)
-{
-	if (conf->bindings_file == NULL)
-		return 0;
-	return snprintf(buff, len, "\"%s\"", conf->bindings_file);
-}
-
-static int
-snprint_def_wwids_file (char * buff, int len, void * data)
-{
-	if (conf->wwids_file == NULL)
-		return 0;
-	return snprintf(buff, len, "%s", conf->wwids_file);
-}
-
-static int
-snprint_def_reservation_key(char * buff, int len, void * data)
-{
-	int i;
-	unsigned char *keyp;
-	uint64_t prkey = 0;
-
-	if (!conf->reservation_key)
-		return 0;
-	keyp = (unsigned char *)conf->reservation_key;
-	for (i = 0; i < 8; i++) {
-		if (i > 0)
-			prkey <<= 8;
-		prkey |= *keyp;
-		keyp++;
-	}
-	return snprintf(buff, len, "0x%" PRIx64, prkey);
-}
-
-static int
-snprint_def_retain_hwhandler_handler(char * buff, int len, void * data)
-{
-	if (conf->retain_hwhandler == RETAIN_HWHANDLER_ON)
-		return snprintf(buff, len, "yes");
-	else
-		return snprintf(buff, len, "no");
-}
-
-static int
-snprint_def_detect_prio(char * buff, int len, void * data)
-{
-	if (conf->detect_prio == DETECT_PRIO_ON)
-		return snprintf(buff, len, "yes");
-	else
-		return snprintf(buff, len, "no");
-}
-
-static int
-snprint_def_force_sync(char * buff, int len, void * data)
-{
-	if (conf->force_sync)
-		return snprintf(buff, len, "yes");
-	else
-		return snprintf(buff, len, "no");
-}
-
-static int
-snprint_ble_simple (char * buff, int len, void * data)
-{
-	struct blentry * ble = (struct blentry *)data;
-
-	return snprintf(buff, len, "\"%s\"", ble->str);
-}
-
-static int
-snprint_bled_vendor (char * buff, int len, void * data)
-{
-	struct blentry_device * bled = (struct blentry_device *)data;
-
-	return snprintf(buff, len, "\"%s\"", bled->vendor);
-}
-
-static int
-snprint_bled_product (char * buff, int len, void * data)
-{
-	struct blentry_device * bled = (struct blentry_device *)data;
-
-	return snprintf(buff, len, "\"%s\"", bled->product);
-}
-
 #define __deprecated
 
 void
 init_keywords(void)
 {
 	install_keyword_root("defaults", NULL);
-	install_keyword("verbosity", &verbosity_handler, &snprint_def_verbosity);
-	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
-	install_keyword("max_polling_interval", &max_polling_interval_handler, &snprint_def_max_polling_interval);
-	install_keyword("reassign_maps", &reassign_maps_handler, &snprint_reassign_maps);
-	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
+	install_keyword("verbosity", &def_verbosity_handler, &snprint_def_verbosity);
+	install_keyword("polling_interval", &def_checkint_handler, &snprint_def_checkint);
+	install_keyword("max_polling_interval", &def_max_checkint_handler, &snprint_def_max_checkint);
+	install_keyword("reassign_maps", &def_reassign_maps_handler, &snprint_def_reassign_maps);
+	install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
-	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
+	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_pgpolicy);
 	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
-	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
-	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
+	install_keyword("getuid_callout", &def_getuid_handler, &snprint_def_getuid);
+	install_keyword("prio", &def_prio_name_handler, &snprint_def_prio_name);
 	install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_args);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
-	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
-	install_keyword("checker", &def_path_checker_handler, NULL);
+	install_keyword("path_checker", &def_checker_name_handler, &snprint_def_checker_name);
+	install_keyword("checker", &def_checker_name_handler, NULL);
 	install_keyword("alias_prefix", &def_alias_prefix_handler, &snprint_def_alias_prefix);
-	install_keyword("failback", &default_failback_handler, &snprint_def_failback);
-	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_rr_min_io);
-	install_keyword("rr_min_io_rq", &def_minio_rq_handler, &snprint_def_rr_min_io_rq);
+	install_keyword("failback", &def_pgfailback_handler, &snprint_def_pgfailback);
+	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_minio);
+	install_keyword("rr_min_io_rq", &def_minio_rq_handler, &snprint_def_minio_rq);
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
-	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
+	install_keyword("rr_weight", &def_rr_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
-	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
+	install_keyword("queue_without_daemon", &def_queue_without_daemon_handler, &snprint_def_queue_without_daemon);
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
-	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
+	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
-	install_keyword("user_friendly_names", &def_names_handler, &snprint_def_user_friendly_names);
+	install_keyword("user_friendly_names", &def_user_friendly_names_handler, &snprint_def_user_friendly_names);
 	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
 	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
 	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
-	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
-	install_keyword("wwids_file", &wwids_file_handler, &snprint_def_wwids_file);
+	install_keyword("bindings_file", &def_bindings_file_handler, &snprint_def_bindings_file);
+	install_keyword("wwids_file", &def_wwids_file_handler, &snprint_def_wwids_file);
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
-	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
+	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
-	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
+	__deprecated install_keyword("default_getuid_callout", &def_getuid_handler, NULL);
 	__deprecated install_keyword("default_features", &def_features_handler, NULL);
-	__deprecated install_keyword("default_path_checker", &def_path_checker_handler, NULL);
+	__deprecated install_keyword("default_path_checker", &def_checker_name_handler, NULL);
 
 	install_keyword_root("blacklist", &blacklist_handler);
-	install_keyword_multi("devnode", &ble_devnode_handler, &snprint_ble_simple);
-	install_keyword_multi("wwid", &ble_wwid_handler, &snprint_ble_simple);
-	install_keyword_multi("property", &ble_property_handler, &snprint_ble_simple);
+	install_keyword_multi("devnode", &ble_blist_devnode_handler, &snprint_ble_simple);
+	install_keyword_multi("wwid", &ble_blist_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("property", &ble_blist_property_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_device_handler, NULL);
 	install_sublevel();
-	install_keyword("vendor", &ble_vendor_handler, &snprint_bled_vendor);
-	install_keyword("product", &ble_product_handler, &snprint_bled_product);
+	install_keyword("vendor", &ble_blist_device_vendor_handler, &snprint_bled_vendor);
+	install_keyword("product", &ble_blist_device_product_handler, &snprint_bled_product);
 	install_sublevel_end();
 	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
-	install_keyword_multi("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
-	install_keyword_multi("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
-	install_keyword_multi("property", &ble_except_property_handler, &snprint_ble_simple);
+	install_keyword_multi("devnode", &ble_elist_devnode_handler, &snprint_ble_simple);
+	install_keyword_multi("wwid", &ble_elist_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("property", &ble_elist_property_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_except_device_handler, NULL);
 	install_sublevel();
-	install_keyword("vendor", &ble_except_vendor_handler, &snprint_bled_vendor);
-	install_keyword("product", &ble_except_product_handler, &snprint_bled_product);
+	install_keyword("vendor", &ble_elist_device_vendor_handler, &snprint_bled_vendor);
+	install_keyword("product", &ble_elist_device_product_handler, &snprint_bled_product);
 	install_sublevel_end();
 
 #if 0
@@ -2922,56 +1207,56 @@ init_keywords(void)
 	install_keyword_root("devices", &devices_handler);
 	install_keyword_multi("device", &device_handler, NULL);
 	install_sublevel();
-	install_keyword("vendor", &vendor_handler, &snprint_hw_vendor);
-	install_keyword("product", &product_handler, &snprint_hw_product);
-	install_keyword("revision", &revision_handler, &snprint_hw_revision);
-	install_keyword("product_blacklist", &bl_product_handler, &snprint_hw_bl_product);
-	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_path_grouping_policy);
+	install_keyword("vendor", &hw_vendor_handler, &snprint_hw_vendor);
+	install_keyword("product", &hw_product_handler, &snprint_hw_product);
+	install_keyword("revision", &hw_revision_handler, &snprint_hw_revision);
+	install_keyword("product_blacklist", &hw_bl_product_handler, &snprint_hw_bl_product);
+	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_pgpolicy);
 	install_keyword("uid_attribute", &hw_uid_attribute_handler, &snprint_hw_uid_attribute);
-	install_keyword("getuid_callout", &hw_getuid_callout_handler, &snprint_hw_getuid_callout);
+	install_keyword("getuid_callout", &hw_getuid_handler, &snprint_hw_getuid);
 	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
-	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
-	install_keyword("checker", &hw_path_checker_handler, NULL);
+	install_keyword("path_checker", &hw_checker_name_handler, &snprint_hw_checker_name);
+	install_keyword("checker", &hw_checker_name_handler, NULL);
 	install_keyword("alias_prefix", &hw_alias_prefix_handler, &snprint_hw_alias_prefix);
 	install_keyword("features", &hw_features_handler, &snprint_hw_features);
-	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
-	install_keyword("prio", &hw_prio_handler, &snprint_hw_prio);
+	install_keyword("hardware_handler", &hw_hwhandler_handler, &snprint_hw_hwhandler);
+	install_keyword("prio", &hw_prio_name_handler, &snprint_hw_prio_name);
 	install_keyword("prio_args", &hw_prio_args_handler, &snprint_hw_prio_args);
-	install_keyword("failback", &hw_failback_handler, &snprint_hw_failback);
-	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weight);
+	install_keyword("failback", &hw_pgfailback_handler, &snprint_hw_pgfailback);
+	install_keyword("rr_weight", &hw_rr_weight_handler, &snprint_hw_rr_weight);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
-	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_rr_min_io);
-	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_rr_min_io_rq);
-	install_keyword("pg_timeout", &hw_pg_timeout_handler, &snprint_hw_pg_timeout);
+	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
+	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_minio_rq);
+	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
-	install_keyword("user_friendly_names", &hw_names_handler, &snprint_hw_user_friendly_names);
-	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler_handler);
-	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_detect_prio);
+	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
+	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
+	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
 	install_sublevel();
-	install_keyword("wwid", &wwid_handler, &snprint_mp_wwid);
-	install_keyword("alias", &alias_handler, &snprint_mp_alias);
-	install_keyword("path_grouping_policy", &mp_pgpolicy_handler, &snprint_mp_path_grouping_policy);
+	install_keyword("wwid", &mp_wwid_handler, &snprint_mp_wwid);
+	install_keyword("alias", &mp_alias_handler, &snprint_mp_alias);
+	install_keyword("path_grouping_policy", &mp_pgpolicy_handler, &snprint_mp_pgpolicy);
 	install_keyword("path_selector", &mp_selector_handler, &snprint_mp_selector);
-	install_keyword("prio", &mp_prio_handler, &snprint_mp_prio);
+	install_keyword("prio", &mp_prio_name_handler, &snprint_mp_prio_name);
 	install_keyword("prio_args", &mp_prio_args_handler, &snprint_mp_prio_args);
-	install_keyword("failback", &mp_failback_handler, &snprint_mp_failback);
-	install_keyword("rr_weight", &mp_weight_handler, &snprint_mp_rr_weight);
+	install_keyword("failback", &mp_pgfailback_handler, &snprint_mp_pgfailback);
+	install_keyword("rr_weight", &mp_rr_weight_handler, &snprint_mp_rr_weight);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
-	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
-	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_rr_min_io_rq);
-	install_keyword("pg_timeout", &mp_pg_timeout_handler, &snprint_mp_pg_timeout);
+	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
+	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_minio_rq);
+	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
 	install_keyword("features", &mp_features_handler, &snprint_mp_features);
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
 	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
-	install_keyword("user_friendly_names", &mp_names_handler, &snprint_mp_user_friendly_names);
+	install_keyword("user_friendly_names", &mp_user_friendly_names_handler, &snprint_mp_user_friendly_names);
 	install_sublevel_end();
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index af03edf..15e7e19 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -67,15 +67,15 @@ enum pgstates {
 	PGSTATE_ACTIVE
 };
 
-enum queue_without_daemon_states {
-	QUE_NO_DAEMON_OFF,
-	QUE_NO_DAEMON_ON,
-	QUE_NO_DAEMON_FORCE,
+enum yes_no_states {
+	YN_NO,
+	YN_YES,
 };
 
-enum pgtimeouts {
-	PGTIMEOUT_UNDEF,
-	PGTIMEOUT_NONE
+enum queue_without_daemon_states {
+	QUE_NO_DAEMON_OFF = YN_NO,
+	QUE_NO_DAEMON_ON = YN_YES,
+	QUE_NO_DAEMON_FORCE,
 };
 
 enum attribute_bits {
@@ -84,10 +84,16 @@ enum attribute_bits {
 	ATTR_MODE,
 };
 
+enum yes_no_undef_states {
+	YNU_UNDEF,
+	YNU_NO,
+	YNU_YES,
+};
+
 enum flush_states {
-	FLUSH_UNDEF,
-	FLUSH_DISABLED,
-	FLUSH_ENABLED,
+	FLUSH_UNDEF = YNU_UNDEF,
+	FLUSH_DISABLED = YNU_NO,
+	FLUSH_ENABLED = YNU_YES,
 	FLUSH_IN_PROGRESS,
 };
 
@@ -97,21 +103,21 @@ enum log_checker_err_states {
 };
 
 enum user_friendly_names_states {
-	USER_FRIENDLY_NAMES_UNDEF,
-	USER_FRIENDLY_NAMES_OFF,
-	USER_FRIENDLY_NAMES_ON,
+	USER_FRIENDLY_NAMES_UNDEF = YNU_UNDEF,
+	USER_FRIENDLY_NAMES_OFF = YNU_NO,
+	USER_FRIENDLY_NAMES_ON = YNU_YES,
 };
 
 enum retain_hwhandler_states {
-	RETAIN_HWHANDLER_UNDEF,
-	RETAIN_HWHANDLER_OFF,
-	RETAIN_HWHANDLER_ON,
+	RETAIN_HWHANDLER_UNDEF = YNU_UNDEF,
+	RETAIN_HWHANDLER_OFF = YNU_NO,
+	RETAIN_HWHANDLER_ON = YNU_YES,
 };
 
 enum detect_prio_states {
-	DETECT_PRIO_UNDEF,
-	DETECT_PRIO_OFF,
-	DETECT_PRIO_ON,
+	DETECT_PRIO_UNDEF = YNU_UNDEF,
+	DETECT_PRIO_OFF = YNU_NO,
+	DETECT_PRIO_ON = YNU_YES,
 };
 
 enum scsi_protocol {
-- 
1.8.3.1
