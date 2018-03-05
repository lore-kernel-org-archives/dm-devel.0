From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/23] libmultipath: parser: use call-by-value
	for "snprint" methods
Date: Tue,  6 Mar 2018 00:14:48 +0100
Message-ID: <20180305231507.10386-5-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Convert the snprint methods for all keywords to call-by-value,
and use "const" qualifier for the "data" argument. This makes sure
that "snprint" type functions don't modify the data they're print,
helps compile-time correctness checking, and allows more proper
"const" cleanups in the future.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c   | 206 ++++++++++++++++++++++++--------------------------
 libmultipath/parser.c |   9 ++-
 libmultipath/parser.h |  12 ++-
 3 files changed, 112 insertions(+), 115 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e52f1f798f7a..47dc2a38f1ac 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -92,46 +92,35 @@ set_yes_no_undef(vector strvec, void *ptr)
 }
 
 static int
-print_int (char *buff, int len, void *ptr)
+print_int (char *buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-	return snprintf(buff, len, "%i", *int_ptr);
+	return snprintf(buff, len, "%li", v);
 }
 
 static int
-print_nonzero (char *buff, int len, void *ptr)
+print_nonzero (char *buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-	if (!*int_ptr)
-		return 0;
-	return snprintf(buff, len, "%i", *int_ptr);
+	return snprintf(buff, len, "%li", v);
 }
 
 static int
-print_str (char *buff, int len, void *ptr)
+print_str (char *buff, int len, const char *ptr)
 {
-	char **str_ptr = (char **)ptr;
-	if (!*str_ptr)
-		return 0;
-	return snprintf(buff, len, "\"%s\"", *str_ptr);
+	return snprintf(buff, len, "\"%s\"", ptr);
 }
 
 static int
-print_yes_no (char *buff, int len, void *ptr)
+print_yes_no (char *buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
 	return snprintf(buff, len, "\"%s\"",
-			(*int_ptr == YN_NO)? "no" : "yes");
+			(v == YN_NO)? "no" : "yes");
 }
 
 static int
-print_yes_no_undef (char *buff, int len, void *ptr)
+print_yes_no_undef (char *buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-	if (!*int_ptr)
-		return 0;
 	return snprintf(buff, len, "\"%s\"",
-			(*int_ptr == YNU_NO)? "no" : "yes");
+			(v == YNU_NO)? "no" : "yes");
 }
 
 #define declare_def_handler(option, function)				\
@@ -143,29 +132,32 @@ def_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_def_snprint(option, function)				\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_def_ ## option (struct config *conf, char * buff, int len,	\
+			const void * data)				\
 {									\
-	return function (buff, len, &conf->option);			\
+	return function (buff, len, conf->option);			\
 }
 
 #define declare_def_snprint_defint(option, function, value)		\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_def_ ## option (struct config *conf, char * buff, int len,	\
+			const void * data)				\
 {									\
 	int i = value;							\
 	if (!conf->option)						\
-		return function (buff, len, &i);			\
-	return function (buff, len, &conf->option);			\
+		return function (buff, len, i);				\
+	return function (buff, len, conf->option);			\
 }
 
 #define declare_def_snprint_defstr(option, function, value)		\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_def_ ## option (struct config *conf, char * buff, int len,	\
+			const void * data)				\
 {									\
-	char *s = value;						\
+	static const char *s = value;					\
 	if (!conf->option)						\
-		return function (buff, len, &s);			\
-	return function (buff, len, &conf->option);			\
+		return function (buff, len, s);				\
+	return function (buff, len, conf->option);			\
 }
 
 #define declare_hw_handler(option, function)				\
@@ -180,10 +172,11 @@ hw_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_hw_snprint(option, function)				\
 static int								\
-snprint_hw_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_hw_ ## option (struct config *conf, char * buff, int len,	\
+		       const void * data)				\
 {									\
-	struct hwentry * hwe = (struct hwentry *)data;			\
-	return function (buff, len, &hwe->option);			\
+	const struct hwentry * hwe = (const struct hwentry *)data;	\
+	return function (buff, len, hwe->option);			\
 }
 
 #define declare_ovr_handler(option, function)				\
@@ -197,9 +190,10 @@ ovr_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_ovr_snprint(option, function)				\
 static int								\
-snprint_ovr_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_ovr_ ## option (struct config *conf, char * buff, int len,	\
+			const void * data)				\
 {									\
-	return function (buff, len, &conf->overrides->option);		\
+	return function (buff, len, conf->overrides->option);		\
 }
 
 #define declare_mp_handler(option, function)				\
@@ -214,10 +208,11 @@ mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_mp_snprint(option, function)				\
 static int								\
