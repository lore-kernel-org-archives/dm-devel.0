From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 58/78] Remove dm_udev_XXX wrapper functions
Date: Mon, 16 Mar 2015 13:36:45 +0100
Message-ID: <1426509425-15978-59-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

As the definitions are encapsulated with the correct definitions
anyway there is no need to have private wrappers here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 19 +++++--------------
 libmultipath/devmapper.h |  2 --
 multipath/main.c         |  2 +-
 multipathd/main.c        |  2 +-
 4 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f0b0da1..1712c56 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -42,23 +42,14 @@ static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
 	return 1;
 }
 
-void udev_wait(unsigned int c)
+void dm_udev_wait(unsigned int c)
 {
 }
 
-void udev_set_sync_support(int c)
+void dm_udev_set_sync_support(int c)
 {
 }
-#else
-void udev_wait(unsigned int c)
-{
-	dm_udev_wait(c);
-}
 
-void udev_set_sync_support(int c)
-{
-	dm_udev_set_sync_support(c);
-}
 #endif
 
 static void
@@ -245,7 +236,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 		if (!r)
 			dm_udev_complete(cookie);
 		else
-			udev_wait(cookie);
+			dm_udev_wait(cookie);
 	}
 	out:
 	dm_task_destroy (dmt);
@@ -325,7 +316,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 		if (!r)
 			dm_udev_complete(cookie);
 		else
-			udev_wait(cookie);
+			dm_udev_wait(cookie);
 	}
 	freeout:
 	if (prefixed_uuid)
@@ -1354,7 +1345,7 @@ dm_rename (char * old, char * new)
 	if (!r)
 		dm_udev_complete(cookie);
 	else
-		udev_wait(cookie);
+		dm_udev_wait(cookie);
 
 out:
 	dm_task_destroy(dmt);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 8188f48..2613503 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -49,8 +49,6 @@ int dm_rename (char * old, char * new);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
-void udev_wait(unsigned int c);
-void udev_set_sync_support(int c);
 
 #define VERSION_GE(v, minv) ( \
  (v[0] > minv[0]) || \
diff --git a/multipath/main.c b/multipath/main.c
index bee9a65..f62dcb1 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -582,7 +582,7 @@ main (int argc, char *argv[])
 	if (dm_prereq())
 		exit(1);
 	dm_drv_version(conf->version, TGT_MPATH);
-	udev_set_sync_support(1);
+	dm_udev_set_sync_support(1);
 
 	if (optind < argc) {
 		conf->dev = MALLOC(FILE_NAME_SIZE);
diff --git a/multipathd/main.c b/multipathd/main.c
index b86e3b6..fd3514f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1817,7 +1817,7 @@ child (void * param)
 	set_oom_adj();
 
 	conf->daemon = 1;
-	udev_set_sync_support(0);
+	dm_udev_set_sync_support(0);
 #ifdef USE_SYSTEMD
 	envp = getenv("WATCHDOG_USEC");
 	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
-- 
1.8.4.5
