From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 04/12] change conf->dry_run to conf->cmd
Date: Mon, 30 Jun 2014 00:13:55 -0500
Message-ID: <1404105243-5071-5-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

conf->dry_run is getting used for many different things besides running
multipath in dry_run mode, and the name and values were getting
increasingly confusing.  This patch switches the variable from
conf->dry_run to conf->cmd, and folds in conf->list.  It also changes
the value to a enum.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h    | 13 +++++++++++--
 libmultipath/configure.c |  2 +-
 libmultipath/discovery.c |  6 ++++--
 multipath/main.c         | 49 ++++++++++++++++++++++++------------------------
 4 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 445525b..eb23820 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -22,6 +22,16 @@ enum devtypes {
 	DEV_DEVMAP
 };
 
+enum mpath_cmds {
+	CMD_CREATE,
+	CMD_DRY_RUN,
+	CMD_LIST_SHORT,
+	CMD_LIST_LONG,
+	CMD_VALID_PATH,
+	CMD_REMOVE_WWID,
+	CMD_RESET_WWIDS,
+};
+
 struct hwentry {
 	char * vendor;
 	char * product;
@@ -78,8 +88,7 @@ struct mpentry {
 
 struct config {
 	int verbosity;
-	int dry_run;
-	int list;
+	enum mpath_cmds cmd;
 	int pgpolicy_flag;
 	int pgpolicy;
 	enum devtypes dev_type;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6ad7a80..107517b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -577,7 +577,7 @@ domap (struct multipath * mpp, char * params)
 	/*
 	 * last chance to quit before touching the devmaps
 	 */
-	if (conf->dry_run && mpp->action != ACT_NOTHING) {
+	if (conf->cmd == CMD_DRY_RUN && mpp->action != ACT_NOTHING) {
 		print_multipath_topology(mpp, conf->verbosity);
 		return DOMAP_DRY;
 	}
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 786e1de..b62a59c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -56,7 +56,8 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 	}
 	pp->udev = udev_device_ref(udevice);
 	err = pathinfo(pp, hwtable,
-		       (conf->dry_run == 3)? flag : (flag | DI_BLACKLIST));
+		       (conf->cmd == CMD_REMOVE_WWID)? flag :
+						       (flag | DI_BLACKLIST));
 	if (err)
 		goto out;
 
@@ -1127,7 +1128,8 @@ get_uid (struct path * pp)
 
 		value = udev_device_get_property_value(pp->udev,
 						       pp->uid_attribute);
-		if ((!value || strlen(value) == 0) && conf->dry_run == 2)
+		if ((!value || strlen(value) == 0) &&
+		    conf->cmd == CMD_VALID_PATH)
 			value = getenv(pp->uid_attribute);
 		if (value && strlen(value)) {
 			size_t len = WWID_SIZE;
diff --git a/multipath/main.c b/multipath/main.c
index 64c8fc5..54b2a74 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -207,18 +207,19 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 		 * If not in "fast list mode", we need to fetch information
 		 * about them
 		 */
-		if (conf->list != 1)
+		if (conf->cmd != CMD_LIST_SHORT)
 			update_paths(mpp);
 
-		if (conf->list > 1)
+		if (conf->cmd == CMD_LIST_LONG)
 			mpp->bestpg = select_path_group(mpp);
 
 		disassemble_status(status, mpp);
 
-		if (conf->list)
+		if (conf->cmd == CMD_LIST_SHORT ||
+		    conf->cmd == CMD_LIST_LONG)
 			print_multipath_topology(mpp, conf->verbosity);
 
-		if (!conf->dry_run)
+		if (conf->cmd == CMD_CREATE)
 			reinstate_paths(mpp);
 	}
 	return 0;
@@ -260,10 +261,11 @@ configure (void)
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
-	if (dev && conf->dev_type == DEV_DEVNODE && conf->dry_run != 3 &&
+	if (dev && conf->dev_type == DEV_DEVNODE &&
+	    conf->cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
-		if (conf->dry_run == 2)
+		if (conf->cmd == CMD_VALID_PATH)
 			printf("%s is not a valid multipath device path\n",
 			       conf->dev);
 		goto out;
@@ -276,13 +278,13 @@ configure (void)
 		int failed = get_refwwid(conf->dev, conf->dev_type, pathvec,
 					 &refwwid);
 		if (!refwwid) {
-			if (failed == 2 && conf->dry_run == 2)
+			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
 				printf("%s is not a valid multipath device path\n", conf->dev);
 			else
 				condlog(3, "scope is nul");
 			goto out;
 		}
-		if (conf->dry_run == 3) {
+		if (conf->cmd == CMD_REMOVE_WWID) {
 			r = remove_wwid(refwwid);
 			if (r == 0)
 				printf("wwid '%s' removed\n", refwwid);
@@ -294,7 +296,7 @@ configure (void)
 			goto out;
 		}
 		condlog(3, "scope limited to %s", refwwid);
-		if (conf->dry_run == 2) {
+		if (conf->cmd == CMD_VALID_PATH) {
 			if (check_wwids_file(refwwid, 0) == 0){
 				printf("%s is a valid multipath device path\n", conf->dev);
 				r = 0;
@@ -311,10 +313,10 @@ configure (void)
 	if (conf->dev)
 		di_flag = DI_WWID;
 
-	if (conf->list > 1)
+	if (conf->cmd == CMD_LIST_LONG)
 		/* extended path info '-ll' */
 		di_flag |= DI_SYSFS | DI_CHECKER;
-	else if (conf->list)
+	else if (conf->cmd == CMD_LIST_SHORT)
 		/* minimum path info '-l' */
 		di_flag |= DI_SYSFS;
 	else
@@ -334,7 +336,7 @@ configure (void)
 
 	filter_pathvec(pathvec, refwwid);
 
-	if (conf->list) {
+	if (conf->cmd != CMD_CREATE && conf->cmd != CMD_DRY_RUN) {
 		r = 0;
 		goto out;
 	}
@@ -456,11 +458,11 @@ main (int argc, char *argv[])
 			conf->allow_queueing = 1;
 			break;
 		case 'c':
-			conf->dry_run = 2;
+			conf->cmd = CMD_VALID_PATH;
 			break;
 		case 'd':
-			if (!conf->dry_run)
-				conf->dry_run = 1;
+			if (conf->cmd == CMD_CREATE)
+				conf->cmd = CMD_DRY_RUN;
 			break;
 		case 'f':
 			conf->remove = FLUSH_ONE;
@@ -469,11 +471,10 @@ main (int argc, char *argv[])
 			conf->remove = FLUSH_ALL;
 			break;
 		case 'l':
-			conf->list = 1;
-			conf->dry_run = 1;
-
 			if (optarg && !strncmp(optarg, "l", 1))
-				conf->list++;
+				conf->cmd = CMD_LIST_LONG;
+			else
+				conf->cmd = CMD_LIST_SHORT;
 
 			break;
 		case 'M':
@@ -499,10 +500,10 @@ main (int argc, char *argv[])
 			usage(argv[0]);
 			exit(0);
 		case 'w':
-			conf->dry_run = 3;
+			conf->cmd = CMD_REMOVE_WWID;
 			break;
 		case 'W':
-			conf->dry_run = 4;
+			conf->cmd = CMD_RESET_WWIDS;
 			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
@@ -558,16 +559,16 @@ main (int argc, char *argv[])
 	}
 	dm_init();
 
-	if (conf->dry_run == 2 &&
+	if (conf->cmd == CMD_VALID_PATH &&
 	    (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
-	if (conf->dry_run == 3 && !conf->dev) {
+	if (conf->cmd == CMD_REMOVE_WWID && !conf->dev) {
 		condlog(0, "the -w option requires a device");
 		goto out;
 	}
-	if (conf->dry_run == 4) {
+	if (conf->cmd == CMD_RESET_WWIDS) {
 		struct multipath * mpp;
 		int i;
 		vector curmp;
-- 
1.8.3.1
