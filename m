From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/17] libmultipath: add ignore_new_boot_devs
	option
Date: Mon, 28 Mar 2016 22:13:02 -0500
Message-ID: <1459221194-23222-6-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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

When multipath relies on the wwids file to determine whether a device is
a multipath path (with "multipath -c"), it will fail the first time a
new multipathable device is discovered, since the wwid clearly won't be
in the wwids file.  This is usually fine.  Multipath will still set
itself up on the device, and add the wwid to the wwids file. However,
this causes a race, where multipath won't claim the path immediately,
and something else may.  Later multipath will try, and possibly succeed
at, setting itself up on that device.

I've seen cases where this can cause problems during boot on and
immediately after install, where multipath racing with LVM on an already
labelled device can get the machine into a state where boot fails. This
can be avoided if multipath simply doesn't set itself up on any devices
that it didn't claim (with "multipath -c") in the initramfs.  It can
still safely attempt to set itself up on these devices later in boot,
after the regular filesystem has been set up.

To allow this, this patch adds a new multipahtd commandline option, -n. When
multipathd is run with this set, it will not create multipath devices if
their wwid isn't already in the wwids file. This means that only devices
that are claimed by "multipath -c" will be used by multipathd.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h    |  1 +
 libmultipath/configure.c |  3 +--
 libmultipath/wwids.c     | 19 ++++++++++++-------
 multipathd/main.c        |  9 ++++++---
 multipathd/multipathd.8  |  4 ++++
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 372eace..d6a1d4f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -137,6 +137,7 @@ struct config {
 	int uxsock_timeout;
 	int retrigger_tries;
 	int retrigger_delay;
+	int ignore_new_devs;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3c9badd..1ab3324 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -778,8 +778,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
-		if (conf->find_multipaths && !refwwid &&
-		    !should_multipath(pp1, pathvec)) {
+		if (!refwwid && !should_multipath(pp1, pathvec)) {
 			orphan_path(pp1, "only one path");
 			continue;
 		}
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index f6f8ea8..567c93d 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -266,14 +266,19 @@ should_multipath(struct path *pp1, vector pathvec)
 	int i;
 	struct path *pp2;
 
+	if (!conf->find_multipaths && !conf->ignore_new_devs)
+		return 1;
+
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-	vector_foreach_slot(pathvec, pp2, i) {
-		if (pp1->dev == pp2->dev)
-			continue;
-		if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
-			condlog(3, "found multiple paths with wwid %s, "
-				"multipathing %s", pp1->wwid, pp1->dev);
-			return 1;
+	if (!conf->ignore_new_devs) {
+		vector_foreach_slot(pathvec, pp2, i) {
+			if (pp1->dev == pp2->dev)
+				continue;
+			if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
+				condlog(3, "found multiple paths with wwid %s, "
+					"multipathing %s", pp1->wwid, pp1->dev);
+				return 1;
+			}
 		}
 	}
 	if (check_wwids_file(pp1->wwid, 0) < 0) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 21df7be..8f4fb58 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -518,8 +518,7 @@ rescan:
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	} else {
-		if (conf->find_multipaths &&
-		    !should_multipath(pp, vecs->pathvec)) {
+		if (!should_multipath(pp, vecs->pathvec)) {
 			orphan_path(pp, "only one path");
 			return 0;
 		}
@@ -1572,6 +1571,7 @@ reconfigure (struct vectors * vecs)
 		dm_drv_version(conf->version, TGT_MPATH);
 		conf->verbosity = old->verbosity;
 		conf->bindings_read_only = old->bindings_read_only;
+		conf->ignore_new_devs = old->ignore_new_devs;
 		conf->daemon = 1;
 		configure(vecs, 1);
 		free_config(old);
@@ -2076,7 +2076,7 @@ main (int argc, char *argv[])
 	if (!conf)
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dsv:k::B")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
 	switch(arg) {
 		case 'd':
 			foreground = 1;
@@ -2102,6 +2102,9 @@ main (int argc, char *argv[])
 		case 'B':
 			conf->bindings_read_only = 1;
 			break;
+		case 'n':
+			conf->ignore_new_devs = 1;
+			break;
 		default:
 			;
 		}
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 7fe6597..77f6e72 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -35,6 +35,10 @@ will use its WWID as its alias.
 .TP
 .B -k 
 multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
+.TP
+.B -n
+ignore new devices. Multipathd will not create a multipath device unless the
+wwid for the device is already listed in the wwids file.
 
 .SH COMMANDS
 .TP
-- 
1.8.3.1
