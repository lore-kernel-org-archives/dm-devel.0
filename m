From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [Patch] multipath-tools: Check if multipathd is running
 or not and print a warning
Date: Thu, 28 Jul 2016 17:18:02 +0530
Message-ID: <ebce9048-140b-b217-6438-8f2370026cc8@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello,

With this patch dm-multipath commands e.g. multipath -v2,
multipath -ll etc. now checks if there are multipath
device maps created, and multipathd service is running 
or not? If the multipath devices are created, but multipathd 
service is not running then there will be a warning 
message displayed to inform the user that IO failover/
failback may not work as expected without multipathd 
process running.

I have tested this patch with Fedora 23, and latest 
upstream multipath-tools

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 707e6be..de79ed6 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -715,7 +715,8 @@ deadmap (struct multipath * mpp)
 	return 1; /* dead */
 }
 
-int check_daemon(void)
+extern int
+check_daemon(void)
 {
 	int fd;
 	char *reply;
@@ -752,6 +753,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 {
 	int r = 1;
 	int k, i;
+	int map_processed = 0;
 	int is_daemon = (cmd == CMD_NONE) ? 1 : 0;
 	char params[PARAMS_SIZE];
 	struct multipath * mpp;
@@ -916,6 +918,13 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			else
 				remove_map(mpp, vecs, 0);
 		}
+
+		/* By now at least one multipath device map is processed,
+		 * so set map_processed = 1
+		 */
+		if (!map_processed)
+			map_processed = 1;
+
 	}
 	/*
 	 * Flush maps with only dead paths (ie not in sysfs)
@@ -941,6 +950,17 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 				condlog(2, "%s: remove (dead)", alias);
 		}
 	}
+
+	/* If there is at least one multipath device map processed then
+	 * check if 'multipathd' service is running or not?
+	 */
+	if (map_processed) {
+		if (!is_daemon && !check_daemon()){
+			condlog(0, "'multipathd' service is currently not "
+				"running, IO failover/failback will not work");
+		}
+	}
+
 	return 0;
 }
 
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 442c956..ff76927 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -28,6 +28,7 @@ enum actions {
 int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
+int check_daemon(void);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
 int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
diff --git a/multipath/main.c b/multipath/main.c
index 6ccece7..177986e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -202,6 +202,7 @@ static int
 get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 {
 	int i;
+	int maps_present = 0;
 	struct multipath * mpp;
 	char params[PARAMS_SIZE], status[PARAMS_SIZE];
 
@@ -253,7 +254,24 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 
 		if (cmd == CMD_CREATE)
 			reinstate_paths(mpp);
+
+		/* At this place we have found at least one multipath
+		 * device map, so set maps_present = 1
+		 */
+		if (!maps_present)
+			maps_present = 1;
+	}
+
+	/* If there is at least one multipath device map present then
+	 * check if 'multipathd' service is running or not?
+	 */
+	if (maps_present && !check_daemon()) {
+		condlog(0, "multipath device maps are present, but "
+			"'multipathd' service is not running");
+		condlog(0, "IO failover/failback will not work without "
+			"'multipathd' service running");
 	}
+
 	return 0;
 }
 
