From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: don't set queue_if_no_path without
	multipathd
Date: Fri, 16 Sep 2011 22:01:51 -0500
Message-ID: <20110917030151.GJ24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

If multipathd is not running, when all paths to a device have failed, there's
no way for them to automatically get restored.  If the device is set to queue,
whatever is accessing it will hang forever. This can lead to problems if it
happens at boot-up.  This patch unsets queue_if_no_path for all devices created
when multipathd is not running. When multipathd starts, it will automatically
get reset queue_if_no_path to the proper value.  This new behaviour can be
overridden using the new "-q" option to multipath.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h    |    1 +
 libmultipath/configure.c |   13 ++++++++++++-
 libmultipath/file.c      |   32 ++++++++++++++++++++++++++++++++
 libmultipath/file.h      |    1 +
 multipath/main.c         |    8 ++++++--
 5 files changed, 52 insertions(+), 3 deletions(-)

Index: multipath-tools-110831/libmultipath/config.h
===================================================================
--- multipath-tools-110831.orig/libmultipath/config.h
+++ multipath-tools-110831/libmultipath/config.h
@@ -93,6 +93,7 @@ struct config {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int find_multipaths;
+	int allow_queueing;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
Index: multipath-tools-110831/libmultipath/configure.c
===================================================================
--- multipath-tools-110831.orig/libmultipath/configure.c
+++ multipath-tools-110831/libmultipath/configure.c
@@ -36,6 +36,7 @@
 #include "prio.h"
 #include "util.h"
 #include "finder.h"
+#include "file.h"
 
 extern int
 setup_map (struct multipath * mpp, char * params, int params_size)
@@ -569,7 +570,17 @@ coalesce_paths (struct vectors * vecs, v
 		if (r == DOMAP_DRY)
 			continue;
 
-		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
+		if (!conf->daemon && !conf->allow_queueing &&
+		    !pidfile_check(DEFAULT_PIDFILE)) {
+			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+				condlog(3, "%s: multipathd not running, unset "
+					"queue_if_no_path feature", mpp->alias);
+			if (!dm_queue_if_no_path(mpp->alias, 0))
+				remove_feature(&mpp->features,
+					       "queue_if_no_path");
+		}
+		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
 				condlog(3, "%s: unset queue_if_no_path feature",
 					mpp->alias);
Index: multipath-tools-110831/multipath/main.c
===================================================================
--- multipath-tools-110831.orig/multipath/main.c
+++ multipath-tools-110831/multipath/main.c
@@ -80,7 +80,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-c] [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]\n", progname);
+	fprintf (stderr, "  %s [-c] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -94,6 +94,7 @@ usage (char * progname)
 		"  -f      flush a multipath device map\n" \
 		"  -F      flush all multipath device maps\n" \
 		"  -c      check if a device should be a path in a multipath device\n" \
+		"  -q      allow queue_if_no_path when multipathd is not running\n"\
 		"  -d      dry run, do not create or update devmaps\n" \
 		"  -t      dump internal hardware table\n" \
 		"  -r      force devmap reload\n" \
@@ -413,7 +414,7 @@ main (int argc, char *argv[])
 		condlog(0, "multipath tools need sysfs mounted");
 		exit(1);
 	}
-	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:Brt")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:Brtq")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -433,6 +434,9 @@ main (int argc, char *argv[])
 		case 'c':
 			conf->dry_run = 2;
 			break;
+		case 'q':
+			conf->allow_queueing = 1;
+			break;
 		case 'd':
 			if (!conf->dry_run)
 				conf->dry_run = 1;
Index: multipath-tools-110831/libmultipath/file.c
===================================================================
--- multipath-tools-110831.orig/libmultipath/file.c
+++ multipath-tools-110831/libmultipath/file.c
@@ -176,3 +176,35 @@ fail:
 	close(fd);
 	return -1;
 }
+
+int pidfile_check(const char *file)
+{
+	int fd;
+	struct flock lock;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		if (errno == ENOENT)
+			return 0;
+		condlog(0, "Cannot open pidfile, %s : %s", file,
+			strerror(errno));
+		return -1;
+	}
+	lock.l_type = F_WRLCK;
+	lock.l_start = 0;
+	lock.l_whence = SEEK_SET;
+	lock.l_len = 0;
+
+	if (fcntl(fd, F_GETLK, &lock) < 0) {
+		condlog(0, "Cannot check lock on pidfile, %s : %s", file,
+			strerror(errno));
+		return -1;
+	}
+	close(fd);
+	if (lock.l_type == F_UNLCK)
+		return 0;
+	return 1;
+}
+
+
+
Index: multipath-tools-110831/libmultipath/file.h
===================================================================
--- multipath-tools-110831.orig/libmultipath/file.h
+++ multipath-tools-110831/libmultipath/file.h
@@ -7,5 +7,6 @@
 
 #define FILE_TIMEOUT 30
 int open_file(char *file, int *can_write, char *header);
+int pidfile_check(const char *file);
 
 #endif /* _FILE_H */
