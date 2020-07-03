From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 5/7] multipath: make flushing maps work like
	other commands
Date: Thu,  2 Jul 2020 19:07:04 -0500
Message-ID: <1593734826-14059-6-git-send-email-bmarzins@redhat.com>
References: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

The config structure doesn't need a special variable just for removes.
Multipath can just use the cmd variable, like it does for the other
commands.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h    |  3 ++-
 libmultipath/configure.h |  3 ---
 multipath/main.c         | 20 ++++++++++----------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index ceecff2d..55569360 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -38,6 +38,8 @@ enum mpath_cmds {
 	CMD_ADD_WWID,
 	CMD_USABLE_PATHS,
 	CMD_DUMP_CONFIG,
+	CMD_FLUSH_ONE,
+	CMD_FLUSH_ALL,
 };
 
 enum force_reload_types {
@@ -142,7 +144,6 @@ struct config {
 	unsigned int max_checkint;
 	bool use_watchdog;
 	int pgfailback;
-	int remove;
 	int rr_weight;
 	int no_path_retry;
 	int user_friendly_names;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index d7509000..0e33bf40 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -45,9 +45,6 @@ enum {
 	CP_RETRY,
 };
 
-#define FLUSH_ONE 1
-#define FLUSH_ALL 2
-
 struct vectors;
 
 int setup_map (struct multipath * mpp, char * params, int params_size,
diff --git a/multipath/main.c b/multipath/main.c
index d89f0a91..101fd656 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -909,10 +909,10 @@ main (int argc, char *argv[])
 				cmd = CMD_DRY_RUN;
 			break;
 		case 'f':
-			conf->remove = FLUSH_ONE;
+			cmd = CMD_FLUSH_ONE;
 			break;
 		case 'F':
-			conf->remove = FLUSH_ALL;
+			cmd = CMD_FLUSH_ALL;
 			break;
 		case 'l':
 			if (optarg && !strncmp(optarg, "l", 1))
@@ -1053,6 +1053,10 @@ main (int argc, char *argv[])
 		condlog(0, "the -w option requires a device");
 		goto out;
 	}
+	if (cmd == CMD_FLUSH_ONE && dev_type != DEV_DEVMAP) {
+		condlog(0, "the -f option requires a map name to remove");
+		goto out;
+	}
 
 	switch(delegate_to_multipathd(cmd, dev, dev_type, conf)) {
 	case DELEGATE_OK:
@@ -1086,16 +1090,12 @@ main (int argc, char *argv[])
 	}
 	if (retries < 0)
 		retries = conf->remove_retries;
-	if (conf->remove == FLUSH_ONE) {
-		if (dev_type == DEV_DEVMAP) {
-			r = dm_suspend_and_flush_map(dev, retries) ?
-				RTVL_FAIL : RTVL_OK;
-		} else
-			condlog(0, "must provide a map name to remove");
-
+	if (cmd == CMD_FLUSH_ONE) {
+		r = dm_suspend_and_flush_map(dev, retries) ?
+		    RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
-	else if (conf->remove == FLUSH_ALL) {
+	else if (cmd == CMD_FLUSH_ALL) {
 		r = dm_flush_maps(1, retries) ? RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
-- 
2.17.2
