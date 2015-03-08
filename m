From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 11/15] multipath: enable configuration directory
Date: Sat,  7 Mar 2015 21:31:42 -0600
Message-ID: <1425785506-20419-12-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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

Users who setup multipath on many machines sometimes want a core
configuration file that stays the same on all machines, and also secondary
configuration files that are unique to each machine to set blacklists and
aliases.  This patch enables this by adding a new configuration option,
"config_dir", which defaults to "/etc/multipath/conf.d". If this is set,
multipath will check this directory for files ending in .conf, and apply
them on top of the initial configuration file in alphabetical order.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      | 62 +++++++++++++++++++++++++++++++++---
 libmultipath/config.h      |  2 ++
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        | 49 ++++++++++++++++++++---------
 libmultipath/parser.c      | 78 ++++++++++++++++++++++++----------------------
 libmultipath/parser.h      |  3 +-
 multipath.conf.annotated   | 10 ++++++
 multipath.conf.defaults    |  1 +
 multipath/multipath.conf.5 |  7 +++++
 9 files changed, 155 insertions(+), 58 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index d4a5e10..c36e9db 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -6,6 +6,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <libudev.h>
+#include <dirent.h>
+#include <limits.h>
+#include <errno.h>
 
 #include "checkers.h"
 #include "memory.h"
@@ -499,6 +502,7 @@ free_config (struct config * conf)
 
 	if (conf->wwids_file)
 		FREE(conf->wwids_file);
+
 	if (conf->prio_name)
 		FREE(conf->prio_name);
 
@@ -512,6 +516,10 @@ free_config (struct config * conf)
 
 	if (conf->checker_name)
 		FREE(conf->checker_name);
+
+	if (conf->config_dir)
+		FREE(conf->config_dir);
+
 	if (conf->reservation_key)
 		FREE(conf->reservation_key);
 
@@ -532,6 +540,43 @@ free_config (struct config * conf)
 	FREE(conf);
 }
 
