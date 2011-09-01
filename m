From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: check if multipath owns path
Date: Thu, 1 Sep 2011 14:28:05 -0500
Message-ID: <20110901192805.GM11793@ether.msp.redhat.com>
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

This adds a new command line option to multipath, "-c".  The -c option takes
a path, and makes multipath check the wwids file to see if the path belongs
to a multipath device.  If it does, multipath exists with 0. If not, it exits
with 1.  Note that this patch only checks the wwids file, so it only works for
LUNs that have already been managed by multipath in the past.  The first time
a LUN is seen, this check will return 1, even if it is a valid path device.

This patch stacks on top of my find_multipaths patch, but it does not
need find_multipaths to be enabled.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/finder.c |    2 +-
 libmultipath/finder.h |    1 +
 multipath/main.c      |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 32 insertions(+), 7 deletions(-)

Index: multipath-tools-110831/libmultipath/finder.c
===================================================================
--- multipath-tools-110831.orig/libmultipath/finder.c
+++ multipath-tools-110831/libmultipath/finder.c
@@ -78,7 +78,7 @@ write_out_wwid(int fd, char *wwid) {
 	return 1;
 }
 
-static int
+int
 check_wwids_file(char *wwid, int write_wwid)
 {
 	int scan_fd, fd, can_write, found, ret;
Index: multipath-tools-110831/libmultipath/finder.h
===================================================================
--- multipath-tools-110831.orig/libmultipath/finder.h
+++ multipath-tools-110831/libmultipath/finder.h
@@ -14,5 +14,6 @@
 
 int should_multipath(struct path *pp, vector pathvec);
 int remember_wwid(char *wwid);
+int check_wwids_file(char *wwid, int write_wwid);
 
 #endif /* _FINDER_H */
Index: multipath-tools-110831/multipath/main.c
===================================================================
--- multipath-tools-110831.orig/multipath/main.c
+++ multipath-tools-110831/multipath/main.c
@@ -51,6 +51,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <finder.h>
 
 int logsink;
 
@@ -79,7 +80,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]\n", progname);
+	fprintf (stderr, "  %s [-c] [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -92,6 +93,7 @@ usage (char * progname)
 		"  -ll     show multipath topology (maximum info)\n" \
 		"  -f      flush a multipath device map\n" \
 		"  -F      flush all multipath device maps\n" \
+		"  -c      check if a device should be a path in a multipath device\n" \
 		"  -d      dry run, do not create or update devmaps\n" \
 		"  -t      dump internal hardware table\n" \
 		"  -r      force devmap reload\n" \
@@ -257,9 +259,13 @@ configure (void)
 	 * if we have a blacklisted device parameter, exit early
 	 */
 	if (dev &&
-	    (filter_devnode(conf->blist_devnode, conf->elist_devnode, dev) > 0))
-			goto out;
-
+	    (filter_devnode(conf->blist_devnode,
+			    conf->elist_devnode, dev) > 0)) {
+		if (conf->dry_run == 2)
+			printf("%s is not a valid multipath device path\n",
+			       conf->dev);
+		goto out;
+	}
 	/*
 	 * scope limiting must be translated into a wwid
 	 * failing the translation is fatal (by policy)
@@ -275,6 +281,15 @@ configure (void)
 		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
 				refwwid) > 0)
 			goto out;
+		if (conf->dry_run == 2) {
+			if (check_wwids_file(refwwid, 0) == 0){
+				printf("%s is a valid multipath device path\n", conf->dev);
+				r = 0;
+			}
+			else
+				printf("%s is not a valid multipath device path\n", conf->dev);
+			goto out;
+		}
 	}
 
 	/*
@@ -398,7 +413,7 @@ main (int argc, char *argv[])
 		condlog(0, "multipath tools need sysfs mounted");
 		exit(1);
 	}
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brt")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:Brt")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -415,8 +430,12 @@ main (int argc, char *argv[])
 		case 'B':
 			conf->bindings_read_only = 1;
 			break;
+		case 'c':
+			conf->dry_run = 2;
+			break;
 		case 'd':
-			conf->dry_run = 1;
+			if (!conf->dry_run)
+				conf->dry_run = 1;
 			break;
 		case 'f':
 			conf->remove = FLUSH_ONE;
@@ -500,6 +519,11 @@ main (int argc, char *argv[])
 	}
 	dm_init();
 
+	if (conf->dry_run == 2 &&
+	    (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
+		condlog(0, "the -c option requires a path to check");
+		goto out;
+	}
 	if (conf->remove == FLUSH_ONE) {
 		if (conf->dev_type == DEV_DEVMAP)
 			r = dm_flush_map(conf->dev);
