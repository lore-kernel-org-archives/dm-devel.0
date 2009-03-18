From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Don't display the state of the newly added map
	during addition in the daemon and don't switch groups.
Date: Wed, 18 Mar 2009 19:38:08 -0400
Message-ID: <1237419489-3303-4-git-send-email-konrad@virtualiron.com>
References: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-2-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-3-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237419489-3303-3-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

A previous commit mass-changed #ifdef DAEMON to check for 'mpp->waiter'. Unfortunatly
when the 'domap' function is called with ACT_CREATE in the daemon, the mpp->waiter is not
set, hence the multipath client mode logic is choosen. Fixing this triggers another
issues which is that newly added path via ACT_CREATE won't have their waitevent thread
created as the caller checks mpp->action (which changed to ACT_NOTHING) and won't
start the thread.
---
 libmultipath/config.h    |    1 +
 libmultipath/configure.c |    9 ++++++---
 multipath/main.c         |    1 +
 multipathd/main.c        |    2 +-
 multipathd/main.h        |    1 -
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index fb917f4..07aa8c0 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -64,6 +64,7 @@ struct config {
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
+	int daemon;
 
 	char * dev;
 	char * sysfs_dir;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 83ee0ae..e00582f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -369,7 +369,7 @@ domap (struct multipath * mpp)
 		 * DM_DEVICE_CREATE, DM_DEVICE_RENAME, or DM_DEVICE_RELOAD
 		 * succeeded
 		 */
-		if (!mpp->waiter) {
+		if (!conf->daemon) {
 			/* multipath client mode */
 			dm_switchgroup(mpp->alias, mpp->bestpg);
 			if (mpp->action != ACT_NOTHING)
@@ -380,9 +380,12 @@ domap (struct multipath * mpp)
 			condlog(2, "%s: load table [0 %llu %s %s]", mpp->alias,
 				mpp->size, TGT_MPATH, mpp->params);
 			/*
-			 * Required action is over, reset for the stateful daemon
+			 * Required action is over, reset for the stateful daemon.
+			 * But don't do it for creation as we use in the caller the
+			 * mpp->action to figure out whether to start the watievent checker.
 			 */
-			mpp->action = ACT_NOTHING;
+			if (mpp->action != ACT_CREATE)
+				mpp->action = ACT_NOTHING;
 		}
 		return DOMAP_OK;
 	}
diff --git a/multipath/main.c b/multipath/main.c
index e60b9bc..ade858d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -421,6 +421,7 @@ main (int argc, char *argv[])
 			conf->dev_type = DEV_DEVMAP;
 
 	}
+	conf->daemon = 0;
 	dm_init();
 
 	if (conf->remove == FLUSH_ONE) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 7de41a0..323ed7f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1333,7 +1333,7 @@ child (void * param)
 		condlog(0, "can not find sysfs mount point");
 		exit(1);
 	}
-
+	conf->daemon = 1;
 	/*
 	 * fetch and configure both paths and multipaths
 	 */
diff --git a/multipathd/main.h b/multipathd/main.h
index 1a6dc55..b3a90f8 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -1,7 +1,6 @@
 #ifndef MAIN_H
 #define MAIN_H
 
-#define DAEMON 1
 #define MAPGCINT 5
 
 int reconfigure (struct vectors *);
-- 
1.5.4.1
