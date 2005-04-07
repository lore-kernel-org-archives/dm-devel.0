From: k-ueda@ct.jp.nec.com
Subject: [PATCH] self-contained "kpartx kicker"
Date: Wed, 06 Apr 2005 21:16:15 -0400 (EDT)
Message-ID: <18113.209345802$1112836498@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I think that self-contained "kpartx kicker" which doesn't require
shell is needed for / on dm-multipath.
The attached patch makes kpartx works like /etc/dev.d/block/multipath.dev
if kpartx is called as "kpartx.dev".
The patch is for multipath-tools-0.4.4-pre8.

Any comments are welcome.


Background
----------
If you have / on a partition on dm-multipath device, kpartx has to
be launched on the initramfs.
/etc/dev.d/block/multipath.dev does it over hotplug event, but
multipath.dev is shell script.

In the initramfs of Fedora / RedHat, /bin/sh and any libraries aren't
included.  I feel it is their policy and I think it isn't recommended
to run shell scritp on the initramfs of Fedora / RedHat.

So other kpartx kicker as a command is needed for Fedora / RedHat.


Proposal
--------
o Add the feature to kpartx which works like multipath.dev when it is
  called as "kpartx.dev" over hotplug event.
  (Following patch is an implementation for this proposal.)

o Add the feature to kpartx which scans some directory (like
 /dev/mapper, /sys/block and so on) to search dm device and makes
  device-map for only dm device.
  If this feature is included, it is only necessary to launch the
  feature once.
  (No patch.)

o Add the feature to multipath command which launch kpartx after
  the multipath device is created.
  (No patch.)

I feel that the first one is straitforward solution, as using hotplug 
is current trend.


Patch
-----

diff -rup multipath-tools-0.4.4-pre8/kpartx/kpartx.c kpartx-0.4.4-pre8/kpartx/kpartx.c
--- multipath-tools-0.4.4-pre8/kpartx/kpartx.c	2005-02-20 17:15:50.000000000 -0500
+++ kpartx-0.4.4-pre8/kpartx/kpartx.c	2005-04-06 20:47:51.000000000 -0400
@@ -22,6 +22,7 @@
 #include <ctype.h>
 #include <libdevmapper.h>
 #include <devmapper.h>
+#include <linux/kdev_t.h>
 
 #include "crc32.h"
 
@@ -124,7 +125,43 @@ find_devname_offset (char * device)
 
 	return (int)(q - device) + 1;
 }
-			
+
+static char *
+get_hotplug_device()
+{
+	unsigned int major, minor, off, len;
+	char *mapname = NULL, *devname = NULL, *device = NULL;
+	struct stat buf;
+
+	if(strcmp(getenv("ACTION"), "add"))
+		return NULL;
+
+	/* Get dm mapname for hotpluged device. */
+	if (!(devname = getenv("DEVNAME")))
+		return NULL;
+	if (stat(devname, &buf))
+		return NULL;
+	major = (unsigned int)MAJOR(buf.st_rdev);
+	minor = (unsigned int)MINOR(buf.st_rdev);
+	if (!(mapname = dm_mapname(major, minor))) /* Not dm device. */
+		return NULL;
+
+	off = find_devname_offset(devname);
+	len = strlen(mapname);
+	/* Dirname + mapname + \0 */
+	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1))))
+		return NULL;
+
+	/* Create new device name. */
+	snprintf(device, off + 1, "%s", devname);
+	snprintf(device + off, len + 1, "%s", mapname);
+	if (strlen(device) != (off + len)) {
+		return NULL;
+	}
+
+	return device;
+}
+
 int
 main(int argc, char **argv){
         int fd, i, j, k, n, op, off, arg;
@@ -132,12 +169,14 @@ main(int argc, char **argv){
 	struct pt *ptp;
 	enum action what = LIST;
 	char *p, *type, *diskdevice, *device;
+	char *progname;
 	int lower, upper;
 	int verbose = 0;
 	char partname[PARTNAME_SIZE], params[PARTNAME_SIZE + 16];
 	char * loopdev = NULL;
 	char * delim = NULL;
 	int loopro = 0;
+	int hotplug = 0;
 	struct stat buf;
 
 	initpts();
@@ -147,8 +186,22 @@ main(int argc, char **argv){
 	type = device = diskdevice = NULL;
 	memset(&all, 0, sizeof(all));
 	memset(&partname, 0, sizeof(partname));
-	
-	if (argc < 2) {
+
+	/* Check whether hotplug mode. */
+	progname = strrchr(argv[0], '/');
+	if (!progname)
+		progname = argv[0];
+	else
+		progname++;
+	if (!strcmp(progname, "kpartx.dev")) { /* Hotplug mode */
+		hotplug = 1;
+
+		/* Setup for original kpartx variables */
+		if (!(device = get_hotplug_device()))
+			exit(1);
+		diskdevice = device;
+		what = ADD;
+	} else if (argc < 2) {
 		usage();
 		exit(1);
 	}
@@ -193,7 +246,8 @@ main(int argc, char **argv){
 		exit(1);
 	}
 
-	if (optind == argc-2) {
+	if (hotplug) {
+	} else if (optind == argc-2) {
 		device = argv[optind];
 		diskdevice = argv[optind+1];
 	} else if (optind == argc-1) {
diff -rup multipath-tools-0.4.4-pre8/kpartx/devmapper.c kpartx-0.4.4-pre8/kpartx/devmapper.c
--- multipath-tools-0.4.4-pre8/kpartx/devmapper.c	2005-04-04 08:49:46.000000000 -0400
+++ kpartx-0.4.4-pre8/kpartx/devmapper.c	2005-04-06 20:48:51.000000000 -0400
@@ -121,3 +121,47 @@ dm_map_present (char * str)
 	dm_task_destroy (dmt);
 	return r;
 }
+
+/* Copy from libmultipath/devmapper.c */
+char *
+dm_mapname(int major, int minor)
+{
+	unsigned next = 0;
+	struct dm_names *names;
+	struct dm_task *dmt;
+	char *mapname = NULL;
+	int len;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
+		return 0;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!(names = dm_task_get_names(dmt)))
+		goto out;
+
+	if (!names->dev) {
+		printf("No devices found\n");
+		goto out;
+	}
+
+	do {
+		names = (void *) names + next;
+		if ((int) MAJOR(names->dev) == major &&
+		    (int) MINOR(names->dev) == minor) {
+			printf("%s", names->name);
+			len = strlen(names->name) + 1;
+			mapname = malloc(len);
+			strncpy(mapname, names->name, len);
+			goto out;
+		}
+		next = names->next;
+	} while (next);
+
+	out:
+	dm_task_destroy(dmt);
+	return mapname;
+}
diff -rup multipath-tools-0.4.4-pre8/kpartx/devmapper.h kpartx-0.4.4-pre8/kpartx/devmapper.h
--- multipath-tools-0.4.4-pre8/kpartx/devmapper.h	2005-03-30 16:48:27.000000000 -0500
+++ kpartx-0.4.4-pre8/kpartx/devmapper.h	2005-04-06 20:35:51.000000000 -0400
@@ -2,3 +2,4 @@ int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned long);
 int dm_map_present (char *);
+char * dm_mapname(int major, int minor);


Best regards,
Ky (Kiyoshi Ueda)
