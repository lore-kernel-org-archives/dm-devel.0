From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/26] multipath: make 'dev_type' internal to the
	multipath program
Date: Mon, 20 Jun 2016 10:08:59 +0200
Message-ID: <1466410153-23896-13-git-send-email-hare@suse.de>
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

Only the multipath program uses the 'dev_type' config entry,
so we should be dropping it from the main configuration and
make it a local variable to the multipath program.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.c |  1 -
 libmultipath/config.h |  1 -
 multipath/main.c      | 29 +++++++++++++++--------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6f3c4e8..88a0f09 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -595,7 +595,6 @@ load_config (char * file, struct udev *udev)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
 	conf->udev = udev;
-	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
 	conf->minio_rq = DEFAULT_MINIO_RQ;
 	get_sys_max_fds(&conf->max_fds);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index eed606c..06e83dc 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -99,7 +99,6 @@ struct config {
 	int verbosity;
 	int pgpolicy_flag;
 	int pgpolicy;
-	enum devtypes dev_type;
 	int minio;
 	int minio_rq;
 	int checkint;
diff --git a/multipath/main.c b/multipath/main.c
index bd7da58..5b0cb7e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -239,7 +239,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
  *   1: Failure
  */
 static int
-configure (enum mpath_cmds cmd)
+configure (enum mpath_cmds cmd, enum devtypes dev_type)
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
@@ -262,12 +262,12 @@ configure (enum mpath_cmds cmd)
 	vecs.pathvec = pathvec;
 	vecs.mpvec = curmp;
 
-	dev = convert_dev(conf->dev, (conf->dev_type == DEV_DEVNODE));
+	dev = convert_dev(conf->dev, (dev_type == DEV_DEVNODE));
 
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
-	if (dev && conf->dev_type == DEV_DEVNODE &&
+	if (dev && dev_type == DEV_DEVNODE &&
 	    cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
@@ -281,7 +281,7 @@ configure (enum mpath_cmds cmd)
 	 * failing the translation is fatal (by policy)
 	 */
 	if (conf->dev) {
-		int failed = get_refwwid(cmd, conf->dev, conf->dev_type,
+		int failed = get_refwwid(cmd, conf->dev, dev_type,
 					 pathvec, &refwwid);
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", conf->dev);
@@ -480,6 +480,7 @@ main (int argc, char *argv[])
 	extern int optind;
 	int r = 1;
 	enum mpath_cmds cmd = CMD_CREATE;
+	enum devtypes dev_type;
 
 	udev = udev_new();
 	logsink = 0;
@@ -554,7 +555,7 @@ main (int argc, char *argv[])
 			exit(0);
 		case 'u':
 			cmd = CMD_VALID_PATH;
-			conf->dev_type = DEV_UEVENT;
+			dev_type = DEV_UEVENT;
 			break;
 		case 'w':
 			cmd = CMD_REMOVE_WWID;
@@ -597,14 +598,14 @@ main (int argc, char *argv[])
 			goto out;
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
-		if (conf->dev_type != DEV_UEVENT)
-			conf->dev_type = get_dev_type(conf->dev);
-		if (conf->dev_type == DEV_NONE) {
+		if (dev_type != DEV_UEVENT)
+			dev_type = get_dev_type(conf->dev);
+		if (dev_type == DEV_NONE) {
 			condlog(0, "'%s' is not a valid argument\n", conf->dev);
 			goto out;
 		}
 	}
-	if (conf->dev_type == DEV_UEVENT) {
+	if (dev_type == DEV_UEVENT) {
 		openlog("multipath", 0, LOG_DAEMON);
 		setlogmask(LOG_UPTO(conf->verbosity + 3));
 		logsink = 1;
@@ -630,12 +631,12 @@ main (int argc, char *argv[])
 	}
 
 	if (cmd == CMD_VALID_PATH &&
-	    (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
+	    (!conf->dev || dev_type == DEV_DEVMAP)) {
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
 	if (cmd == CMD_VALID_PATH &&
-	    conf->dev_type == DEV_UEVENT) {
+	    dev_type == DEV_UEVENT) {
 		int fd;
 
 		fd = mpath_connect();
@@ -672,7 +673,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	if (conf->remove == FLUSH_ONE) {
-		if (conf->dev_type == DEV_DEVMAP) {
+		if (dev_type == DEV_DEVMAP) {
 			r = dm_suspend_and_flush_map(conf->dev);
 		} else
 			condlog(0, "must provide a map name to remove");
@@ -683,7 +684,7 @@ main (int argc, char *argv[])
 		r = dm_flush_maps();
 		goto out;
 	}
-	while ((r = configure(cmd)) < 0)
+	while ((r = configure(cmd, dev_type)) < 0)
 		condlog(3, "restart multipath configuration process");
 
 out:
@@ -693,7 +694,7 @@ out:
 	cleanup_prio();
 	cleanup_checkers();
 
-	if (conf->dev_type == DEV_UEVENT)
+	if (dev_type == DEV_UEVENT)
 		closelog();
 
 out_free_config:
-- 
2.6.6
