From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/26] libmultipath: use explicit 'config'
	argument for configuration file parsing
Date: Mon,  4 Jul 2016 09:08:41 +0200
Message-ID: <1467616126-10036-22-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

When parsing the configuration file we should be passing in
'struct config' as an explicit argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  2 +-
 libmultipath/config.c           |  8 ++---
 libmultipath/configure.c        | 36 +++++++++----------
 libmultipath/dict.c             | 77 +++++++++++++++++++++--------------------
 libmultipath/discovery.c        |  8 ++---
 libmultipath/parser.c           | 25 +++++++------
 libmultipath/parser.h           | 18 +++++-----
 libmultipath/print.c            | 12 +++----
 libmultipath/print.h            | 10 +++---
 libmultipath/propsel.c          | 72 +++++++++++++++++++-------------------
 libmultipath/propsel.h          | 48 ++++++++++++-------------
 libmultipath/structs_vec.c      | 16 ++++-----
 libmultipath/structs_vec.h      |  4 ++-
 libmultipath/waiter.c           |  1 +
 mpathpersist/main.c             |  1 +
 multipath/main.c                | 12 +++----
 multipathd/cli_handlers.c       | 10 +++---
 multipathd/main.c               |  6 ++--
 18 files changed, 189 insertions(+), 177 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index d557da3..1c51397 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -317,7 +317,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		goto out1;
 	}
 
-	select_reservation_key(mpp);
+	select_reservation_key(conf, mpp);
 
 	switch(rq_servact)
 	{
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 3e59205..28e94b9 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -542,7 +542,7 @@ free_config (struct config * conf)
 /* if multipath fails to process the config directory, it should continue,
  * with just a warning message */
 static void
-process_config_dir(vector keywords, char *dir)
+process_config_dir(struct config *conf, vector keywords, char *dir)
 {
 	struct dirent **namelist;
 	int i, n;
@@ -569,7 +569,7 @@ process_config_dir(vector keywords, char *dir)
 		old_hwtable_size = VECTOR_SIZE(conf->hwtable);
 		snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]->d_name);
 		path[LINE_MAX-1] = '\0';
-		process_file(path);
+		process_file(conf, path);
 		if (VECTOR_SIZE(conf->hwtable) > old_hwtable_size)
 			factorize_hwtable(conf->hwtable, old_hwtable_size);
 
@@ -640,7 +640,7 @@ load_config (char * file)
 		int builtin_hwtable_size;
 
 		builtin_hwtable_size = VECTOR_SIZE(conf->hwtable);
