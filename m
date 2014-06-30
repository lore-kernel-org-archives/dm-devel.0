From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 05/12] allow users to add wwids to
	/etc/multipath/wwids with -a
Date: Mon, 30 Jun 2014 00:13:56 -0500
Message-ID: <1404105243-5071-6-git-send-email-bmarzins@redhat.com>
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

The patch adds a "-a" option to multipath, that allows it to add wwids
to the /etc/multipath wwids file.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h |  1 +
 multipath/main.c      | 17 +++++++++++++++--
 multipath/multipath.8 |  5 ++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index eb23820..ac7c58e 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -30,6 +30,7 @@ enum mpath_cmds {
 	CMD_VALID_PATH,
 	CMD_REMOVE_WWID,
 	CMD_RESET_WWIDS,
+	CMD_ADD_WWID,
 };
 
 struct hwentry {
diff --git a/multipath/main.c b/multipath/main.c
index 54b2a74..157475e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -84,7 +84,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
+	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -97,6 +97,7 @@ usage (char * progname)
 		"  -ll     show multipath topology (maximum info)\n" \
 		"  -f      flush a multipath device map\n" \
 		"  -F      flush all multipath device maps\n" \
+		"  -a      add a device wwid to the wwids file\n" \
 		"  -c      check if a device should be a path in a multipath device\n" \
 		"  -q      allow queue_if_no_path when multipathd is not running\n"\
 		"  -d      dry run, do not create or update devmaps\n" \
@@ -295,6 +296,15 @@ configure (void)
 			}
 			goto out;
 		}
+		if (conf->cmd == CMD_ADD_WWID) {
+			r = remember_wwid(refwwid);
+			if (r == 0)
+				printf("wwid '%s' added\n", refwwid);
+			else
+				printf("failed adding '%s' to wwids file\n",
+				       refwwid);
+			goto out;
+		}
 		condlog(3, "scope limited to %s", refwwid);
 		if (conf->cmd == CMD_VALID_PATH) {
 			if (check_wwids_file(refwwid, 0) == 0){
@@ -435,7 +445,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:BrtqwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -505,6 +515,9 @@ main (int argc, char *argv[])
 		case 'W':
 			conf->cmd = CMD_RESET_WWIDS;
 			break;
+		case 'a':
+			conf->cmd = CMD_ADD_WWID;
+			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index a2262ac..b6479b1 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a | \-w | \-W \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -68,6 +68,9 @@ check if a block device should be a path in a multipath device
 .B \-q
 allow device tables with queue_if_no_path when multipathd is not running
 .TP
+.B \-a
+add the wwid for the specified device to the wwids file
+.TP
 .B \-w
 remove the wwid for the specified device from the wwids file
 .TP
-- 
1.8.3.1
