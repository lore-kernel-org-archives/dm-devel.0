From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath: add option '-i' to ignore wwids file
Date: Fri,  4 Jul 2014 08:20:11 +0200
Message-ID: <1404454811-21073-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When called from udev the multipath program is used to check
if a device should be handled by multipath. Any new device,
however, will not be present in /etc/multipath/wwids, and
the check will always fail.
This patch implements the option '-i' to multipath to skip
checking the wwids file for these scenarios.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h |  1 +
 multipath/main.c      | 18 +++++++++++-------
 multipath/multipath.8 |  5 ++++-
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index ac7c58e..ca17f39 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -106,6 +106,7 @@ struct config {
 	int max_fds;
 	int force_reload;
 	int queue_without_daemon;
+	int ignore_wwids;
 	int checker_timeout;
 	int daemon;
 #ifdef USE_SYSTEMD
diff --git a/multipath/main.c b/multipath/main.c
index 157475e..fd6262f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -84,7 +84,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
+	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-i] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -103,6 +103,7 @@ usage (char * progname)
 		"  -d      dry run, do not create or update devmaps\n" \
 		"  -t      dump internal hardware table\n" \
 		"  -r      force devmap reload\n" \
+		"  -i      ignore wwids file\n" \
 		"  -B      treat the bindings file as read only\n" \
 		"  -p      policy failover|multibus|group_by_serial|group_by_prio\n" \
 		"  -b fil  bindings file location\n" \
@@ -307,12 +308,12 @@ configure (void)
 		}
 		condlog(3, "scope limited to %s", refwwid);
 		if (conf->cmd == CMD_VALID_PATH) {
-			if (check_wwids_file(refwwid, 0) == 0){
-				printf("%s is a valid multipath device path\n", conf->dev);
+			if (conf->ignore_wwids ||
+			    check_wwids_file(refwwid, 0) == 0)
 				r = 0;
-			}
-			else
-				printf("%s is not a valid multipath device path\n", conf->dev);
+
+			printf("%s %s a valid multipath device path\n",
+			       conf->dev, r == 0 ? "is" : "is not");
 			goto out;
 		}
 	}
@@ -445,7 +446,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritqwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -503,6 +504,9 @@ main (int argc, char *argv[])
 		case 'r':
 			conf->force_reload = 1;
 			break;
+		case 'i':
+			conf->ignore_wwids = 1;
+			break;
 		case 't':
 			r = dump_config();
 			goto out_free_config;
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index b6479b1..13e2e89 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \-w | \-W \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -55,6 +55,9 @@ print internal hardware table to stdout
 .B \-r
 force devmap reload
 .TP
+.B \-i
+ignore wwids file when processing devices
+.TP
 .B \-B
 treat the bindings file as read only
 .TP
-- 
1.8.4.5
