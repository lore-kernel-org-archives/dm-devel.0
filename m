From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 06/12] Make multipath add wwids from kernel
	cmdline mpath.wwids with -A
Date: Mon, 30 Jun 2014 00:13:57 -0500
Message-ID: <1404105243-5071-7-git-send-email-bmarzins@redhat.com>
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

This patch adds another option to multipath, "-A", which reads
/proc/cmdline for mpath.wwid=<WWID> options, and adds any wwids it finds to
/etc/multipath/wwids.  While this isn't usually important during normal
operation, since these wwids should already be added, it can be helpful
during installation, to make sure that multipath can claim devices as its
own, before LVM or something else makes use of them.  The patch also execs
"/sbin/multipath -A" before running multipathd in multipathd.service

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/wwids.c          | 44 +++++++++++++++++++++++++++++++++++++++++++
 libmultipath/wwids.h          |  1 +
 multipath/main.c              | 10 ++++++++--
 multipath/multipath.8         |  5 ++++-
 multipathd/multipathd.service |  1 +
 5 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index eca1799..1dc00bb 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -274,3 +274,47 @@ remember_wwid(char *wwid)
 		condlog(4, "wwid %s already in wwids file", wwid);
 	return 0;
 }
+
+int remember_cmdline_wwid(void)
+{
+	FILE *f = NULL;
+	char buf[LINE_MAX], *next, *ptr;
+	int ret = 0;
+
+	f = fopen("/proc/cmdline", "re");
+	if (!f) {
+		condlog(0, "can't open /proc/cmdline : %s", strerror(errno));
+		return -1;
+	}
+
+	if (!fgets(buf, sizeof(buf), f)) {
+		if (ferror(f))
+			condlog(0, "read of /proc/cmdline failed : %s",
+				strerror(errno));
+		else
+			condlog(0, "couldn't read /proc/cmdline");
+		fclose(f);
+		return -1;
+	}
+	fclose(f);
+	next = buf;
+	while((ptr = strstr(next, "mpath.wwid="))) {
+		ptr += 11;
+		next = strpbrk(ptr, " \t\n");
+		if (next) {
+			*next = '\0';
+			next++;
+		}
+		if (strlen(ptr)) {
+			if (remember_wwid(ptr) != 0)
+				ret = -1;
+		}
+		else {
+			condlog(0, "empty mpath.wwid kernel command line option");
+			ret = -1;
+		}
+		if (!next)
+			break;
+	}
+	return ret;
+}
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index f3b21fa..2fbd419 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -16,5 +16,6 @@ int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
 int remove_wwid(char *wwid);
 int replace_wwids(vector mp);
+int remember_cmdline_wwid(void);
 
 #endif /* _WWIDS_H */
diff --git a/multipath/main.c b/multipath/main.c
index 157475e..ed93f66 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -84,7 +84,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
+	fprintf (stderr, "  %s [-a|-A|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -98,6 +98,8 @@ usage (char * progname)
 		"  -f      flush a multipath device map\n" \
 		"  -F      flush all multipath device maps\n" \
 		"  -a      add a device wwid to the wwids file\n" \
+		"  -A      add devices from kernel command line mpath.wwids\n"
+		"          parameters to wwids file\n" \
 		"  -c      check if a device should be a path in a multipath device\n" \
 		"  -q      allow queue_if_no_path when multipathd is not running\n"\
 		"  -d      dry run, do not create or update devmaps\n" \
@@ -445,7 +447,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":aAdchl::FfM:v:p:b:BrtqwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -518,6 +520,10 @@ main (int argc, char *argv[])
 		case 'a':
 			conf->cmd = CMD_ADD_WWID;
 			break;
+		case 'A':
+			if (remember_cmdline_wwid() != 0)
+				exit(1);
+			exit(0);
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index b6479b1..f6b30c7 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a | \-A | \-w | \-W \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -71,6 +71,9 @@ allow device tables with queue_if_no_path when multipathd is not running
 .B \-a
 add the wwid for the specified device to the wwids file
 .TP
+.B \-A
+add wwids from any kernel command line mpath.wwid parameters to the wwids file
+.TP
 .B \-w
 remove the wwid for the specified device from the wwids file
 .TP
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index be3ba3f..8bb48b5 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -10,6 +10,7 @@ Type=notify
 NotifyAccess=main
 LimitCORE=infinity
 ExecStartPre=/sbin/modprobe dm-multipath
+ExecStartPre=-/sbin/multipath -A
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 
-- 
1.8.3.1
