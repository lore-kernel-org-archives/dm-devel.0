From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/78] kpartx: use standard 'major' and 'minor'
	macros
Date: Mon, 16 Mar 2015 13:36:25 +0100
Message-ID: <1426509425-15978-39-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of hand-coding our own versions we should be using the
standard 'major' and 'minor' macros.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/devmapper.h |  7 ++++---
 kpartx/kpartx.c    | 13 +++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index d962e43..4b867df 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -1,6 +1,5 @@
-#define MAJOR(dev)      ((dev & 0xfff00) >> 8)
-#define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
-#define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
+#ifndef _KPARTX_DEVMAPPER_H
+#define _KPARTX_DEVMAPPER_H
 
 #ifdef DM_SUBSYSTEM_UDEV_FLAG0
 #define MPATH_UDEV_RELOAD_FLAG DM_SUBSYSTEM_UDEV_FLAG0
@@ -20,3 +19,5 @@ dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(int major, int minor);
 int dm_devn (char * mapname, int *major, int *minor);
 int dm_no_partitions(int major, int minor);
+
+#endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index fac98dc..18c1d23 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -168,8 +168,8 @@ get_hotplug_device(void)
 	if (stat(devname, &buf))
 		return NULL;
 
-	major = (unsigned int)MAJOR(buf.st_rdev);
-	minor = (unsigned int)MINOR(buf.st_rdev);
+	major = major(buf.st_rdev);
+	minor = minor(buf.st_rdev);
 
 	if (!(mapname = dm_mapname(major, minor))) /* Not dm device. */
 		return NULL;
@@ -327,10 +327,8 @@ main(int argc, char **argv){
 	off = find_devname_offset(device);
 
 	if (!loopdev) {
-		uuid = dm_mapuuid((unsigned int)MAJOR(buf.st_rdev),
-				  (unsigned int)MINOR(buf.st_rdev));
-		mapname = dm_mapname((unsigned int)MAJOR(buf.st_rdev),
-				     (unsigned int)MINOR(buf.st_rdev));
+		uuid = dm_mapuuid(major(buf.st_rdev), minor(buf.st_rdev));
+		mapname = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
 	}
 
 	if (!uuid)
@@ -339,8 +337,7 @@ main(int argc, char **argv){
 	if (!mapname)
 		mapname = device + off;
 	else if (!force_devmap &&
-		 dm_no_partitions((unsigned int)MAJOR(buf.st_rdev),
-				  (unsigned int)MINOR(buf.st_rdev))) {
+		 dm_no_partitions(major(buf.st_rdev), minor(buf.st_rdev))) {
 		/* Feature 'no_partitions' is set, return */
 		return 0;
 	}
-- 
1.8.4.5
