From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c switc ...
Date: 30 Nov 2010 17:21:21 -0000
Message-ID: <20101130172121.26737.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-11-30 17:21:20

Modified files:
	libmultipath   : discovery.c switchgroup.c 

Log message:
	updated fix for bzs #484419 and #570513.
	simplified cciss handling to mirror what upstream does. Simply assume that
	devices named like a cciss device are a cciss device.
	Also, don't divide the priority by the number of enabled paths if that number
	is 0.  Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.16&r2=1.32.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/switchgroup.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4

--- multipath-tools/libmultipath/discovery.c	2010/09/03 03:46:12	1.32.2.16
+++ multipath-tools/libmultipath/discovery.c	2010/11/30 17:21:19	1.32.2.17
@@ -477,24 +477,6 @@
 }
 
 static int
-sysfs_get_driver (char *sysfs_path, char * dev, char *driver)
-{
-	char path[FILE_NAME_SIZE];
-	char buff[SYSFS_NAME_LEN];
-
-	if (safe_sprintf(path, "%s/block/%s/device/driver", sysfs_path, dev)) {
-		condlog(0, "driver path too small");
-		return 1;
-	}
-	if (sysfs_get_link(path, buff, SYSFS_NAME_LEN) < 0) {
-		condlog(0, "can't get driver link: %s", strerror(errno));
-		return 1;
-	}
-	basename(buff, driver);
-	return 0;
-}
-
-static int
 sysfs_get_bus (char * sysfs_path, struct path * pp)
 {
 	struct sysfs_device *sdev;
@@ -536,9 +518,8 @@
 
 	while (loop--) {
 		sdev = sysfs_open_device_path(attr_buff);
-		if(!strncmp(pp->dev,"cciss",5)) 
-                         sysfs_get_driver(sysfs_path, pp->dev,
-                             sdev->bus);
+		if(!strncmp(pp->dev,"cciss",5))
+			strcpy(sdev->bus, "cciss");
 
 		if (strlen(sdev->bus))
 			break;
@@ -549,8 +530,7 @@
 #else
 	sdev = sysfs_open_device_path(attr_buff);
 	if(!strncmp(pp->dev,"cciss",5))
-                  sysfs_get_driver(sysfs_path, pp->dev,
-                     sdev->bus);
+		strcpy(sdev->bus, "cciss");
 #endif
 
 	if (!strncmp(sdev->bus, "scsi", 4))
--- multipath-tools/libmultipath/switchgroup.c	2010/09/03 20:59:14	1.5.2.3
+++ multipath-tools/libmultipath/switchgroup.c	2010/11/30 17:21:19	1.5.2.4
@@ -36,7 +36,7 @@
 				enabled_paths++;
 			}
 		}
-		if (conf->pg_prio_calc == PG_PRIO_CALC_AVG)
+		if (conf->pg_prio_calc == PG_PRIO_CALC_AVG && enabled_paths)
 			pgp->priority = priority / enabled_paths;
 		else
 			pgp->priority = priority;
