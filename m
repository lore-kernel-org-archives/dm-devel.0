From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Make modules directory configurable
Date: Wed, 30 Apr 2008 11:04:59 +0200
Message-ID: <20080430090459.E0FE418C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


As we know have a separate directory for the various shared
libraries we should make this configurable.
And use that variable a prefix for dlopen() to make that
work correctly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.c |    5 ++++-
 libmultipath/config.c   |   27 ++++++++++++++++-----------
 libmultipath/config.h   |    1 +
 libmultipath/defaults.h |    1 +
 libmultipath/dict.c     |   24 ++++++++++++++++++++++++
 libmultipath/prio.c     |   18 ++++++++++--------
 multipath/main.c        |    6 +++---
 multipathd/main.c       |    5 +++--
 8 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index ff606d0..3aa1f9d 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -5,6 +5,8 @@
 
 #include "debug.h"
 #include "checkers.h"
+#include "vector.h"
+#include "config.h"
 
 static LIST_HEAD(checkers);
 
@@ -61,7 +63,8 @@ struct checker * add_checker (char * name)
 	c = alloc_checker();
 	if (!c)
 		return NULL;
-	snprintf(libname, LIB_CHECKER_NAMELEN, "libcheck%s.so", name);
+	snprintf(libname, LIB_CHECKER_NAMELEN, "%s/libcheck%s.so",
+		 conf->multipath_dir, name);
 	condlog(3, "loading %s checker", libname);
 	handle = dlopen(libname, RTLD_NOW);
 	errstr = dlerror();
diff --git a/libmultipath/config.c b/libmultipath/config.c
index af862b7..4548ad1 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -310,6 +310,9 @@ free_config (struct config * conf)
 	if (conf->udev_dir)
 		FREE(conf->udev_dir);
 
+	if (conf->multipath_dir)
+		FREE(conf->multipath_dir);
+
 	if (conf->selector)
 		FREE(conf->selector);
 
@@ -366,35 +369,37 @@ load_config (char * file)
 			goto out;
 		}
 	}
-	
+
 	/*
 	 * fill the voids left in the config file
 	 */
+	if (conf->multipath_dir == NULL)
+		conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
+
 	if (conf->hwtable == NULL) {
 		conf->hwtable = vector_alloc();
-		
+
 		if (!conf->hwtable)
 			goto out;
-		
 	}
 	if (setup_default_hwtable(conf->hwtable))
 		goto out;
 
 	if (conf->blist_devnode == NULL) {
 		conf->blist_devnode = vector_alloc();
-		
+
 		if (!conf->blist_devnode)
 			goto out;
 	}
 	if (conf->blist_wwid == NULL) {
 		conf->blist_wwid = vector_alloc();
-		
+
 		if (!conf->blist_wwid)
 			goto out;
 	}
 	if (conf->blist_device == NULL) {
 		conf->blist_device = vector_alloc();
-		
+
 		if (!conf->blist_device)
 			goto out;
 	}
@@ -402,21 +407,21 @@ load_config (char * file)
 		goto out;
 
 	if (conf->elist_devnode == NULL) {
-                conf->elist_devnode = vector_alloc();
+		conf->elist_devnode = vector_alloc();
 
-                if (!conf->elist_devnode)
+		if (!conf->elist_devnode)
 			goto out;
 	}
 	if (conf->elist_wwid == NULL) {
 		conf->elist_wwid = vector_alloc();
 
-                if (!conf->elist_wwid)
+		if (!conf->elist_wwid)
 			goto out;
 	}
 
 	if (conf->elist_device == NULL) {
 		conf->elist_device = vector_alloc();
-		
+
 		if (!conf->elist_device)
 			goto out;
 	}
@@ -442,7 +447,7 @@ load_config (char * file)
 	if (conf->hwhandler == NULL)
 		conf->hwhandler = set_default(DEFAULT_HWHANDLER);
 
