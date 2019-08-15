From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] multipath.conf: add "enable_foreign"
	parameter
Date: Thu, 15 Aug 2019 14:46:54 +0000
Message-ID: <20190815144638.5664-2-martin.wilck@suse.com>
References: <20190815144638.5664-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190815144638.5664-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This new configuration parameter can be used to selectively
enable foreign libraries. The value is a regular expression,
against which foreign library names such as "nvme" are matched.
By setting this to a value that matches no foreign library
(e.g. "^$" or "NONE"), foreign code is completely disabled.
By default, all available foreign libraries are loaded.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h   |  1 +
 libmultipath/defaults.h |  2 ++
 libmultipath/dict.c     |  6 +++++
 libmultipath/foreign.c  | 53 +++++++++++++++++++++++++++++++++++++----
 libmultipath/foreign.h  |  3 ++-
 multipath/main.c        |  2 +-
 multipathd/main.c       |  2 +-
 7 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index ff2b4e86..36e99196 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -224,6 +224,7 @@ struct config {
 	vector elist_device;
 	vector elist_property;
 	vector elist_protocol;
+	char *enable_foreign;
 };
 
 extern struct udev * udev;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index decc9335..4dfe007c 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -48,6 +48,8 @@
 #define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
+/* Enable all foreign libraries by default */
+#define DEFAULT_ENABLE_FOREIGN ""
 
 #define CHECKINT_UNDEF		(~0U)
 #define DEFAULT_CHECKINT	5
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c6eba0f6..9f282c3f 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -610,6 +610,10 @@ declare_def_handler(find_multipaths_timeout, set_int)
 declare_def_snprint_defint(find_multipaths_timeout, print_int,
 			   DEFAULT_FIND_MULTIPATHS_TIMEOUT)
 
+declare_def_handler(enable_foreign, set_str)
+declare_def_snprint_defstr(enable_foreign, print_str,
+			   DEFAULT_ENABLE_FOREIGN)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1710,6 +1714,8 @@ init_keywords(vector keywords)
 	install_keyword("find_multipaths_timeout",
 			&def_find_multipaths_timeout_handler,
 			&snprint_def_find_multipaths_timeout);
+	install_keyword("enable_foreign", &def_enable_foreign_handler,
+			&snprint_def_enable_foreign);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 48e8d247..4b34e141 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -16,6 +16,7 @@
 */
 
 #include <sys/sysmacros.h>
+#include <sys/types.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -25,6 +26,7 @@
 #include <fnmatch.h>
 #include <dlfcn.h>
 #include <libudev.h>
+#include <regex.h>
 #include "vector.h"
 #include "debug.h"
 #include "util.h"
@@ -111,17 +113,45 @@ static int select_foreign_libs(const struct dirent *di)
 	return fnmatch(foreign_pattern, di->d_name, FNM_FILE_NAME) == 0;
 }
 
-static int _init_foreign(const char *multipath_dir)
+static void free_pre(void *arg)
+{
+	regex_t **pre = arg;
+
+	if (pre != NULL && *pre != NULL) {
+		regfree(*pre);
+		free(*pre);
+		*pre = NULL;
+	}
+}
+
+static int _init_foreign(const char *multipath_dir, const char *enable)
 {
 	char pathbuf[PATH_MAX];
 	struct dirent **di;
 	struct scandir_result sr;
 	int r, i;
+	regex_t *enable_re = NULL;
 
 	foreigns = vector_alloc();
 	if (foreigns == NULL)
 		return -ENOMEM;
 
+	pthread_cleanup_push(free_pre, &enable_re);
+	enable_re = calloc(1, sizeof(*enable_re));
+	if (enable_re) {
+		const char *str = enable ? enable : DEFAULT_ENABLE_FOREIGN;
+
+		r = regcomp(enable_re, str, REG_EXTENDED|REG_NOSUB);
+		if (r != 0) {
+			char errbuf[64];
+
+			(void)regerror(r, enable_re, errbuf, sizeof(errbuf));
+			condlog (2, "%s: error compiling enable_foreign = \"%s\": \"%s\"",
+				 __func__, str, errbuf);
+			free_pre(&enable_re);
+		}
+	}
+
 	r = scandir(multipath_dir, &di, select_foreign_libs, alphasort);
 
 	if (r == 0) {
@@ -163,6 +193,20 @@ static int _init_foreign(const char *multipath_dir)
 		memset(fgn, 0, sizeof(*fgn));
 		strlcpy((char*)fgn + offsetof(struct foreign, name), c, namesz);
 
+		if (enable_re != NULL) {
+			int ret = regexec(enable_re, fgn->name, 0, NULL, 0);
+
+			if (ret == REG_NOMATCH) {
+				condlog(3, "%s: foreign library \"%s\" is not enabled",
+					__func__, fgn->name);
+				free(fgn);
+				continue;
+			} else if (ret != 0)
+				/* assume it matches */
+				condlog(2, "%s: error %d in regexec() for %s",
+					__func__, ret, fgn->name);
+		}
+
 		snprintf(pathbuf, sizeof(pathbuf), "%s/%s", multipath_dir, fn);
 		fgn->handle = dlopen(pathbuf, RTLD_NOW|RTLD_LOCAL);
 		msg = dlerror();
@@ -205,11 +249,12 @@ static int _init_foreign(const char *multipath_dir)
 	dl_err:
 		free_foreign(fgn);
 	}
-	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1); /* free_scandir_result */
+	pthread_cleanup_pop(1); /* free_pre */
 	return 0;
 }
 
-int init_foreign(const char *multipath_dir)
+int init_foreign(const char *multipath_dir, const char *enable)
 {
 	int ret;
 
@@ -222,7 +267,7 @@ int init_foreign(const char *multipath_dir)
 	}
 
 	pthread_cleanup_push(unlock_foreigns, NULL);
-	ret = _init_foreign(multipath_dir);
+	ret = _init_foreign(multipath_dir, enable);
 	pthread_cleanup_pop(1);
 
 	return ret;
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 697f12f8..acd33601 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -195,9 +195,10 @@ struct foreign {
  * init_foreign(dir)
  * load and initialize foreign multipath libraries in dir (libforeign-*.so).
  * @param dir: directory to search
+ * @param enable: regex to match foreign library name ("*" above) against
  * @returns: 0 on success, negative value on failure.
  */
-int init_foreign(const char *multipath_dir);
+int init_foreign(const char *multipath_dir, const char *enable);
 
 /**
  * cleanup_foreign(dir)
diff --git a/multipath/main.c b/multipath/main.c
index 96a11468..4f4d8e89 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1050,7 +1050,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	/* Failing here is non-fatal */
-	init_foreign(conf->multipath_dir);
+	init_foreign(conf->multipath_dir, conf->enable_foreign);
 	if (cmd == CMD_USABLE_PATHS) {
 		r = check_usable_paths(conf, dev, dev_type) ?
 			RTVL_FAIL : RTVL_OK;
diff --git a/multipathd/main.c b/multipathd/main.c
index 7a5cd115..b5f08617 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2848,7 +2848,7 @@ child (void * param)
 	}
 	/* Failing this is non-fatal */
 
-	init_foreign(conf->multipath_dir);
+	init_foreign(conf->multipath_dir, conf->enable_foreign);
 
 	if (poll_dmevents)
 		poll_dmevents = dmevent_poll_supported();
-- 
2.22.0
