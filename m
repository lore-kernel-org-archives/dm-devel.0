From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/26] devmapper: explicit config settings
Date: Mon, 20 Jun 2016 10:08:51 +0200
Message-ID: <1466410153-23896-5-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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

Rather than access 'conf' from within the code this patch moves
those settings to function arguments. So with this patch we don't
need to access 'struct config' anymore.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c |  6 ++++--
 libmultipath/devmapper.c | 21 +++++++++++----------
 libmultipath/devmapper.h |  4 ++--
 multipath/main.c         |  2 +-
 multipathd/main.c        |  2 +-
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a830bcd..f7cd110 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -633,11 +633,13 @@ domap (struct multipath * mpp, char * params)
 		break;
 
 	case ACT_RENAME:
-		r = dm_rename(mpp->alias_old, mpp->alias);
+		r = dm_rename(mpp->alias_old, mpp->alias,
+			      conf->partition_delim);
 		break;
 
 	case ACT_FORCERENAME:
-		r = dm_rename(mpp->alias_old, mpp->alias);
+		r = dm_rename(mpp->alias_old, mpp->alias,
+			      conf->partition_delim);
 		if (r)
 			r = dm_addmap_reload(mpp, params, 0);
 		break;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 926d2f5..b50e9e6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -19,7 +19,6 @@
 #include "debug.h"
 #include "memory.h"
 #include "devmapper.h"
-#include "config.h"
 #include "sysfs.h"
 
 #include "log_pthread.h"
@@ -32,6 +31,8 @@
 #define UUID_PREFIX "mpath-"
 #define UUID_PREFIX_LEN 6
 
+static int dm_conf_verbosity;
+
 #ifdef LIBDM_API_DEFERRED
 static int dm_cancel_remove_partmaps(const char * mapname);
 #endif
@@ -65,7 +66,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 	if (level > 6)
 		level = 6;
 
-	thres = (conf) ? conf->verbosity : 0;
+	thres = dm_conf_verbosity;
 	if (thres <= 3 || level > thres)
 		return;
 
@@ -94,9 +95,9 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 }
 
 extern void
-dm_init(void) {
+dm_init(int v) {
 	dm_log_init(&dm_write_log);
-	dm_log_init_verbose(conf ? conf->verbosity + 3 : 0);
+	dm_log_init_verbose(v + 3);
 }
 
 static int
@@ -1375,21 +1376,21 @@ rename_partmap (const char *name, void *data)
 	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
 	snprintf(buff, PARAMS_SIZE, "%s%s%s", rd->new, rd->delim,
 		 name + offset);
-	dm_rename(name, buff);
+	dm_rename(name, buff, rd->delim);
 	condlog(4, "partition map %s renamed", name);
 	return 0;
 }
 
 int
-dm_rename_partmaps (const char * old, char * new)
+dm_rename_partmaps (const char * old, char * new, char *delim)
 {
 	struct rename_data rd;
 
 	rd.old = old;
 	rd.new = new;
 
-	if (conf->partition_delim)
-		rd.delim = conf->partition_delim;
+	if (delim)
+		rd.delim = delim;
 	if (isdigit(new[strlen(new)-1]))
 		rd.delim = "p";
 	else
@@ -1398,13 +1399,13 @@ dm_rename_partmaps (const char * old, char * new)
 }
 
 int
-dm_rename (const char * old, char * new)
+dm_rename (const char * old, char * new, char *delim)
 {
 	int r = 0;
 	struct dm_task *dmt;
 	uint32_t cookie;
 
-	if (dm_rename_partmaps(old, new))
+	if (dm_rename_partmaps(old, new, delim))
 		return r;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_RENAME)))
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index b5df369..4bc3b11 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -12,7 +12,7 @@
 #define MPATH_UDEV_RELOAD_FLAG 0
 #endif
 
-void dm_init(void);
+void dm_init(int verbosity);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, uint16_t);
@@ -46,7 +46,7 @@ int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
-int dm_rename (const char * old, char * new);
+int dm_rename (const char * old, char * new, char * delim);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
diff --git a/multipath/main.c b/multipath/main.c
index aadebec..0dbe281 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -583,6 +583,7 @@ main (int argc, char *argv[])
 		exit(1);
 	}
 
+	dm_init(conf->verbosity);
 	if (dm_prereq())
 		exit(1);
 	dm_drv_version(conf->version, TGT_MPATH);
@@ -627,7 +628,6 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize prioritizers");
 		goto out;
 	}
-	dm_init();
 
 	if (conf->cmd == CMD_VALID_PATH &&
 	    (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 3b79aef..8592982 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2111,6 +2111,7 @@ child (void * param)
 
 	uxsock_timeout = conf->uxsock_timeout;
 
+	dm_init(conf->verbosity);
 	dm_drv_version(conf->version, TGT_MPATH);
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
@@ -2368,7 +2369,6 @@ main (int argc, char *argv[])
 	int foreground = 0;
 
 	logsink = 1;
-	dm_init();
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
-- 
2.6.6
