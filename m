From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/30] multipath: bind lifetime of udev context
	to main thread
Date: Tue, 16 Jul 2013 09:12:52 +0200
Message-ID: <1373958801-103613-2-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We have to tie the lifetime of the udev context to the thread
or program. The current approach by creating it on config_load()
will invalidate the context during reconfiguration, thereby
causing all still existent objects to refer to an invalid pointer.
And resulting in a nice crash.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_persist.c  |  7 ++++---
 libmpathpersist/mpath_persist.h  |  2 +-
 libmpathpersist/mpath_pr_ioctl.c |  5 +++--
 libmultipath/config.c            |  9 +++------
 libmultipath/config.h            |  2 +-
 mpathpersist/main.c              | 11 +++++++----
 multipath/main.c                 | 12 ++++++++----
 multipathd/main.c                | 11 ++++++++---
 8 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 3041089..bd30125 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -1,4 +1,3 @@
-#include "mpath_persist.h"
 #include <libdevmapper.h>
 #include <defaults.h>
 #include <sys/stat.h>
@@ -8,6 +7,7 @@
 #include <checkers.h>
 #include <structs.h>
 #include <structs_vec.h>
+#include <libudev.h>
 
 #include <prio.h>
 #include <unistd.h>
@@ -20,6 +20,7 @@
 #include <ctype.h>
 #include <propsel.h>
 
+#include "mpath_persist.h"
 #include "mpathpr.h"
 #include "mpath_pr_ioctl.h"
 
@@ -32,9 +33,9 @@
 
 
 int
-mpath_lib_init (void)
+mpath_lib_init (struct udev *udev)
 {
-	if (load_config(DEFAULT_CONFIGFILE)){
+	if (load_config(DEFAULT_CONFIGFILE, udev)){
 		condlog(0, "Failed to initialize multipath config.");
 		return 1;
 	}
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index d8ff6f2..a5e7868 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -174,7 +174,7 @@ struct prout_param_descriptor { 	/* PROUT parameter descriptor */
  *
  * RETURNS: 0->Success, 1->Failed.
  */
-extern int mpath_lib_init (void );
+extern int mpath_lib_init (struct udev *udev);
 
 
 /*
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index de3292e..c85fd10 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -10,8 +10,9 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
-#include "mpath_pr_ioctl.h" 
-#include <mpath_persist.h> 
+#include <libudev.h>
+#include "mpath_pr_ioctl.h"
+#include <mpath_persist.h>
 
 #include <debug.h>
 
diff --git a/libmultipath/config.c b/libmultipath/config.c
index da676df..a322dfe 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -466,9 +466,6 @@ free_config (struct config * conf)
 	if (conf->dev)
 		FREE(conf->dev);
 
-	if (conf->udev)
-		udev_unref(conf->udev);
-
 	if (conf->multipath_dir)
 		FREE(conf->multipath_dir);
 
@@ -518,12 +515,12 @@ free_config (struct config * conf)
 }
 
 int
-load_config (char * file)
+load_config (char * file, struct udev *udev)
 {
 	if (!conf)
 		conf = alloc_config();
 
-	if (!conf)
+	if (!conf || !udev)
 		return 1;
 
 	/*
@@ -532,7 +529,7 @@ load_config (char * file)
 	if (!conf->verbosity)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
-	conf->udev = udev_new();
+	conf->udev = udev;
 	dm_drv_version(conf->version, TGT_MPATH);
 	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 4ade355..405a8f3 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -157,7 +157,7 @@ void free_mptable (vector mptable);
 
 int store_hwe (vector hwtable, struct hwentry *);
 
-int load_config (char * file);
+int load_config (char * file, struct udev * udev);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
 
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 465fcb1..e3484b5 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -7,6 +7,7 @@
 #include <vector.h>
 #include <structs.h>
 #include <getopt.h>
+#include <libudev.h>
 #include <mpath_persist.h>
 #include "main.h"
 #include <pthread.h>
@@ -68,7 +69,8 @@ int main (int argc, char * argv[])
 	int noisy = 0;
 	int num_transport =0;
 	void *resp = NULL;
-	struct transportid * tmp; 
+	struct transportid * tmp;
+	struct udev *udev = NULL;
 
 	if (optind == argc)
 	{
@@ -84,8 +86,8 @@ int main (int argc, char * argv[])
 		exit (1);
 	}
 
-
-	mpath_lib_init();
+	udev = udev_new();
+	mpath_lib_init(udev);
 	memset(transportids,0,MPATH_MX_TIDS);
 
 	while (1)
@@ -461,12 +463,13 @@ int main (int argc, char * argv[])
 	if (res < 0)
 	{
 		mpath_lib_exit();
+		udev_unref(udev);
 		return MPATH_PR_FILE_ERROR;
 	}
 
 out :
 	mpath_lib_exit();
-
+	udev_unref(udev);
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
 }
 
diff --git a/multipath/main.c b/multipath/main.c
index f1b3ec9..4a8b966 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <ctype.h>
+#include <libudev.h>
 
 #include <checkers.h>
 #include <prio.h>
@@ -435,6 +436,7 @@ convert_dev(char *dev)
 int
 main (int argc, char *argv[])
 {
+	struct udev *udev;
 	int arg;
 	extern char *optarg;
 	extern int optind;
@@ -445,10 +447,12 @@ main (int argc, char *argv[])
 		exit(1);
 	}
 
+	udev = udev_new();
+
 	if (dm_prereq())
 		exit(1);
 
-	if (load_config(DEFAULT_CONFIGFILE))
+	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
 	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:BrtqwW")) != EOF ) {
@@ -560,11 +564,11 @@ main (int argc, char *argv[])
 
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
-		exit(1);
+		goto out;
 	}
 	if (init_prio()) {
 		condlog(0, "failed to initialize prioritizers");
-		exit(1);
+		goto out;
 	}
 	dm_init();
 
@@ -628,7 +632,7 @@ out:
 	 */
 	free_config(conf);
 	conf = NULL;
-
+	udev_unref(udev);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
diff --git a/multipathd/main.c b/multipathd/main.c
index 0fa1b17..aa5a298 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -93,6 +93,8 @@ static sem_t exit_sem;
  */
 struct vectors * gvecs;
 
+struct udev * udev;
+
 static int
 need_switch_pathgroup (struct multipath * mpp, int refresh)
 {
@@ -1403,7 +1405,7 @@ reconfigure (struct vectors * vecs)
 	vecs->pathvec = NULL;
 	conf = NULL;
 
-	if (!load_config(DEFAULT_CONFIGFILE)) {
+	if (!load_config(DEFAULT_CONFIGFILE, udev)) {
 		conf->verbosity = old->verbosity;
 		conf->daemon = 1;
 		configure(vecs, 1);
@@ -1588,6 +1590,8 @@ child (void * param)
 	sem_init(&exit_sem, 0, 0);
 	signal_init();
 
+	udev = udev_new();
+
 	setup_thread_attr(&misc_attr, 64 * 1024, 1);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
@@ -1602,7 +1606,7 @@ child (void * param)
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
-	if (load_config(DEFAULT_CONFIGFILE))
+	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
 	if (init_checkers()) {
@@ -1752,7 +1756,8 @@ child (void * param)
 	 */
 	free_config(conf);
 	conf = NULL;
-
+	udev_unref(udev);
+	udev = NULL;
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
1.7.12.4
