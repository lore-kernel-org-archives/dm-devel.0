From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/configure.c libmu ...
Date: 23 Jun 2010 16:28:10 -0000
Message-ID: <20100623162810.7501.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-06-23 16:28:08

Modified files:
	libmultipath   : configure.c discovery.c discovery.h 
	                 structs_vec.c 
	multipathd     : main.c 

Log message:
	Fixes for bzs #599053, #584742, and #597789.
	
	The 599053 fix checks if the sysfs path for a block device exists, when
	wait_for_file can't find a sysfs file.  If the path doesn't exist, it doesn't
	wait, since the block device path should always be there for devices that exist.
	
	The 584742 fix deals with 3 seperate errors, pidfile_check() wasn't closing
	the fd, when pathinfo freed it's fd, it wasn't also freeing the checker,
	which needs to be reinitialized for the new fd. Finally, when you run
	multipath on a resized device, it now uses ACT_RESIZE instead of ACT_RELOAD,
	to properly allow flushing.
	
	The 597789 fix moves setting the multipath hwe to before verifying the path,
	in case the path gets removed during verification.  It also uses checks
	the sysfs block device path, instead of the dev file.
	
	Not applicable upstream

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.8&r2=1.2.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.13&r2=1.32.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14.2.3&r2=1.14.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.4&r2=1.1.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.26&r2=1.69.2.27

--- multipath-tools/libmultipath/configure.c	2010/04/24 05:28:06	1.2.2.8
+++ multipath-tools/libmultipath/configure.c	2010/06/23 16:28:07	1.2.2.9
@@ -177,8 +177,8 @@
 		return;
 	}
 	if (cmpp->size != mpp->size) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (size change)",
+		mpp->action = ACT_RESIZE;
+		condlog(3, "%s: set ACT_RESIZE (size change)",
 			mpp->alias);
 		return;
 	}
@@ -463,6 +463,7 @@
 			strerror(errno));
 		return -1;
 	}
+	close(fd);
 	if (lock.l_type == F_UNLCK)
 		return 0;
 	return 1;
--- multipath-tools/libmultipath/discovery.c	2010/01/27 22:33:29	1.32.2.13
+++ multipath-tools/libmultipath/discovery.c	2010/06/23 16:28:07	1.32.2.14
@@ -162,6 +162,19 @@
 	return r;
 }
 
+int
+check_sysfs_dir(char *sysfs_path, char * dev)
+{
+	char dev_dir[SYSFS_PATH_SIZE];
+	struct stat stats;
+
+	if (sysfs_path && safe_sprintf(dev_dir, "%s/block/%s", sysfs_path, dev))
+		return 1;
+	if (stat(dev_dir, &stats) != 0)
+		return 1;
+	return 0;
+}
+
 /*
  * the daemon can race udev upon path add,
  * not multipath(8), ran by udev
@@ -171,11 +184,11 @@
 #define WAIT_LOOP_PER_SECOND 5
 
 static int
-wait_for_file (char * filename)
+wait_for_file (char * filename, char * sysfs_path, char * dev)
 {
 	int loop;
 	struct stat stats;
-	
+
 	loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
 	
 	while (--loop) {
@@ -185,13 +198,16 @@
 		if (errno != ENOENT)
 			return 1;
 
+		if (sysfs_path && check_sysfs_dir(sysfs_path, dev) != 0)
+			return 1;
+
 		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
 	}
 	return 1;
 }
 #else
 static int
-wait_for_file (char * filename)
+wait_for_file (char * filename, char * sysfs_path, char * dev)
 {
 	return 0;
 }
@@ -207,7 +223,7 @@
 	if (safe_sprintf(attr_path, fmt, sysfs_path, dev)) \
 		return 1; \
 \
-	if (dowait && wait_for_file(attr_path)) \
+	if (dowait && wait_for_file(attr_path, sysfs_path, dev)) \
 		return 1; \
 \
 	if (!(attr = sysfs_open_attribute(attr_path))) \
@@ -320,7 +336,7 @@
 		return -1;
 	}
 
-	if (wait_for_file(devpath)) {
+	if (wait_for_file(devpath, NULL, NULL)) {
 		condlog(3, "failed to open %s", devpath);
 		return -1;
 	}
@@ -857,6 +873,8 @@
 		get_prio(pp);
 
 #ifndef DAEMON
+	if (checker_selected(&pp->checker))
+		checker_put(&pp->checker);
 	close(pp->fd);
 	pp->fd = -1;
 #endif
--- multipath-tools/libmultipath/discovery.h	2010/01/27 16:46:48	1.14.2.3
+++ multipath-tools/libmultipath/discovery.h	2010/06/23 16:28:07	1.14.2.4
@@ -24,6 +24,7 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
+int check_sysfs_dir(char *sysfs_path, char * dev);
 int device_ok_to_add(char *devname);
 int sysfs_get_vendor (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_model (char * sysfs_path, char * dev, char * buff, int len);
--- multipath-tools/libmultipath/structs_vec.c	2009/03/26 03:28:09	1.1.2.4
+++ multipath-tools/libmultipath/structs_vec.c	2010/06/23 16:28:07	1.1.2.5
@@ -378,8 +378,7 @@
 		 * see if path is in sysfs
 		 */
 		if (!(*pp->dev) ||
-		    sysfs_get_dev(sysfs_path, pp->dev, pp->dev_t,
-				  BLK_DEV_SIZE)) {
+		    check_sysfs_dir(sysfs_path, pp->dev)) {
 			if (!(*pp->dev))
 				condlog(3,
 					"%s: removing path %s with no devname",
--- multipath-tools/multipathd/main.c	2010/01/27 17:21:48	1.69.2.26
+++ multipath-tools/multipathd/main.c	2010/06/23 16:28:08	1.69.2.27
@@ -411,8 +411,8 @@
 		if (adopt_paths(vecs->pathvec, mpp))
 			return 1; /* leave path added to pathvec */
 
-		verify_paths(mpp, vecs, NULL);
 		mpp->hwe = pp->hwe;
+		verify_paths(mpp, vecs, NULL);
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	}
