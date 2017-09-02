From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 15/31] multipath: implement "check usable paths"
	(-C/-U)
Date: Sun,  3 Sep 2017 00:38:44 +0200
Message-ID: <20170902223900.7339-16-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When we process udev rules, it's crucial to know whether I/O on a given
device will succeed. Unfortunately DM_NR_VALID_PATHS is not reliable,
because the kernel path events aren't necessarily received in order, and
even if they are, the number of usable paths may have changed during
udev processing, in particular when there's a lot of load on udev
because many paths are failing or reinstating at the same time.
The latter problem can't be completely avoided, but the closer the
test before the actual "blkid" call, the better.

This patch adds the -C/-U options to multipath to check if a given
map has usable paths. Obviously this command must avoid doing any I/O
on the multipath map itself, thus no checkers are called; only status
from sysfs and dm is collected.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h |  1 +
 multipath/main.c      | 90 +++++++++++++++++++++++++++++++++++++++++++++++++--
 multipath/multipath.8 | 13 +++++++-
 3 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index ffc69b5f..4aa53da8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -34,6 +34,7 @@ enum mpath_cmds {
 	CMD_REMOVE_WWID,
 	CMD_RESET_WWIDS,
 	CMD_ADD_WWID,
+	CMD_USABLE_PATHS,
 };
 
 enum force_reload_types {
diff --git a/multipath/main.c b/multipath/main.c
index dede017e..704c491f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -117,6 +117,7 @@ usage (char * progname)
 		"  -F      flush all multipath device maps\n"
 		"  -a      add a device wwid to the wwids file\n"
 		"  -c      check if a device should be a path in a multipath device\n"
+		"  -C      check if a multipath device has usable paths\n"
 		"  -q      allow queue_if_no_path when multipathd is not running\n"
 		"  -d      dry run, do not create or update devmaps\n"
 		"  -t      dump internal hardware table\n"
@@ -258,6 +259,81 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 	return 0;
 }
 
+static int check_usable_paths(struct config *conf,
+			      const char *devpath, enum devtypes dev_type)
+{
+	struct udev_device *ud = NULL;
+	struct multipath *mpp = NULL;
+	struct pathgroup *pg;
+	struct path *pp;
+	char *mapname;
+	vector pathvec = NULL;
+	char params[PARAMS_SIZE], status[PARAMS_SIZE];
+	dev_t devt;
+	int r = 1, i, j;
+
+	ud = get_udev_device(devpath, dev_type);
+	if (ud == NULL)
+		return r;
+
+	devt = udev_device_get_devnum(ud);
+	if (!dm_is_dm_major(major(devt))) {
+		condlog(1, "%s is not a dm device", devpath);
+		goto out;
+	}
+
+	mapname = dm_mapname(major(devt), minor(devt));
+	if (mapname == NULL) {
+		condlog(1, "dm device not found: %s", devpath);
+		goto out;
+	}
+
+	if (!dm_is_mpath(mapname)) {
+		condlog(1, "%s is not a multipath map", devpath);
+		goto free;
+	}
+
+	/* pathvec is needed for disassemble_map */
+	pathvec = vector_alloc();
+	if (pathvec == NULL)
+		goto free;
+
+	mpp = dm_get_multipath(mapname);
+	if (mpp == NULL)
+		goto free;
+
+	dm_get_map(mpp->alias, &mpp->size, params);
+	dm_get_status(mpp->alias, status);
+	disassemble_map(pathvec, params, mpp, 0);
+	disassemble_status(status, mpp);
+
+	vector_foreach_slot (mpp->pg, pg, i) {
+		vector_foreach_slot (pg->paths, pp, j) {
+			pp->udev = get_udev_device(pp->dev_t, DEV_DEVT);
+			if (pp->udev == NULL)
+				continue;
+			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
+				continue;
+
+			if (pp->state == PATH_UP &&
+			    pp->dmstate == PSTATE_ACTIVE) {
+				condlog(3, "%s: path %s is usable",
+					devpath, pp->dev);
+				r = 0;
+				goto found;
+			}
+		}
+	}
+found:
+	condlog(2, "%s:%s usable paths found", devpath, r == 0 ? "" : " no");
+free:
+	FREE(mapname);
+	free_multipath(mpp, FREE_PATHS);
+	vector_free(pathvec);
+out:
+	udev_device_unref(ud);
+	return r;
+}
 
 /*
  * Return value:
@@ -522,7 +598,7 @@ main (int argc, char *argv[])
 		exit(1);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
-	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrR:itquwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -547,6 +623,9 @@ main (int argc, char *argv[])
 		case 'c':
 			cmd = CMD_VALID_PATH;
 			break;
+		case 'C':
+			cmd = CMD_USABLE_PATHS;
+			break;
 		case 'd':
 			if (cmd == CMD_CREATE)
 				cmd = CMD_DRY_RUN;
@@ -593,6 +672,10 @@ main (int argc, char *argv[])
 			cmd = CMD_VALID_PATH;
 			dev_type = DEV_UEVENT;
 			break;
+		case 'U':
+			cmd = CMD_USABLE_PATHS;
+			dev_type = DEV_UEVENT;
+			break;
 		case 'w':
 			cmd = CMD_REMOVE_WWID;
 			break;
@@ -674,7 +757,10 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize prioritizers");
 		goto out;
 	}
-
+	if (cmd == CMD_USABLE_PATHS) {
+		r = check_usable_paths(conf, dev, dev_type);
+		goto out;
+	}
 	if (cmd == CMD_VALID_PATH &&
 	    (!dev || dev_type == DEV_DEVMAP)) {
 		condlog(0, "the -c option requires a path to check");
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index b9436e52..a47a027d 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -25,7 +25,7 @@ multipath \- Device mapper target autoconfig.
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \|-u | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-C | \-q | \-r | \-i | \-a | \-u | \-U | \-w | \-W \|]
 .RB [\| \-p\ \c
 .IR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| \-R\ \c
@@ -110,6 +110,12 @@ Set user_friendly_names bindings file location.  The default is
 Check if a block device should be a path in a multipath device.
 .
 .TP
+.B \-C
+Check if a multipath device has usable paths. This can be used to
+test whether or not I/O on this device is likely to succeed. The command
+itself doesn't attempt to do I/O on the device.
+.
+.TP
 .B \-q
 Allow device tables with \fIqueue_if_no_path\fR when multipathd is not running.
 .
@@ -123,6 +129,11 @@ Check if the device specified in the program environment should be
 a path in a multipath device.
 .
 .TP
+.B \-U
+Check if the device specified in the program environment is a multipath device
+with usable paths. See \fB-C\fB.
+.
+.TP
 .B \-w
 Remove the WWID for the specified device from the WWIDs file.
 .
-- 
2.14.0
