From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/26] multipath: make 'dev' internal to the
	multipath program
Date: Mon,  4 Jul 2016 09:08:33 +0200
Message-ID: <1467616126-10036-14-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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

Only the multipath program is accessing the config entry 'dev',
so we should be making it a local variable.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.c |  3 ---
 libmultipath/config.h |  1 -
 multipath/main.c      | 43 +++++++++++++++++++++++--------------------
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 88a0f09..137ff6a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -478,9 +478,6 @@ free_config (struct config * conf)
 	if (!conf)
 		return;
 
-	if (conf->dev)
-		FREE(conf->dev);
-
 	if (conf->multipath_dir)
 		FREE(conf->multipath_dir);
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index f28508f..8ebc43f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -141,7 +141,6 @@ struct config {
 	int uev_wait_timeout;
 	unsigned int version[3];
 
-	char * dev;
 	struct udev * udev;
 	char * multipath_dir;
 	char * selector;
diff --git a/multipath/main.c b/multipath/main.c
index 5b0cb7e..2825c8e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -239,7 +239,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
  *   1: Failure
  */
 static int
-configure (enum mpath_cmds cmd, enum devtypes dev_type)
+configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
@@ -262,7 +262,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type)
 	vecs.pathvec = pathvec;
 	vecs.mpvec = curmp;
 
-	dev = convert_dev(conf->dev, (dev_type == DEV_DEVNODE));
+	dev = convert_dev(devpath, (dev_type == DEV_DEVNODE));
 
 	/*
 	 * if we have a blacklisted device parameter, exit early
@@ -273,20 +273,20 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type)
 			    conf->elist_devnode, dev) > 0)) {
 		if (cmd == CMD_VALID_PATH)
 			printf("%s is not a valid multipath device path\n",
-			       conf->dev);
+			       devpath);
 		goto out;
 	}
 	/*
 	 * scope limiting must be translated into a wwid
 	 * failing the translation is fatal (by policy)
 	 */
-	if (conf->dev) {
-		int failed = get_refwwid(cmd, conf->dev, dev_type,
+	if (devpath) {
+		int failed = get_refwwid(cmd, devpath, dev_type,
 					 pathvec, &refwwid);
 		if (!refwwid) {
-			condlog(4, "%s: failed to get wwid", conf->dev);
+			condlog(4, "%s: failed to get wwid", devpath);
 			if (failed == 2 && cmd == CMD_VALID_PATH)
-				printf("%s is not a valid multipath device path\n", conf->dev);
+				printf("%s is not a valid multipath device path\n", devpath);
 			else
 				condlog(3, "scope is nul");
 			goto out;
@@ -324,7 +324,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type)
 				r = 0;
 
 			printf("%s %s a valid multipath device path\n",
-			       conf->dev, r == 0 ? "is" : "is not");
+			       devpath, r == 0 ? "is" : "is not");
 			goto out;
 		}
 	}
@@ -332,7 +332,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type)
 	/*
 	 * get a path list
 	 */
-	if (conf->dev)
+	if (devpath)
 		di_flag = DI_WWID;
 
 	if (cmd == CMD_LIST_LONG)
@@ -368,7 +368,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type)
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
 		printf("%s %s a valid multipath device path\n",
-		       conf->dev, r == 0 ? "is" : "is not");
+		       devpath, r == 0 ? "is" : "is not");
 		goto out;
 	}
 
@@ -481,6 +481,7 @@ main (int argc, char *argv[])
 	int r = 1;
 	enum mpath_cmds cmd = CMD_CREATE;
 	enum devtypes dev_type;
+	char *dev = NULL;
 
 	udev = udev_new();
 	logsink = 0;
@@ -592,16 +593,16 @@ main (int argc, char *argv[])
 	dm_udev_set_sync_support(1);
 
 	if (optind < argc) {
-		conf->dev = MALLOC(FILE_NAME_SIZE);
+		dev = MALLOC(FILE_NAME_SIZE);
 
-		if (!conf->dev)
+		if (!dev)
 			goto out;
 
-		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
+		strncpy(dev, argv[optind], FILE_NAME_SIZE);
 		if (dev_type != DEV_UEVENT)
-			dev_type = get_dev_type(conf->dev);
+			dev_type = get_dev_type(dev);
 		if (dev_type == DEV_NONE) {
-			condlog(0, "'%s' is not a valid argument\n", conf->dev);
+			condlog(0, "'%s' is not a valid argument\n", dev);
 			goto out;
 		}
 	}
@@ -631,7 +632,7 @@ main (int argc, char *argv[])
 	}
 
 	if (cmd == CMD_VALID_PATH &&
-	    (!conf->dev || dev_type == DEV_DEVMAP)) {
+	    (!dev || dev_type == DEV_DEVMAP)) {
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
@@ -642,12 +643,12 @@ main (int argc, char *argv[])
 		fd = mpath_connect();
 		if (fd == -1) {
 			printf("%s is not a valid multipath device path\n",
-				conf->dev);
+				dev);
 			goto out;
 		}
 		mpath_disconnect(fd);
 	}
-	if (cmd == CMD_REMOVE_WWID && !conf->dev) {
+	if (cmd == CMD_REMOVE_WWID && !dev) {
 		condlog(0, "the -w option requires a device");
 		goto out;
 	}
@@ -674,7 +675,7 @@ main (int argc, char *argv[])
 	}
 	if (conf->remove == FLUSH_ONE) {
 		if (dev_type == DEV_DEVMAP) {
-			r = dm_suspend_and_flush_map(conf->dev);
+			r = dm_suspend_and_flush_map(dev);
 		} else
 			condlog(0, "must provide a map name to remove");
 
@@ -684,7 +685,7 @@ main (int argc, char *argv[])
 		r = dm_flush_maps();
 		goto out;
 	}
-	while ((r = configure(cmd, dev_type)) < 0)
+	while ((r = configure(cmd, dev_type, dev)) < 0)
 		condlog(3, "restart multipath configuration process");
 
 out:
@@ -706,6 +707,8 @@ out_free_config:
 	free_config(conf);
 	conf = NULL;
 	udev_unref(udev);
+	if (dev)
+		FREE(dev);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.6.6
