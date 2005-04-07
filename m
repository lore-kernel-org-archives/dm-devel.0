From: k-ueda@ct.jp.nec.com
Subject: Re: [PATCH] self-contained "kpartx kicker"
Date: Thu, 07 Apr 2005 15:49:07 -0400 (EDT)
Message-ID: <12294.917778536$1112912854@news.gmane.org>
References: <20050406.211615.74755485.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
	<20050407081508.GA2617@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050407081508.GA2617@averon.dyndns.org>
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

Hello Christophe, Alasdair,

Thank you for some comments.
I attach the fixed patch.

On Thu, 7 Apr 2005 10:15:08 +0200, Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> It's a nice to have feature, but I don't really understand the 
> reasons you present :
> kpartx needs running only after multipath, if multipath is execed
> from initrd why bother doing kpartx in initramfs ?
> 
> Either we need to do the same "hotplug mode" in multipath too, or nothing.
> 
> I guess the former brings more freedom to distributors as they can
> choose how they want to run, and it is overall good for performance
> and memory utilisation.

In boot up sequence, the init process execs /init.
nash is a very small shell used in /init of Fedora, Red Hat
Enterprise Linux, etc.
nash has very limited functions, e.g. it doesn't have control 
statements (like if, for, while) and shell variables.

This is enough for commands like multipath, lvm, dmraid which scan
devices themselves for set up.  For example, the set up of multipath
can be written in /init like following.
So no need for the self-contained "hotplug mode" in multipath.

------------------------------
#!/sbin/nash
...
snip
...
insmod "SCSI-DRIVERS"
insmod "DM-MULTIPATH-MODULES"
/sbin/multipath -v0 -S
------------------------------

On the other hand, we have to specify a device for kpartx.
As we can't know what devices will be created by multipath command
in the system, script can't be written in /init.
So self-contained "hotplug mode" is needed in only kpartx.

Best regards,
Ky (Kiyoshi Ueda)


diff -rup multipath-tools-0.4.4-pre8/kpartx/kpartx.c kpartx-0.4.4-pre8/kpartx/kpartx.c
--- multipath-tools-0.4.4-pre8/kpartx/kpartx.c	2005-02-20 17:15:50.000000000 -0500
+++ kpartx-0.4.4-pre8/kpartx/kpartx.c	2005-04-07 14:12:08.000000000 -0400
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
+++ kpartx-0.4.4-pre8/kpartx/devmapper.c	2005-04-07 14:14:06.000000000 -0400
@@ -121,3 +121,34 @@ dm_map_present (char * str)
 	dm_task_destroy (dmt);
 	return r;
 }
+
+char *
+dm_mapname(int major, int minor)
+{
+	struct dm_task *dmt;
+	int len;
+	char *name = NULL, *mapname = NULL;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return 0;
+
+	dm_task_no_open_count(dmt);
+	dm_task_set_major(dmt, major);
+	dm_task_set_minor(dmt, minor);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!(name = dm_task_get_name(dmt)))
+		goto out;
+
+        len = strlen(name) + 1;
+        if (!(mapname = malloc(len)))
+		goto out;
+
+        strncpy(mapname, name, len);
+
+out:
+	dm_task_destroy(dmt);
+	return mapname;
+}
diff -rup multipath-tools-0.4.4-pre8/kpartx/devmapper.h kpartx-0.4.4-pre8/kpartx/devmapper.h
--- multipath-tools-0.4.4-pre8/kpartx/devmapper.h	2005-03-30 16:48:27.000000000 -0500
+++ kpartx-0.4.4-pre8/kpartx/devmapper.h	2005-04-07 14:12:08.000000000 -0400
@@ -2,3 +2,4 @@ int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned long);
 int dm_map_present (char *);
+char * dm_mapname(int major, int minor);