-	if (!conf->selector  || !conf->udev_dir         ||
+	if (!conf->selector  || !conf->udev_dir || !conf->multipath_dir ||
 	    !conf->getuid    || !conf->features ||
 	    !conf->hwhandler)
 		goto out;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 7568d7b..8a97799 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -71,6 +71,7 @@ struct config {
 	char * dev;
 	char * sysfs_dir;
 	char * udev_dir;
+	char * multipath_dir;
 	char * selector;
 	char * getuid;
 	char * features;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 97a3dd7..e8060a2 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,5 +1,6 @@
 #define DEFAULT_GETUID		"/lib/udev/scsi_id -g -u -s /block/%n"
 #define DEFAULT_UDEVDIR		"/dev"
+#define DEFAULT_MULTIPATHDIR	"/lib/multipath"
 #define DEFAULT_SELECTOR	"round-robin 0"
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 76571d7..b6f7845 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -44,6 +44,17 @@ udev_dir_handler(vector strvec)
 }
 
 static int
+multipath_dir_handler(vector strvec)
+{
+	conf->multipath_dir = set_value(strvec);
+
+	if (!conf->multipath_dir)
+		return 1;
+
+	return 0;
+}
+
+static int
 def_selector_handler(vector strvec)
 {
 	conf->selector = set_value(strvec);
@@ -1332,6 +1343,18 @@ snprint_def_udev_dir (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_multipath_dir (char * buff, int len, void * data)
+{
+	if (!conf->udev_dir)
+		return 0;
+	if (strlen(DEFAULT_MULTIPATHDIR) == strlen(conf->multipath_dir) &&
+	    !strcmp(conf->multipath_dir, DEFAULT_MULTIPATHDIR))
+		return 0;
+
+	return snprintf(buff, len, "%s", conf->multipath_dir);
+}
+
+static int
 snprint_def_selector (char * buff, int len, void * data)
 {
 	if (!conf->selector)
@@ -1538,6 +1561,7 @@ init_keywords(void)
 	install_keyword_root("defaults", NULL);
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
+	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 617fc19..54393f2 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -5,6 +5,7 @@
 
 #include "debug.h"
 #include "prio.h"
+#include "config.h"
 
 static LIST_HEAD(prioritizers);
 
@@ -28,18 +29,18 @@ void free_prio (struct prio * p)
 
 void cleanup_prio(void)
 {
-        struct prio * prio_loop;
-        struct prio * prio_temp;
+	struct prio * prio_loop;
+	struct prio * prio_temp;
 
-        list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node) {
-                list_del(&prio_loop->node);
-                free(prio_loop);
-        }
+	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node) {
+		list_del(&prio_loop->node);
+		free(prio_loop);
+	}
 }
 
 struct prio * prio_lookup (char * name)
 {
-        struct prio * p;
+	struct prio * p;
 
 	list_for_each_entry(p, &prioritizers, node) {
 		if (!strncmp(name, p->name, PRIO_NAME_LEN))
@@ -61,7 +62,8 @@ struct prio * add_prio (char * name)
 	p = alloc_prio();
 	if (!p)
 		return NULL;
-	snprintf(libname, LIB_PRIO_NAMELEN, "libprio%s.so", name);
+	snprintf(libname, LIB_PRIO_NAMELEN, "%s/libprio%s.so",
+		 conf->multipath_dir, name);
 	condlog(3, "loading %s prioritizer", libname);
 	handle = dlopen(libname, RTLD_NOW);
 	errstr = dlerror();
diff --git a/multipath/main.c b/multipath/main.c
index c071cac..f1ac256 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -326,6 +326,9 @@ main (int argc, char *argv[])
 	if (dm_prereq(DEFAULT_TARGET))
 		exit(1);
 
+	if (load_config(DEFAULT_CONFIGFILE))
+		exit(1);
+
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
 		exit(1);
@@ -334,9 +337,6 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize prioritizers");
 		exit(1);
 	}
-	if (load_config(DEFAULT_CONFIGFILE))
-		exit(1);
-
 	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)) {
 		condlog(0, "multipath tools need sysfs mounted");
 		exit(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2b1fd86..ac9cd36 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1274,6 +1274,9 @@ child (void * param)
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
+	if (load_config(DEFAULT_CONFIGFILE))
+		exit(1);
+
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
 		exit(1);
@@ -1282,8 +1285,6 @@ child (void * param)
 		condlog(0, "failed to initialize prioritizers");
 		exit(1);
 	}
-	if (load_config(DEFAULT_CONFIGFILE))
-		exit(1);
 
 	setlogmask(LOG_UPTO(conf->verbosity + 3));
 
-- 
1.5.2.4