-snprint_mp_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
+		       const void * data)				\
 {									\
-	struct mpentry * mpe = (struct mpentry *)data;			\
-	return function (buff, len, &mpe->option);			\
+	const struct mpentry * mpe = (const struct mpentry *)data;	\
+	return function (buff, len, mpe->option);			\
 }
 
 declare_def_handler(checkint, set_int)
@@ -328,7 +323,7 @@ declare_mp_snprint(minio_rq, print_nonzero)
 declare_def_handler(queue_without_daemon, set_yes_no)
 static int
 snprint_def_queue_without_daemon (struct config *conf,
-				  char * buff, int len, void * data)
+				  char * buff, int len, const void * data)
 {
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
@@ -459,10 +454,11 @@ def_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_def_attr_snprint(option, function)			\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_def_ ## option (struct config *conf, char * buff, int len,	\
+			const void * data)				\
 {									\
-	return function (buff, len, &conf->option,			\
-			 &conf->attribute_flags);			\
+	return function (buff, len, conf->option,			\
+			 conf->attribute_flags);			\
 }
 
 #define declare_mp_attr_handler(option, function)			\
@@ -477,11 +473,12 @@ mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_mp_attr_snprint(option, function)			\
 static int								\
-snprint_mp_ ## option (struct config *conf, char * buff, int len, void * data) \
+snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
+		       const void * data)				\
 {									\
-	struct mpentry * mpe = (struct mpentry *)data;			\
-	return function (buff, len, &mpe->option,			\
-			 &mpe->attribute_flags);			\
+	const struct mpentry * mpe = (const struct mpentry *)data;	\
+	return function (buff, len, mpe->option,			\
+			 mpe->attribute_flags);				\
 }
 
 static int
@@ -556,30 +553,30 @@ set_gid(vector strvec, void *ptr, int *flags)
 }
 
 static int