+/* if multipath fails to process the config directory, it should continue,
+ * with just a warning message */
+static void
+process_config_dir(vector keywords, char *dir)
+{
+	struct dirent **namelist;
+	int i, n;
+	char path[LINE_MAX];
+	int old_hwtable_size;
+
+	if (dir[0] != '/') {
+		condlog(1, "config_dir '%s' must be a fully qualified path",
+			dir);
+		return;
+	}
+	n = scandir(dir, &namelist, NULL, alphasort);
+	if (n < 0) {
+		if (errno == ENOENT)
+			condlog(3, "No configuration dir '%s'", dir);
+		else
+			condlog(0, "couldn't open configuration dir '%s': %s",
+				dir, strerror(errno));
+		return;
+	}
+	for (i = 0; i < n; i++) {
+		if (!strstr(namelist[i]->d_name, ".conf"))
+			continue;
+		old_hwtable_size = VECTOR_SIZE(conf->hwtable);
+		snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]->d_name);
+		path[LINE_MAX-1] = '\0';
+		process_file(path);
+		if (VECTOR_SIZE(conf->hwtable) > old_hwtable_size)
+			factorize_hwtable(conf->hwtable, old_hwtable_size);
+
+	}
+}
+
 int
 load_config (char * file, struct udev *udev)
 {
@@ -568,6 +613,7 @@ load_config (char * file, struct udev *udev)
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
 	conf->force_sync = 0;
 	conf->partition_delim = NULL;
+	conf->processed_main_config = 0;
 
 	/*
 	 * preload default hwtable
@@ -586,11 +632,12 @@ load_config (char * file, struct udev *udev)
 	 */
 	set_current_keywords(&conf->keywords);
 	alloc_keywords();
+	init_keywords();
 	if (filepresent(file)) {
 		int builtin_hwtable_size;
 
 		builtin_hwtable_size = VECTOR_SIZE(conf->hwtable);
-		if (init_data(file, init_keywords)) {
+		if (process_file(file)) {
 			condlog(0, "error parsing config file");
 			goto out;
 		}
@@ -602,14 +649,19 @@ load_config (char * file, struct udev *udev)
 			factorize_hwtable(conf->hwtable, builtin_hwtable_size);
 		}
 
-	} else {
-		init_keywords();
 	}
-	if (conf->max_checkint == 0)
-		conf->max_checkint = MAX_CHECKINT(conf->checkint);
+
+	conf->processed_main_config = 1;
+	if (conf->config_dir == NULL)
+		conf->config_dir = set_default(DEFAULT_CONFIG_DIR);
+	if (conf->config_dir && conf->config_dir[0] != '\0')
+		process_config_dir(conf->keywords, conf->config_dir);
+
 	/*
 	 * fill the voids left in the config file
 	 */
+	if (conf->max_checkint == 0)
+		conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	if (conf->blist_devnode == NULL) {
 		conf->blist_devnode = vector_alloc();
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index bc3fe53..cb3be62 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -127,6 +127,7 @@ struct config {
 	int detect_prio;
 	int force_sync;
 	int deferred_remove;
+	int processed_main_config;
 	unsigned int version[3];
 
 	char * dev;
@@ -144,6 +145,7 @@ struct config {
 	char * checker_name;
 	char * alias_prefix;
 	char * partition_delim;
+	char * config_dir;
 	unsigned char * reservation_key;
 
 	vector keywords;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index ccf1ebe..a7f1c11 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -27,5 +27,6 @@
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
+#define DEFAULT_CONFIG_DIR	"/etc/multipath/conf.d"
 
 char * set_default (char * str);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0f0ac05..7350231 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -38,6 +38,9 @@ static int
 set_str(vector strvec, void *ptr)
 {
 	char **str_ptr = (char **)ptr;
+
+	if (*str_ptr)
+		FREE(*str_ptr);
 	*str_ptr = set_value(strvec);
 
 	if (!*str_ptr)
@@ -383,6 +386,16 @@ declare_hw_snprint(deferred_remove, print_yes_no_undef)
 declare_mp_handler(deferred_remove, set_yes_no_undef)
 declare_mp_snprint(deferred_remove, print_yes_no_undef)
 
+static int
+def_config_dir_handler(vector strvec)
+{
+	/* this is only valid in the main config file */
+	if (conf->processed_main_config)
+		return 0;
+	return set_str(strvec, &conf->config_dir);
+}
+declare_def_snprint(config_dir, print_str)
+
 #define declare_def_attr_handler(option, function)			\
 static int								\
 def_ ## option ## _handler (vector strvec)				\
@@ -972,10 +985,14 @@ declare_mp_snprint(reservation_key, print_reservation_key)
 static int
 blacklist_handler(vector strvec)
 {
-	conf->blist_devnode = vector_alloc();
-	conf->blist_wwid = vector_alloc();
-	conf->blist_device = vector_alloc();
-	conf->blist_property = vector_alloc();
+	if (!conf->blist_devnode)
+		conf->blist_devnode = vector_alloc();
+	if (!conf->blist_wwid)
+		conf->blist_wwid = vector_alloc();
+	if (!conf->blist_device)
+		conf->blist_device = vector_alloc();
+	if (!conf->blist_property)
+		conf->blist_property = vector_alloc();
 
 	if (!conf->blist_devnode || !conf->blist_wwid ||
 	    !conf->blist_device || !conf->blist_property)
@@ -987,10 +1004,14 @@ blacklist_handler(vector strvec)
 static int
 blacklist_exceptions_handler(vector strvec)
 {
-	conf->elist_devnode = vector_alloc();
-	conf->elist_wwid = vector_alloc();
-	conf->elist_device = vector_alloc();
-	conf->elist_property = vector_alloc();
+	if (!conf->elist_devnode)
+		conf->elist_devnode = vector_alloc();
+	if (!conf->elist_wwid)
+		conf->elist_wwid = vector_alloc();
+	if (!conf->elist_device)
+		conf->elist_device = vector_alloc();
+	if (!conf->elist_property)
+		conf->elist_property = vector_alloc();
 
 	if (!conf->elist_devnode || !conf->elist_wwid ||
 	    !conf->elist_device || !conf->elist_property)
@@ -1134,14 +1155,12 @@ declare_hw_snprint(hwhandler, print_str)
 static int
 overrides_handler(vector strvec)
 {
-	struct hwentry * overrides;
+	if (!conf->overrides)
+		conf->overrides = alloc_hwe();
 
-	overrides = alloc_hwe();
-
-	if (!overrides)
+	if (!conf->overrides)
 		return 1;
 
-	conf->overrides = overrides;
 	return 0;
 }
 
@@ -1153,7 +1172,8 @@ overrides_handler(vector strvec)
 static int
 multipaths_handler(vector strvec)
 {
-	conf->mptable = vector_alloc();
+	if (!conf->mptable)
+		conf->mptable = vector_alloc();
 
 	if (!conf->mptable)
 		return 1;
@@ -1256,6 +1276,7 @@ init_keywords(void)
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
 	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
+	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 00cbef8..d351ab2 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -18,6 +18,7 @@
  */
 
 #include <syslog.h>
+#include <errno.h>
 
 #include "parser.h"
 #include "memory.h"
@@ -445,14 +446,15 @@ set_value(vector strvec)
 /* non-recursive configuration stream handler */
 static int kw_level = 0;
 
-int warn_on_duplicates(vector uniques, char *str)
+int warn_on_duplicates(vector uniques, char *str, char *file)
 {
 	char *tmp;
 	int i;
 
 	vector_foreach_slot(uniques, tmp, i) {
 		if (!strcmp(str, tmp)) {
-			condlog(1, "multipath.conf line %d, duplicate keyword: %s", line_nr, str);
+			condlog(1, "%s line %d, duplicate keyword: %s",
+				file, line_nr, str);
 			return 0;
 		}
 	}
@@ -488,65 +490,70 @@ is_sublevel_keyword(char *str)
 }
 
 int
-validate_config_strvec(vector strvec)
+validate_config_strvec(vector strvec, char *file)
 {
 	char *str;
 	int i;
 
 	str = VECTOR_SLOT(strvec, 0);
 	if (str == NULL) {
-		condlog(0, "can't parse option on line %d of config file",
-			line_nr);
+		condlog(0, "can't parse option on line %d of %s",
+			line_nr, file);
 	return -1;
 	}
 	if (*str == '}') {
 		if (VECTOR_SIZE(strvec) > 1)
-			condlog(0, "ignoring extra data starting with '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, 1), line_nr);
+			condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, 1), line_nr, file);
 		return 0;
 	}
 	if (*str == '{') {
-		condlog(0, "invalid keyword '%s' on line %d of config file", str, line_nr);
+		condlog(0, "invalid keyword '%s' on line %d of %s",
+			str, line_nr, file);
 		return -1;
 	}
 	if (is_sublevel_keyword(str)) {
 		str = VECTOR_SLOT(strvec, 1);
 		if (str == NULL)
-			condlog(0, "missing '{' on line %d of config file", line_nr);
+			condlog(0, "missing '{' on line %d of %s",
+				line_nr, file);
 		else if (*str != '{')
-			condlog(0, "expecting '{' on line %d of config file. found '%s'", line_nr, str);
+			condlog(0, "expecting '{' on line %d of %s. found '%s'",
+				line_nr, file, str);
 		else if (VECTOR_SIZE(strvec) > 2)
-			condlog(0, "ignoring extra data starting with '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, 2), line_nr);
+			condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, 2), line_nr, file);
 		return 0;
 	}
 	str = VECTOR_SLOT(strvec, 1);
 	if (str == NULL) {
-		condlog(0, "missing value for option '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, 0), line_nr);
+		condlog(0, "missing value for option '%s' on line %d of %s",
+			(char *)VECTOR_SLOT(strvec, 0), line_nr, file);
 		return -1;
 	}
 	if (*str != '"') {
 		if (VECTOR_SIZE(strvec) > 2)
-			condlog(0, "ignoring extra data starting with '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, 2), line_nr);
+			condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, 2), line_nr, file);
 		return 0;
 	}
 	for (i = 2; i < VECTOR_SIZE(strvec); i++) {
 		str = VECTOR_SLOT(strvec, i);
 		if (str == NULL) {
-			condlog(0, "can't parse value on line %d of config file", line_nr);
+			condlog(0, "can't parse value on line %d of %s",
+				line_nr, file);
 			return -1;
 		}
 		if (*str == '"') {
 			if (VECTOR_SIZE(strvec) > i + 1)
-				condlog(0, "ignoring extra data starting with '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, (i + 1)), line_nr);
+				condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, (i + 1)), line_nr, file);
 			return 0;
 		}
 	}
-	condlog(0, "missing closing quotes on line %d of config file",
-		line_nr);
+	condlog(0, "missing closing quotes on line %d of %s",
+		line_nr, file);
 	return 0;
 }
 
-int
-process_stream(vector keywords)
+static int
+process_stream(vector keywords, char *file)
 {
 	int i;
 	int r = 0, t;
@@ -573,7 +580,7 @@ process_stream(vector keywords)
 		if (!strvec)
 			continue;
 
-		if (validate_config_strvec(strvec) != 0) {
+		if (validate_config_strvec(strvec, file) != 0) {
 			free_strvec(strvec);
 			continue;
 		}
@@ -585,8 +592,8 @@ process_stream(vector keywords)
 				free_strvec(strvec);
 				break;
 			}
-			condlog(0, "unmatched '%s' at line %d of config file",
-				EOB, line_nr);
+			condlog(0, "unmatched '%s' at line %d of %s",
+				EOB, line_nr, file);
 		}
 
 		for (i = 0; i < VECTOR_SIZE(keywords); i++) {
@@ -594,7 +601,7 @@ process_stream(vector keywords)
 
 			if (!strcmp(keyword->string, str)) {
 				if (keyword->unique &&
-				    warn_on_duplicates(uniques, str)) {
+				    warn_on_duplicates(uniques, str, file)) {
 						r = 1;
 						free_strvec(strvec);
 						goto out;
@@ -609,15 +616,15 @@ process_stream(vector keywords)
 
 				if (keyword->sub) {
 					kw_level++;
-					r += process_stream(keyword->sub);
+					r += process_stream(keyword->sub, file);
 					kw_level--;
 				}
 				break;
 			}
 		}
 		if (i >= VECTOR_SIZE(keywords))
-			condlog(1, "multipath.conf +%d, invalid keyword: %s",
-				line_nr, str);
+			condlog(1, "%s line %d, invalid keyword: %s",
+				file, line_nr, str);
 
 		free_strvec(strvec);
 	}
@@ -641,27 +648,24 @@ int alloc_keywords(void)
 
 /* Data initialization */
 int
-init_data(char *conf_file, void (*init_keywords) (void))
+process_file(char *file)
 {
 	int r;
 
-	stream = fopen(conf_file, "r");
+	if (!keywords) {
+		condlog(0, "No keywords alocated");
+		return 1;
+	}
+	stream = fopen(file, "r");
 	if (!stream) {
-		syslog(LOG_WARNING, "Configuration file open problem");
+		condlog(0, "couldn't open configuration file '%s': %s",
+			file, strerror(errno));
 		return 1;
 	}
 
-	/* Init Keywords structure */
-	(*init_keywords) ();
-
-/* Dump configuration *
-  vector_dump(keywords);
-  dump_keywords(keywords, 0);
-*/
-
 	/* Stream handling */
 	line_nr = 0;
-	r = process_stream(keywords);
+	r = process_stream(keywords, file);
 	fclose(stream);
 	//free_keywords(keywords);
 
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 8bf1c76..bfbb3ae 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -76,9 +76,8 @@ extern int read_line(char *buf, int size);
 extern vector read_value_block(void);
 extern int alloc_value_block(vector strvec, void (*alloc_func) (vector));
 extern void *set_value(vector strvec);
-extern int process_stream(vector keywords);
 extern int alloc_keywords(void);
-extern int init_data(char *conf_file, void (*init_keywords) (void));
+extern int process_file(char *conf_file);
 extern struct keyword * find_keyword(vector v, char * name);
 void set_current_keywords (vector *k);
 int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 71afc0a..2b148ac 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -304,6 +304,16 @@
 #	# values  : yes|no
 #	# default : no
 #	force_sync yes
+#
+#	#
+#	# name    : config_dir
+#	# scope   : multipath & multipathd
+#	# desc    : If not set to an empty string, multipath will search
+#	#           this directory alphabetically for files ending in ".conf"
+#	#           and it will read configuration information from these
+#	#           files, just as if it was in /etc/multipath.conf
+#	# values  : "" or a fully qualified pathname
+#	# default : "/etc/multipath/conf.d"
 #}
 #	
 ##
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 5e46fd8..9244f71 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -26,6 +26,7 @@
 #	log_checker_err always
 #	retain_attached_hw_handler no
 #	detect_prio no
+#	config_dir "/etc/multipath/conf.d"
 #}
 #blacklist {
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b9858a1..4eb238d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -432,6 +432,13 @@ still in use, it will be freed when the last user closes it.  If path is added
 to the multipath device before the last user closes it, the deferred remove
 will be canceled. Default is
 .I no
+.TP
+.B config_dir
+If set to anything other than "", multipath will search this directory
+alphabetically for file ending in ".conf" and it will read configuration
+information from them, just as if it was in /etc/multipath.conf.  config_dir
+must either be "" or a fully qualified directory name. Default is
+.I "/etc/multipath/conf.d"
 .
 .SH "blacklist section"
 The
-- 
1.8.3.1