-		if (process_file(file)) {
+		if (process_file(conf, file)) {
 			condlog(0, "error parsing config file");
 			goto out;
 		}
@@ -658,7 +658,7 @@ load_config (char * file)
 	if (conf->config_dir == NULL)
 		conf->config_dir = set_default(DEFAULT_CONFIG_DIR);
 	if (conf->config_dir && conf->config_dir[0] != '\0')
-		process_config_dir(conf->keywords, conf->config_dir);
+		process_config_dir(conf, conf->keywords, conf->config_dir);
 
 	/*
 	 * fill the voids left in the config file
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 53d89b0..5da49b8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -275,24 +275,24 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	/*
 	 * properties selectors
 	 */
-	select_pgfailback(mpp);
-	select_pgpolicy(mpp);
-	select_selector(mpp);
-	select_features(mpp);
-	select_hwhandler(mpp);
-	select_rr_weight(mpp);
-	select_minio(mpp);
-	select_no_path_retry(mpp);
-	select_mode(mpp);
-	select_uid(mpp);
-	select_gid(mpp);
-	select_fast_io_fail(mpp);
-	select_dev_loss(mpp);
-	select_reservation_key(mpp);
-	select_retain_hwhandler(mpp);
-	select_deferred_remove(mpp);
-	select_delay_watch_checks(mpp);
-	select_delay_wait_checks(mpp);
+	select_pgfailback(conf, mpp);
+	select_pgpolicy(conf, mpp);
+	select_selector(conf, mpp);
+	select_features(conf, mpp);
+	select_hwhandler(conf, mpp);
+	select_rr_weight(conf, mpp);
+	select_minio(conf, mpp);
+	select_no_path_retry(conf, mpp);
+	select_mode(conf, mpp);
+	select_uid(conf, mpp);
+	select_gid(conf, mpp);
+	select_fast_io_fail(conf, mpp);
+	select_dev_loss(conf, mpp);
+	select_reservation_key(conf, mpp);
+	select_retain_hwhandler(conf, mpp);
+	select_deferred_remove(conf, mpp);
+	select_delay_watch_checks(conf, mpp);
+	select_delay_wait_checks(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	/*
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9920a9b..ed0502a 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -135,21 +135,21 @@ print_yes_no_undef (char *buff, int len, void *ptr)
 
 #define declare_def_handler(option, function)				\
 static int								\
-def_ ## option ## _handler (vector strvec)				\
+def_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	return function (strvec, &conf->option);			\
 }
 
 #define declare_def_snprint(option, function)				\
 static int								\
-snprint_def_ ## option (char * buff, int len, void * data)		\
+snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	return function (buff, len, &conf->option);			\
 }
 
 #define declare_def_snprint_defint(option, function, value)		\
 static int								\
-snprint_def_ ## option (char * buff, int len, void * data)		\
+snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	int i = value;							\
 	if (!conf->option)						\
@@ -159,7 +159,7 @@ snprint_def_ ## option (char * buff, int len, void * data)		\
 
 #define declare_def_snprint_defstr(option, function, value)		\
 static int								\
-snprint_def_ ## option (char * buff, int len, void * data)		\
+snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	char *s = value;						\
 	if (!conf->option)						\
@@ -169,7 +169,7 @@ snprint_def_ ## option (char * buff, int len, void * data)		\
 
 #define declare_hw_handler(option, function)				\
 static int								\
-hw_ ## option ## _handler (vector strvec)				\
+hw_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
 	if (!hwe)							\
@@ -179,7 +179,7 @@ hw_ ## option ## _handler (vector strvec)				\
 
 #define declare_hw_snprint(option, function)				\
 static int								\
-snprint_hw_ ## option (char * buff, int len, void * data)		\
+snprint_hw_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	struct hwentry * hwe = (struct hwentry *)data;			\
 	return function (buff, len, &hwe->option);			\
@@ -187,7 +187,7 @@ snprint_hw_ ## option (char * buff, int len, void * data)		\
 
 #define declare_ovr_handler(option, function)				\
 static int								\
-ovr_ ## option ## _handler (vector strvec)				\
+ovr_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	if (!conf->overrides)						\
 		return 1;						\
@@ -196,14 +196,14 @@ ovr_ ## option ## _handler (vector strvec)				\
 
 #define declare_ovr_snprint(option, function)				\
 static int								\
-snprint_ovr_ ## option (char * buff, int len, void * data)		\
+snprint_ovr_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	return function (buff, len, &conf->overrides->option);		\
 }
 
 #define declare_mp_handler(option, function)				\
 static int								\
-mp_ ## option ## _handler (vector strvec)				\
+mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
 	if (!mpe)							\
@@ -213,7 +213,7 @@ mp_ ## option ## _handler (vector strvec)				\
 
 #define declare_mp_snprint(option, function)				\
 static int								\
-snprint_mp_ ## option (char * buff, int len, void * data)		\
+snprint_mp_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	struct mpentry * mpe = (struct mpentry *)data;			\
 	return function (buff, len, &mpe->option);			\
@@ -324,7 +324,8 @@ declare_mp_snprint(minio_rq, print_nonzero)
 
 declare_def_handler(queue_without_daemon, set_yes_no)
 static int
-snprint_def_queue_without_daemon (char * buff, int len, void * data)
+snprint_def_queue_without_daemon (struct config *conf,
+				  char * buff, int len, void * data)
 {
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
@@ -403,7 +404,7 @@ declare_def_handler(strict_timing, set_yes_no)
 declare_def_snprint(strict_timing, print_yes_no)
 
 static int
-def_config_dir_handler(vector strvec)
+def_config_dir_handler(struct config *conf, vector strvec)
 {
 	/* this is only valid in the main config file */
 	if (conf->processed_main_config)
@@ -414,14 +415,14 @@ declare_def_snprint(config_dir, print_str)
 
 #define declare_def_attr_handler(option, function)			\
 static int								\
-def_ ## option ## _handler (vector strvec)				\
+def_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	return function (strvec, &conf->option, &conf->attribute_flags);\
 }
 
 #define declare_def_attr_snprint(option, function)			\
 static int								\
-snprint_def_ ## option (char * buff, int len, void * data)		\
+snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	return function (buff, len, &conf->option,			\
 			 &conf->attribute_flags);			\
@@ -429,7 +430,7 @@ snprint_def_ ## option (char * buff, int len, void * data)		\
 
 #define declare_mp_attr_handler(option, function)			\
 static int								\
-mp_ ## option ## _handler (vector strvec)				\
+mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
 	if (!mpe)							\
@@ -439,7 +440,7 @@ mp_ ## option ## _handler (vector strvec)				\
 
 #define declare_mp_attr_snprint(option, function)			\
 static int								\
-snprint_mp_ ## option (char * buff, int len, void * data)		\
+snprint_mp_ ## option (struct config *conf, char * buff, int len, void * data) \
 {									\
 	struct mpentry * mpe = (struct mpentry *)data;			\
 	return function (buff, len, &mpe->option,			\
@@ -708,7 +709,7 @@ get_sys_max_fds(int *max_fds)
 
 
 static int
-max_fds_handler(vector strvec)
+max_fds_handler(struct config *conf, vector strvec)
 {
 	char * buff;
 	int r = 0, max_fds;
@@ -738,7 +739,7 @@ max_fds_handler(vector strvec)
 }
 
 static int
-snprint_max_fds (char * buff, int len, void * data)
+snprint_max_fds (struct config *conf, char * buff, int len, void * data)
 {
 	int r = 0, max_fds;
 
@@ -898,7 +899,7 @@ declare_mp_handler(no_path_retry, set_no_path_retry)
 declare_mp_snprint(no_path_retry, print_no_path_retry)
 
 static int
-def_log_checker_err_handler(vector strvec)
+def_log_checker_err_handler(struct config *conf, vector strvec)
 {
 	char * buff;
 
@@ -917,7 +918,7 @@ def_log_checker_err_handler(vector strvec)
 }
 
 static int
-snprint_def_log_checker_err (char * buff, int len, void * data)
+snprint_def_log_checker_err (struct config *conf, char * buff, int len, void * data)
 {
 	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
 		return snprintf(buff, len, "once");
@@ -1050,7 +1051,7 @@ declare_mp_handler(delay_wait_checks, set_delay_checks)
 declare_mp_snprint(delay_wait_checks, print_delay_checks)
 
 static int
-def_uxsock_timeout_handler(vector strvec)
+def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
 	unsigned int uxsock_timeout;
 	char *buff;
@@ -1073,7 +1074,7 @@ def_uxsock_timeout_handler(vector strvec)
  * blacklist block handlers
  */
 static int
-blacklist_handler(vector strvec)
+blacklist_handler(struct config *conf, vector strvec)
 {
 	if (!conf->blist_devnode)
 		conf->blist_devnode = vector_alloc();
@@ -1092,7 +1093,7 @@ blacklist_handler(vector strvec)
 }
 
 static int
-blacklist_exceptions_handler(vector strvec)
+blacklist_exceptions_handler(struct config *conf, vector strvec)
 {
 	if (!conf->elist_devnode)
 		conf->elist_devnode = vector_alloc();
@@ -1112,7 +1113,7 @@ blacklist_exceptions_handler(vector strvec)
 
 #define declare_ble_handler(option)					\
 static int								\
-ble_ ## option ## _handler (vector strvec)				\
+ble_ ## option ## _handler (struct config *conf, vector strvec)		\
 {									\
 	char * buff;							\
 									\
@@ -1128,7 +1129,7 @@ ble_ ## option ## _handler (vector strvec)				\
 
 #define declare_ble_device_handler(name, option, vend, prod)		\
 static int								\
-ble_ ## option ## _ ## name ## _handler (vector strvec)			\
+ble_ ## option ## _ ## name ## _handler (struct config *conf, vector strvec) \
 {									\
 	char * buff;							\
 									\
@@ -1150,13 +1151,13 @@ declare_ble_handler(blist_property)
 declare_ble_handler(elist_property)
 
 static int
-snprint_def_uxsock_timeout(char * buff, int len, void * data)
+snprint_def_uxsock_timeout(struct config *conf, char * buff, int len, void * data)
 {
 	return snprintf(buff, len, "%u", conf->uxsock_timeout);
 }
 
 static int
-snprint_ble_simple (char * buff, int len, void * data)
+snprint_ble_simple (struct config *conf, char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
 
@@ -1164,13 +1165,13 @@ snprint_ble_simple (char * buff, int len, void * data)
 }
 
 static int
-ble_device_handler(vector strvec)
+ble_device_handler(struct config *conf, vector strvec)
 {
 	return alloc_ble_device(conf->blist_device);
 }
 
 static int
-ble_except_device_handler(vector strvec)
+ble_except_device_handler(struct config *conf, vector strvec)
 {
 	return alloc_ble_device(conf->elist_device);
 }
@@ -1181,7 +1182,7 @@ declare_ble_device_handler(product, blist_device, NULL, buff)
 declare_ble_device_handler(product, elist_device, NULL, buff)
 
 static int
-snprint_bled_vendor (char * buff, int len, void * data)
+snprint_bled_vendor (struct config *conf, char * buff, int len, void * data)
 {
 	struct blentry_device * bled = (struct blentry_device *)data;
 
@@ -1189,7 +1190,7 @@ snprint_bled_vendor (char * buff, int len, void * data)
 }
 
 static int
-snprint_bled_product (char * buff, int len, void * data)
+snprint_bled_product (struct config *conf, char * buff, int len, void * data)
 {
 	struct blentry_device * bled = (struct blentry_device *)data;
 
@@ -1200,7 +1201,7 @@ snprint_bled_product (char * buff, int len, void * data)
  * devices block handlers
  */
 static int
-devices_handler(vector strvec)
+devices_handler(struct config *conf, vector strvec)
 {
 	if (!conf->hwtable)
 		conf->hwtable = vector_alloc();
@@ -1212,7 +1213,7 @@ devices_handler(vector strvec)
 }
 
 static int
-device_handler(vector strvec)
+device_handler(struct config *conf, vector strvec)
 {
 	struct hwentry * hwe;
 
@@ -1249,7 +1250,7 @@ declare_hw_snprint(hwhandler, print_str)
  * overrides handlers
  */
 static int
-overrides_handler(vector strvec)
+overrides_handler(struct config *conf, vector strvec)
 {
 	if (!conf->overrides)
 		conf->overrides = alloc_hwe();
@@ -1266,7 +1267,7 @@ overrides_handler(vector strvec)
  * multipaths block handlers
  */
 static int
-multipaths_handler(vector strvec)
+multipaths_handler(struct config *conf, vector strvec)
 {
 	if (!conf->mptable)
 		conf->mptable = vector_alloc();
@@ -1278,7 +1279,7 @@ multipaths_handler(vector strvec)
 }
 
 static int
-multipath_handler(vector strvec)
+multipath_handler(struct config *conf, vector strvec)
 {
 	struct mpentry * mpe;
 
@@ -1307,7 +1308,7 @@ declare_mp_snprint(alias, print_str)
  */
 
 static int
-deprecated_handler(vector strvec)
+deprecated_handler(struct config *conf, vector strvec)
 {
 	char * buff;
 
@@ -1321,7 +1322,7 @@ deprecated_handler(vector strvec)
 }
 
 static int
-snprint_deprecated (char * buff, int len, void * data)
+snprint_deprecated (struct config *conf, char * buff, int len, void * data)
 {
 	return 0;
 }
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 69b7b34..b059f32 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1412,7 +1412,7 @@ get_state (struct path * pp, struct config *conf, int daemon)
 				return PATH_UNCHECKED;
 			}
 		}
-		select_checker(pp);
+		select_checker(conf, pp);
 		if (!checker_selected(c)) {
 			condlog(3, "%s: No checker selected", pp->dev);
 			return PATH_UNCHECKED;
@@ -1452,8 +1452,8 @@ get_prio (struct path * pp)
 	struct prio * p = &pp->prio;
 
 	if (!prio_selected(p)) {
-		select_detect_prio(pp);
-		select_prio(pp);
+		select_detect_prio(conf, pp);
+		select_prio(conf, pp);
 		if (!prio_selected(p)) {
 			condlog(3, "%s: no prio selected", pp->dev);
 			pp->priority = PRIO_UNDEF;
@@ -1520,7 +1520,7 @@ get_uid (struct path * pp, int path_state)
 	ssize_t len = 0;
 
 	if (!pp->uid_attribute && !pp->getuid)
-		select_getuid(pp);
+		select_getuid(conf, pp);
 
 	if (!pp->udev) {
 		condlog(1, "%s: no udev information", pp->dev);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index e4296ee..96bc872 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -20,6 +20,8 @@
 #include <syslog.h>
 #include <errno.h>
 
+#include "vector.h"
+#include "config.h"
 #include "parser.h"
 #include "memory.h"
 #include "debug.h"
@@ -37,8 +39,9 @@ void set_current_keywords (vector *k)
 }
 
 int
-keyword_alloc(vector keywords, char *string, int (*handler) (vector),
-		int (*print) (char *, int, void *), int unique)
+keyword_alloc(vector keywords, char *string,
+	      int (*handler) (struct config *, vector),
+	      int (*print) (struct config *, char *, int, void *), int unique)
 {
 	struct keyword *keyword;
 
@@ -62,7 +65,7 @@ keyword_alloc(vector keywords, char *string, int (*handler) (vector),
 }
 
 int
-install_keyword_root(char *string, int (*handler) (vector))
+install_keyword_root(char *string, int (*handler) (struct config *, vector))
 {
 	int r = keyword_alloc(keywords, string, handler, NULL, 1);
 	if (!r)
@@ -83,8 +86,8 @@ install_sublevel_end(void)
 }
 
 int
-_install_keyword(char *string, int (*handler) (vector),
-		int (*print) (char *, int, void *), int unique)
+_install_keyword(char *string, int (*handler) (struct config *, vector),
+		 int (*print) (struct config *, char *, int, void *), int unique)
 {
 	int i = 0;
 	struct keyword *keyword;
@@ -179,7 +182,7 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw, void *data)
 			fwd += snprintf(buff + fwd, len - fwd, "%s", kw->string);
 			break;
 		case 'v':
-			r = kw->print(buff + fwd, len - fwd, data);
+			r = kw->print(conf, buff + fwd, len - fwd, data);
 			if (!r) { /* no output if no value */
 				buff = '\0';
 				return 0;
@@ -466,7 +469,7 @@ validate_config_strvec(vector strvec, char *file)
 }
 
 static int
-process_stream(FILE *stream, vector keywords, char *file)
+process_stream(struct config *conf, FILE *stream, vector keywords, char *file)
 {
 	int i;
 	int r = 0, t;
@@ -520,7 +523,7 @@ process_stream(FILE *stream, vector keywords, char *file)
 						goto out;
 				}
 				if (keyword->handler) {
-					t = (*keyword->handler) (strvec);
+				    t = (*keyword->handler) (conf, strvec);
 					r += t;
 					if (t)
 						condlog(1, "multipath.conf +%d, parsing failed: %s",
@@ -529,7 +532,7 @@ process_stream(FILE *stream, vector keywords, char *file)
 
 				if (keyword->sub) {
 					kw_level++;
-					r += process_stream(stream,
+					r += process_stream(conf, stream,
 							    keyword->sub, file);
 					kw_level--;
 				}
@@ -562,7 +565,7 @@ int alloc_keywords(void)
 
 /* Data initialization */
 int
-process_file(char *file)
+process_file(struct config *conf, char *file)
 {
 	int r;
 	FILE *stream;
@@ -580,7 +583,7 @@ process_file(char *file)
 
 	/* Stream handling */
 	line_nr = 0;
-	r = process_stream(stream, keywords, file);
+	r = process_stream(conf, stream, keywords, file);
 	fclose(stream);
 	//free_keywords(keywords);
 
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 70697f4..822b2b4 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -33,6 +33,7 @@
 
 /* local includes */
 #include "vector.h"
+#include "config.h"
 
 /* Global definitions */
 #define EOB  "}"
@@ -41,8 +42,8 @@
 /* ketword definition */
 struct keyword {
 	char *string;
-	int (*handler) (vector);
-	int (*print) (char *, int, void *);
+	int (*handler) (struct config *, vector);
+	int (*print) (struct config *, char *, int, void *);
 	vector sub;
 	int unique;
 };
@@ -57,13 +58,14 @@ struct keyword {
 	for (i = 0; i < (k)->sub->allocated && ((p) = (k)->sub->slot[i]); i++)
 
 /* Prototypes */
-extern int keyword_alloc(vector keywords, char *string, int (*handler) (vector),
-			 int (*print) (char *, int, void *), int unique);
-extern int install_keyword_root(char *string, int (*handler) (vector));
+extern int keyword_alloc(vector keywords, char *string,
+			 int (*handler) (struct config *, vector),
+			 int (*print) (struct config *, char *, int, void *), int unique);
+extern int install_keyword_root(char *string, int (*handler) (struct config *, vector));
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
-extern int _install_keyword(char *string, int (*handler) (vector),
-			    int (*print) (char *, int, void *), int unique);
+extern int _install_keyword(char *string, int (*handler) (struct config *, vector),
+			    int (*print) (struct config *, char *, int, void *), int unique);
 #define install_keyword(str, vec, pri) _install_keyword(str, vec, pri, 1)
 #define install_keyword_multi(str, vec, pri) _install_keyword(str, vec, pri, 0)
 extern void dump_keywords(vector keydump, int level);
@@ -71,7 +73,7 @@ extern void free_keywords(vector keywords);
 extern vector alloc_strvec(char *string);
 extern void *set_value(vector strvec);
 extern int alloc_keywords(void);
-extern int process_file(char *conf_file);
+extern int process_file(struct config *conf, char *conf_file);
 extern struct keyword * find_keyword(vector v, char * name);
 void set_current_keywords (vector *k);
 int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 03c7859..fe3902f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -16,11 +16,11 @@
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
-#include "print.h"
 #include "dmparser.h"
 #include "config.h"
 #include "configure.h"
 #include "pgpolicies.h"
+#include "print.h"
 #include "defaults.h"
 #include "parser.h"
 #include "blacklist.h"
@@ -1354,7 +1354,7 @@ out:
 }
 
 extern int
-snprint_defaults (char * buff, int len)
+snprint_defaults (struct config *conf, char * buff, int len)
 {
 	int fwd = 0;
 	int i;
@@ -1436,7 +1436,7 @@ snprint_blacklist_devgroup (char *buff, int len, int *fwd, vector *vec)
 }
 
 extern int
-snprint_blacklist_report (char * buff, int len)
+snprint_blacklist_report (struct config *conf, char * buff, int len)
 {
 	int threshold = MAX_LINE_LEN;
 	int fwd = 0;
@@ -1499,7 +1499,7 @@ snprint_blacklist_report (char * buff, int len)
 }
 
 extern int
-snprint_blacklist (char * buff, int len)
+snprint_blacklist (struct config *conf, char * buff, int len)
 {
 	int i;
 	struct blentry * ble;
@@ -1576,7 +1576,7 @@ snprint_blacklist (char * buff, int len)
 }
 
 extern int
-snprint_blacklist_except (char * buff, int len)
+snprint_blacklist_except (struct config *conf, char * buff, int len)
 {
 	int i;
 	struct blentry * ele;
@@ -1685,7 +1685,7 @@ snprint_status (char * buff, int len, struct vectors *vecs)
 }
 
 extern int
-snprint_devices (char * buff, int len, struct vectors *vecs)
+snprint_devices (struct config *conf, char * buff, int len, struct vectors *vecs)
 {
 	DIR *blkdir;
 	struct dirent *blkdev;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 72758ad..023f520 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -102,13 +102,13 @@ int snprint_multipath_topology_json (char * buff, int len,
 				struct vectors * vecs);
 int snprint_multipath_map_json (char * buff, int len,
 				struct multipath * mpp, int last);
-int snprint_defaults (char *, int);
-int snprint_blacklist (char *, int);
-int snprint_blacklist_except (char *, int);
-int snprint_blacklist_report (char *, int);
+int snprint_defaults (struct config *, char *, int);
+int snprint_blacklist (struct config *, char *, int);
+int snprint_blacklist_except (struct config *, char *, int);
+int snprint_blacklist_report (struct config *, char *, int);
 int snprint_wildcards (char *, int);
 int snprint_status (char *, int, struct vectors *);
-int snprint_devices (char *, int, struct vectors *);
+int snprint_devices (struct config *, char *, int, struct vectors *);
 int snprint_hwtable (char *, int, vector);
 int snprint_mptable (char *, int, vector);
 int snprint_overrides (char *, int, struct hwentry *);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 28e7414..beb0798 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -82,7 +82,7 @@ do_attr_set(var, mp->mpe, shift, "(LUN setting)")
 do_attr_set(var, conf, shift, "(config file default)")
 
 extern int
-select_mode (struct multipath *mp)
+select_mode (struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
@@ -96,7 +96,7 @@ out:
 }
 
 extern int
-select_uid (struct multipath *mp)
+select_uid (struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
@@ -110,7 +110,7 @@ out:
 }
 
 extern int
-select_gid (struct multipath *mp)
+select_gid (struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
@@ -129,7 +129,7 @@ out:
  * stop at first explicit setting found
  */
 extern int
-select_rr_weight (struct multipath * mp)
+select_rr_weight (struct config *conf, struct multipath * mp)
 {
 	char *origin, buff[13];
 
@@ -145,7 +145,7 @@ out:
 }
 
 extern int
-select_pgfailback (struct multipath * mp)
+select_pgfailback (struct config *conf, struct multipath * mp)
 {
 	char *origin, buff[13];
 
@@ -161,7 +161,7 @@ out:
 }
 
 extern int
-select_pgpolicy (struct multipath * mp)
+select_pgpolicy (struct config *conf, struct multipath * mp)
 {
 	char *origin, buff[POLICY_NAME_SIZE];
 
@@ -183,7 +183,7 @@ out:
 }
 
 extern int
-select_selector (struct multipath * mp)
+select_selector (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -200,7 +200,7 @@ out:
 }
 
 static void
-select_alias_prefix (struct multipath * mp)
+select_alias_prefix (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -214,7 +214,7 @@ out:
 }
 
 static int
-want_user_friendly_names(struct multipath * mp)
+want_user_friendly_names(struct config *conf, struct multipath * mp)
 {
 
 	char *origin;
@@ -237,7 +237,7 @@ out:
 }
 
 extern int
-select_alias (struct multipath * mp)
+select_alias (struct config *conf, struct multipath * mp)
 {
 	char *origin = NULL;
 
@@ -248,10 +248,10 @@ select_alias (struct multipath * mp)
 	}
 
 	mp->alias = NULL;
-	if (!want_user_friendly_names(mp))
+	if (!want_user_friendly_names(conf, mp))
 		goto out;
 
-	select_alias_prefix(mp);
+	select_alias_prefix(conf, mp);
 
 	if (strlen(mp->alias_old) > 0) {
 		mp->alias = use_existing_alias(mp->wwid, conf->bindings_file,
@@ -277,7 +277,7 @@ out:
 }
 
 extern int
-select_features (struct multipath * mp)
+select_features (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -303,7 +303,7 @@ out:
 }
 
 extern int
-select_hwhandler (struct multipath * mp)
+select_hwhandler (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -318,7 +318,7 @@ out:
 }
 
 extern int
-select_checker(struct path *pp)
+select_checker(struct config *conf, struct path *pp)
 {
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
@@ -347,7 +347,7 @@ out:
 }
 
 extern int
-select_getuid (struct path * pp)
+select_getuid (struct config *conf, struct path * pp)
 {
 	char *origin;
 
@@ -369,7 +369,7 @@ out:
 }
 
 void
-detect_prio(struct path * pp)
+detect_prio(struct config *conf, struct path * pp)
 {
 	int ret;
 	struct prio *p = &pp->prio;
@@ -387,24 +387,24 @@ detect_prio(struct path * pp)
 	prio_get(conf->multipath_dir, p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
 
-#define set_prio(dir, src, msg)						\
+#define set_prio(dir, src, msg)					\
 do {									\
 	if (src && src->prio_name) {					\
-		prio_get(dir, p, src->prio_name, src->prio_args); \
+		prio_get(dir, p, src->prio_name, src->prio_args);	\
 		origin = msg;						\
 		goto out;						\
 	}								\
 } while(0)
 
 extern int
-select_prio (struct path * pp)
+select_prio (struct config *conf, struct path * pp)
 {
 	char *origin;
 	struct mpentry * mpe;
 	struct prio * p = &pp->prio;
 
 	if (pp->detect_prio == DETECT_PRIO_ON) {
-		detect_prio(pp);
+		detect_prio(conf, pp);
 		if (prio_selected(p)) {
 			origin = "(detected setting)";
 			goto out;
@@ -435,7 +435,7 @@ out:
 }
 
 extern int
-select_no_path_retry(struct multipath *mp)
+select_no_path_retry(struct config *conf, struct multipath *mp)
 {
 	char *origin = NULL;
 	char buff[12];
@@ -464,7 +464,7 @@ out:
 }
 
 int
-select_minio_rq (struct multipath * mp)
+select_minio_rq (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -479,7 +479,7 @@ out:
 }
 
 int
-select_minio_bio (struct multipath * mp)
+select_minio_bio (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
@@ -494,18 +494,18 @@ out:
 }
 
 extern int
-select_minio (struct multipath * mp)
+select_minio (struct config *conf, struct multipath * mp)
 {
 	unsigned int minv_dmrq[3] = {1, 1, 0};
 
 	if (VERSION_GE(conf->version, minv_dmrq))
-		return select_minio_rq(mp);
+		return select_minio_rq(conf, mp);
 	else
-		return select_minio_bio(mp);
+		return select_minio_bio(conf, mp);
 }
 
 extern int
-select_fast_io_fail(struct multipath *mp)
+select_fast_io_fail(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
 
@@ -520,7 +520,7 @@ out:
 }
 
 extern int
-select_dev_loss(struct multipath *mp)
+select_dev_loss(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
 
@@ -536,7 +536,7 @@ out:
 }
 
 extern int
-select_flush_on_last_del(struct multipath *mp)
+select_flush_on_last_del(struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
@@ -554,7 +554,7 @@ out:
 }
 
 extern int
-select_reservation_key (struct multipath * mp)
+select_reservation_key (struct config *conf, struct multipath * mp)
 {
 	char *origin, buff[12];
 
@@ -569,7 +569,7 @@ out:
 }
 
 extern int
-select_retain_hwhandler (struct multipath * mp)
+select_retain_hwhandler (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 	unsigned int minv_dm_retain[3] = {1, 5, 0};
@@ -591,7 +591,7 @@ out:
 }
 
 extern int
-select_detect_prio (struct path * pp)
+select_detect_prio (struct config *conf, struct path * pp)
 {
 	char *origin;
 
@@ -606,7 +606,7 @@ out:
 }
 
 extern int
-select_deferred_remove (struct multipath *mp)
+select_deferred_remove (struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
@@ -632,7 +632,7 @@ out:
 }
 
 extern int
-select_delay_watch_checks(struct multipath *mp)
+select_delay_watch_checks(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
 
@@ -648,7 +648,7 @@ out:
 }
 
 extern int
-select_delay_wait_checks(struct multipath *mp)
+select_delay_wait_checks(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
 
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index f9598e7..5941a5f 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -1,24 +1,24 @@
-int select_rr_weight (struct multipath * mp);
-int select_pgfailback (struct multipath * mp);
-int select_pgpolicy (struct multipath * mp);
-int select_selector (struct multipath * mp);
-int select_alias (struct multipath * mp);
-int select_features (struct multipath * mp);
-int select_hwhandler (struct multipath * mp);
-int select_checker(struct path *pp);
-int select_getuid (struct path * pp);
-int select_prio (struct path * pp);
-int select_no_path_retry(struct multipath *mp);
-int select_flush_on_last_del(struct multipath *mp);
-int select_minio(struct multipath *mp);
-int select_mode(struct multipath *mp);
-int select_uid(struct multipath *mp);
-int select_gid(struct multipath *mp);
-int select_fast_io_fail(struct multipath *mp);
-int select_dev_loss(struct multipath *mp);
-int select_reservation_key(struct multipath *mp);
-int select_retain_hwhandler (struct multipath * mp);
-int select_detect_prio(struct path * pp);
-int select_deferred_remove(struct multipath *mp);
-int select_delay_watch_checks (struct multipath * mp);
-int select_delay_wait_checks (struct multipath * mp);
+int select_rr_weight (struct config *conf, struct multipath * mp);
+int select_pgfailback (struct config *conf, struct multipath * mp);
+int select_pgpolicy (struct config *conf, struct multipath * mp);
+int select_selector (struct config *conf, struct multipath * mp);
+int select_alias (struct config *conf, struct multipath * mp);
+int select_features (struct config *conf, struct multipath * mp);
+int select_hwhandler (struct config *conf, struct multipath * mp);
+int select_checker(struct config *conf, struct path *pp);
+int select_getuid (struct config *conf, struct path * pp);
+int select_prio (struct config *conf, struct path * pp);
+int select_no_path_retry(struct config *conf, struct multipath *mp);
+int select_flush_on_last_del(struct config *conf, struct multipath *mp);
+int select_minio(struct config *conf, struct multipath *mp);
+int select_mode(struct config *conf, struct multipath *mp);
+int select_uid(struct config *conf, struct multipath *mp);
+int select_gid(struct config *conf, struct multipath *mp);
+int select_fast_io_fail(struct config *conf, struct multipath *mp);
+int select_dev_loss(struct config *conf, struct multipath *mp);
+int select_reservation_key(struct config *conf, struct multipath *mp);
+int select_retain_hwhandler (struct config *conf, struct multipath * mp);
+int select_detect_prio(struct config *conf, struct path * pp);
+int select_deferred_remove(struct config *conf, struct multipath *mp);
+int select_delay_watch_checks (struct config *conf, struct multipath * mp);
+int select_delay_wait_checks (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index dee6447..74db124 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -6,13 +6,13 @@
 #include "vector.h"
 #include "defaults.h"
 #include "debug.h"
+#include "config.h"
 #include "structs.h"
 #include "structs_vec.h"
 #include "sysfs.h"
 #include "waiter.h"
 #include "devmapper.h"
 #include "dmparser.h"
-#include "config.h"
 #include "propsel.h"
 #include "discovery.h"
 #include "prio.h"
@@ -337,11 +337,11 @@ update_multipath_strings (struct multipath *mpp, vector pathvec, int is_daemon)
 }
 
 extern void
-set_no_path_retry(struct multipath *mpp)
+set_no_path_retry(struct config *conf, struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	select_no_path_retry(mpp);
+	select_no_path_retry(conf, mpp);
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
@@ -396,10 +396,10 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 			mpp->alias);
 	}
 	if (reset) {
-		select_rr_weight(mpp);
-		select_pgfailback(mpp);
-		set_no_path_retry(mpp);
-		select_flush_on_last_del(mpp);
+		select_rr_weight(conf, mpp);
+		select_pgfailback(conf, mpp);
+		set_no_path_retry(conf, mpp);
+		select_flush_on_last_del(conf, mpp);
 		if (VECTOR_SIZE(mpp->paths) != 0)
 			dm_cancel_deferred_remove(mpp);
 	}
@@ -475,7 +475,7 @@ add_map_with_path (struct vectors * vecs,
 
 	strcpy(mpp->wwid, pp->wwid);
 	find_existing_alias(mpp, vecs);
-	if (select_alias(mpp))
+	if (select_alias(conf, mpp))
 		goto out;
 	mpp->size = pp->size;
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index c8e78b5..8ef547d 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -1,6 +1,8 @@
 #ifndef _STRUCTS_VEC_H
 #define _STRUCTS_VEC_H
 
+#include "vector.h"
+#include "config.h"
 #include "lock.h"
 /*
 struct mutex_lock {
@@ -13,7 +15,7 @@ struct vectors {
 	vector mpvec;
 };
 
-void set_no_path_retry(struct multipath *mpp);
+void set_no_path_retry(struct config *conf, struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_paths (vector pathvec, struct multipath * mpp);
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 6937034..219876b 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -13,6 +13,7 @@
 #include "vector.h"
 #include "memory.h"
 #include "checkers.h"
+#include "config.h"
 #include "structs.h"
 #include "structs_vec.h"
 #include "devmapper.h"
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index b80d3bc..5194511 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -5,6 +5,7 @@
 #include <fcntl.h>
 #include <checkers.h>
 #include <vector.h>
+#include <config.h>
 #include <structs.h>
 #include <getopt.h>
 #include <libudev.h>
diff --git a/multipath/main.c b/multipath/main.c
index a6f593f..0d95572 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -38,11 +38,11 @@
 #include <devmapper.h>
 #include <util.h>
 #include <defaults.h>
+#include <config.h>
 #include <structs.h>
 #include <structs_vec.h>
 #include <dmparser.h>
 #include <sysfs.h>
-#include <config.h>
 #include <blacklist.h>
 #include <discovery.h>
 #include <debug.h>
@@ -395,7 +395,7 @@ out:
 }
 
 static int
-dump_config (void)
+dump_config (struct config *conf)
 {
 	char * c, * tmp = NULL;
 	char * reply;
@@ -411,19 +411,19 @@ dump_config (void)
 			return 1;
 		}
 		c = tmp = reply;
-		c += snprint_defaults(c, reply + maxlen - c);
+		c += snprint_defaults(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		if (again) {
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
-		c += snprint_blacklist(c, reply + maxlen - c);
+		c += snprint_blacklist(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		if (again) {
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
-		c += snprint_blacklist_except(c, reply + maxlen - c);
+		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		if (again) {
 			reply = REALLOC(reply, maxlen *= 2);
@@ -549,7 +549,7 @@ main (int argc, char *argv[])
 			conf->ignore_wwids = 1;
 			break;
 		case 't':
-			r = dump_config();
+			r = dump_config(conf);
 			goto out_free_config;
 		case 'h':
 			usage(argv[0]);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 90259ae..36c77da 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -233,17 +233,17 @@ show_config (char ** r, int * len)
 		if (!reply)
 			return 1;
 		c = reply;
-		c += snprint_defaults(c, reply + maxlen - c);
+		c += snprint_defaults(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
 			continue;
-		c += snprint_blacklist(c, reply + maxlen - c);
+		c += snprint_blacklist(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
 			continue;
-		c += snprint_blacklist_except(c, reply + maxlen - c);
+		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 		if (again)
@@ -1162,7 +1162,7 @@ show_blacklist (char ** r, int * len)
 			return 1;
 
 		c = reply;
-		c += snprint_blacklist_report(c, maxlen);
+		c += snprint_blacklist_report(conf, c, maxlen);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -1196,7 +1196,7 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 			return 1;
 
 		c = reply;
-		c += snprint_devices(c, maxlen, vecs);
+		c += snprint_devices(conf, c, maxlen, vecs);
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index f0caca5..66388f8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -21,8 +21,6 @@
 #include <systemd/sd-daemon.h>
 #endif
 #include <semaphore.h>
-#include <mpath_cmd.h>
-#include <mpath_persist.h>
 #include <time.h>
 
 /*
@@ -65,6 +63,10 @@ int uxsock_timeout;
 #include <pgpolicies.h>
 #include <uevent.h>
 #include <log.h>
+
+#include <mpath_cmd.h>
+#include <mpath_persist.h>
+
 #include "prioritizers/alua_rtpg.h"
 
 #include "main.h"
-- 
2.6.6