-print_mode(char * buff, int len, void *ptr, int *flags)
+print_mode(char * buff, int len, long v, int flags)
 {
-	mode_t *mode_ptr = (mode_t *)ptr;
-	if ((*flags & (1 << ATTR_MODE)) == 0)
+	mode_t mode = (mode_t)v;
+	if ((flags & (1 << ATTR_MODE)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", *mode_ptr);
+	return snprintf(buff, len, "0%o", mode);
 }
 
 static int
-print_uid(char * buff, int len, void *ptr, int *flags)
+print_uid(char * buff, int len, long v, int flags)
 {
-	uid_t *uid_ptr = (uid_t *)ptr;
-	if ((*flags & (1 << ATTR_UID)) == 0)
+	uid_t uid = (uid_t)v;
+	if ((flags & (1 << ATTR_UID)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", *uid_ptr);
+	return snprintf(buff, len, "0%o", uid);
 }
 
 static int
-print_gid(char * buff, int len, void *ptr, int *flags)
+print_gid(char * buff, int len, long v, int flags)
 {
-	gid_t *gid_ptr = (gid_t *)ptr;
-	if ((*flags & (1 << ATTR_GID)) == 0)
+	gid_t gid = (gid_t)v;
+	if ((flags & (1 << ATTR_GID)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", *gid_ptr);
+	return snprintf(buff, len, "0%o", gid);
 }
 
 declare_def_attr_handler(mode, set_mode)
@@ -620,17 +617,15 @@ set_fast_io_fail(vector strvec, void *ptr)
 }
 
 int
-print_fast_io_fail(char * buff, int len, void *ptr)
+print_fast_io_fail(char * buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-
-	if (*int_ptr == MP_FAST_IO_FAIL_UNSET)
+	if (v == MP_FAST_IO_FAIL_UNSET)
 		return 0;
-	if (*int_ptr == MP_FAST_IO_FAIL_OFF)
+	if (v == MP_FAST_IO_FAIL_OFF)
 		return snprintf(buff, len, "\"off\"");
-	if (*int_ptr == MP_FAST_IO_FAIL_ZERO)
+	if (v == MP_FAST_IO_FAIL_ZERO)
 		return snprintf(buff, len, "0");
-	return snprintf(buff, len, "%d", *int_ptr);
+	return snprintf(buff, len, "%ld", v);
 }
 
 declare_def_handler(fast_io_fail, set_fast_io_fail)
@@ -660,15 +655,11 @@ set_dev_loss(vector strvec, void *ptr)
 }
 
 int
-print_dev_loss(char * buff, int len, void *ptr)
+print_dev_loss(char * buff, int len, unsigned long v)
 {
-	unsigned int *uint_ptr = (unsigned int *)ptr;
-
-	if (!*uint_ptr)
-		return 0;
-	if (*uint_ptr >= MAX_DEV_LOSS_TMO)
+	if (v >= MAX_DEV_LOSS_TMO)
 		return snprintf(buff, len, "\"infinity\"");
-	return snprintf(buff, len, "%u", *uint_ptr);
+	return snprintf(buff, len, "%lu", v);
 }
 
 declare_def_handler(dev_loss, set_dev_loss)
@@ -695,10 +686,9 @@ set_pgpolicy(vector strvec, void *ptr)
 }
 
 int
-print_pgpolicy(char * buff, int len, void *ptr)
+print_pgpolicy(char * buff, int len, long pgpolicy)
 {
 	char str[POLICY_NAME_SIZE];
-	int pgpolicy = *(int *)ptr;
 
 	if (!pgpolicy)
 		return 0;
@@ -776,7 +766,7 @@ max_fds_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_max_fds (struct config *conf, char * buff, int len, void * data)
+snprint_max_fds (struct config *conf, char * buff, int len, const void * data)
 {
 	int r = 0, max_fds;
 
@@ -813,15 +803,13 @@ set_rr_weight(vector strvec, void *ptr)
 }
 
 int
-print_rr_weight (char * buff, int len, void *ptr)
+print_rr_weight (char * buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-
-	if (!*int_ptr)
+	if (!v)
 		return 0;
-	if (*int_ptr == RR_WEIGHT_PRIO)
+	if (v == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "\"priorities\"");
-	if (*int_ptr == RR_WEIGHT_NONE)
+	if (v == RR_WEIGHT_NONE)
 		return snprintf(buff, len, "\"uniform\"");
 
 	return 0;
@@ -861,11 +849,9 @@ set_pgfailback(vector strvec, void *ptr)
 }
 
 int
-print_pgfailback (char * buff, int len, void *ptr)
+print_pgfailback (char * buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-
-	switch(*int_ptr) {
+	switch(v) {
 	case  FAILBACK_UNDEF:
 		return 0;
 	case -FAILBACK_MANUAL:
@@ -875,7 +861,7 @@ print_pgfailback (char * buff, int len, void *ptr)
 	case -FAILBACK_FOLLOWOVER:
 		return snprintf(buff, len, "\"followover\"");
 	default:
-		return snprintf(buff, len, "%i", *int_ptr);
+		return snprintf(buff, len, "%li", v);
 	}
 }
 
@@ -910,11 +896,9 @@ set_no_path_retry(vector strvec, void *ptr)
 }
 
 int
-print_no_path_retry(char * buff, int len, void *ptr)
+print_no_path_retry(char * buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-
-	switch(*int_ptr) {
+	switch(v) {
 	case NO_PATH_RETRY_UNDEF:
 		return 0;
 	case NO_PATH_RETRY_FAIL:
@@ -922,7 +906,7 @@ print_no_path_retry(char * buff, int len, void *ptr)
 	case NO_PATH_RETRY_QUEUE:
 		return snprintf(buff, len, "\"queue\"");
 	default:
-		return snprintf(buff, len, "%i", *int_ptr);
+		return snprintf(buff, len, "%li", v);
 	}
 }
 
@@ -955,7 +939,8 @@ def_log_checker_err_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_def_log_checker_err (struct config *conf, char * buff, int len, void * data)
+snprint_def_log_checker_err (struct config *conf, char * buff, int len,
+			     const void * data)
 {
 	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
 		return snprintf(buff, len, "once");
@@ -1008,7 +993,7 @@ def_reservation_key_handler(struct config *conf, vector strvec)
 
 static int
 snprint_def_reservation_key (struct config *conf, char * buff, int len,
-			     void * data)
+			     const void * data)
 {
 	return print_reservation_key(buff, len, conf->reservation_key,
 				     conf->prkey_source);
@@ -1026,9 +1011,9 @@ mp_reservation_key_handler(struct config *conf, vector strvec)
 
 static int
 snprint_mp_reservation_key (struct config *conf, char * buff, int len,
-			     void * data)
+			    const void * data)
 {
-	struct mpentry * mpe = (struct mpentry *)data;
+	const struct mpentry * mpe = (const struct mpentry *)data;
 	return print_reservation_key(buff, len, mpe->reservation_key,
 				     mpe->prkey_source);
 }
@@ -1053,17 +1038,15 @@ set_off_int_undef(vector strvec, void *ptr)
 }
 
 int
-print_off_int_undef(char * buff, int len, void *ptr)
+print_off_int_undef(char * buff, int len, long v)
 {
-	int *int_ptr = (int *)ptr;
-
-	switch(*int_ptr) {
+	switch(v) {
 	case NU_UNDEF:
 		return 0;
 	case NU_NO:
 		return snprintf(buff, len, "\"no\"");
 	default:
-		return snprintf(buff, len, "%i", *int_ptr);
+		return snprintf(buff, len, "%li", v);
 	}
 }
 
@@ -1231,15 +1214,17 @@ declare_ble_handler(blist_property)
 declare_ble_handler(elist_property)
 
 static int
-snprint_def_uxsock_timeout(struct config *conf, char * buff, int len, void * data)
+snprint_def_uxsock_timeout(struct config *conf, char * buff, int len,
+			   const void * data)
 {
 	return snprintf(buff, len, "%u", conf->uxsock_timeout);
 }
 
 static int
-snprint_ble_simple (struct config *conf, char * buff, int len, void * data)
+snprint_ble_simple (struct config *conf, char * buff, int len,
+		    const void * data)
 {
-	struct blentry * ble = (struct blentry *)data;
+	const struct blentry * ble = (const struct blentry *)data;
 
 	return snprintf(buff, len, "\"%s\"", ble->str);
 }
@@ -1262,17 +1247,21 @@ declare_ble_device_handler(product, blist_device, NULL, buff)
 declare_ble_device_handler(product, elist_device, NULL, buff)
 
 static int
-snprint_bled_vendor (struct config *conf, char * buff, int len, void * data)
+snprint_bled_vendor (struct config *conf, char * buff, int len,
+		     const void * data)
 {
-	struct blentry_device * bled = (struct blentry_device *)data;
+	const struct blentry_device * bled =
+		(const struct blentry_device *)data;
 
 	return snprintf(buff, len, "\"%s\"", bled->vendor);
 }
 
 static int
-snprint_bled_product (struct config *conf, char * buff, int len, void * data)
+snprint_bled_product (struct config *conf, char * buff, int len,
+		      const void * data)
 {
-	struct blentry_device * bled = (struct blentry_device *)data;
+	const struct blentry_device * bled =
+		(const struct blentry_device *)data;
 
 	return snprintf(buff, len, "\"%s\"", bled->product);
 }
@@ -1402,7 +1391,8 @@ deprecated_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_deprecated (struct config *conf, char * buff, int len, void * data)
+snprint_deprecated (struct config *conf, char * buff, int len,
+		    const void * data)
 {
 	return 0;
 }
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index c47d891ec369..5caa2019a1a4 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -33,7 +33,8 @@ static int line_nr;
 int
 keyword_alloc(vector keywords, char *string,
 	      int (*handler) (struct config *, vector),
-	      int (*print) (struct config *, char *, int, void *), int unique)
+	      int (*print) (struct config *, char *, int, const void*),
+	      int unique)
 {
 	struct keyword *keyword;
 
@@ -71,7 +72,8 @@ install_sublevel_end(void)
 int
 _install_keyword(vector keywords, char *string,
 		 int (*handler) (struct config *, vector),
-		 int (*print) (struct config *, char *, int, void *), int unique)
+		 int (*print) (struct config *, char *, int, const void*),
+		 int unique)
 {
 	int i = 0;
 	struct keyword *keyword;
@@ -143,7 +145,8 @@ find_keyword(vector keywords, vector v, char * name)
 }
 
 int
-snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw, void *data)
+snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
+		const void *data)
 {
 	int r;
 	int fwd = 0;
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 519b805d4149..0a747507d7be 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -43,7 +43,7 @@
 struct keyword {
 	char *string;
 	int (*handler) (struct config *, vector);
-	int (*print) (struct config *, char *, int, void *);
+	int (*print) (struct config *, char *, int, const void *);
 	vector sub;
 	int unique;
 };
@@ -60,13 +60,17 @@ struct keyword {
 /* Prototypes */
 extern int keyword_alloc(vector keywords, char *string,
 			 int (*handler) (struct config *, vector),
-			 int (*print) (struct config *, char *, int, void *), int unique);
+			 int (*print) (struct config *, char *, int,
+				       const void *),
+			 int unique);
 #define install_keyword_root(str, h) keyword_alloc(keywords, str, h, NULL, 1)
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
 extern int _install_keyword(vector keywords, char *string,
 			    int (*handler) (struct config *, vector),
-			    int (*print) (struct config *, char *, int, void *), int unique);
+			    int (*print) (struct config *, char *, int,
+					  const void *),
+			    int unique);
 #define install_keyword(str, vec, pri) _install_keyword(keywords, str, vec, pri, 1)
 #define install_keyword_multi(str, vec, pri) _install_keyword(keywords, str, vec, pri, 0)
 extern void dump_keywords(vector keydump, int level);
@@ -76,6 +80,6 @@ extern void *set_value(vector strvec);
 extern int process_file(struct config *conf, char *conf_file);
 extern struct keyword * find_keyword(vector keywords, vector v, char * name);
 int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
-		    void *data);
+		    const void *data);
 
 #endif
-- 
2.16.1
