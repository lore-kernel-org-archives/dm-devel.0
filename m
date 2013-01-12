From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 04/18] multipath: make devt2devname use lstat
	to check
Date: Sat, 12 Jan 2013 00:04:41 -0600
Message-ID: <1357970695-3396-4-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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

dm_reassign wasn't working correctly for me because devt2devname used stat()
to check if /sys/dev/block/major:minor was a symlink.  But stat() never returns
a symlink, if follows it. It needs to use lstat() instead.  Also, I made
multipath log a message when a dm device gets reassigned to use multipath.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 4 +++-
 libmultipath/sysfs.c     | 6 ++++--
 libmultipath/util.c      | 3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a6e7150..89615b0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1394,8 +1394,10 @@ int dm_reassign(const char *mapname)
 		return 1;
 	}
 
-	if (!(dmt = dm_task_create(DM_DEVICE_DEPS)))
+	if (!(dmt = dm_task_create(DM_DEVICE_DEPS))) {
+		condlog(3, "%s: couldn't make dm task", mapname);
 		return 0;
+	}
 
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 9c554dd..d33747f 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -125,8 +125,10 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 		return 0;
 	}
 
-	if (devt2devname(check_dev, PATH_SIZE, check_devt))
+	if (devt2devname(check_dev, PATH_SIZE, check_devt)) {
+		condlog(1, "can't get devname for %s", check_devt);
 		return 0;
+	}
 
 	condlog(3, "%s: checking holder", check_dev);
 
@@ -153,7 +155,7 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 		}
 		table_name = dm_mapname(major, table_minor);
 
-		condlog(3, "%s: reassign table %s old %s new %s", check_dev,
+		condlog(0, "%s: reassign table %s old %s new %s", check_dev,
 			table_name, check_devt, new_devt);
 
 		dm_reassign_table(table_name, check_devt, new_devt);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 7cdfd28..3ac018c 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -161,6 +161,7 @@ devt2devname (char *devname, int devname_len, char *devt)
 	struct stat statbuf;
 
 	memset(block_path, 0, sizeof(block_path));
+	memset(dev, 0, sizeof(dev));
 	if (sscanf(devt, "%u:%u", &major, &minor) != 2) {
 		condlog(0, "Invalid device number %s", devt);
 		return 1;
@@ -172,7 +173,7 @@ devt2devname (char *devname, int devname_len, char *devt)
 	if (stat("/sys/dev/block", &statbuf) == 0) {
 		/* Newer kernels have /sys/dev/block */
 		sprintf(block_path,"/sys/dev/block/%u:%u", major, minor);
-		if (stat(block_path, &statbuf) == 0) {
+		if (lstat(block_path, &statbuf) == 0) {
 			if (S_ISLNK(statbuf.st_mode) &&
 			    readlink(block_path, dev, FILE_NAME_SIZE) > 0) {
 				char *p = strrchr(dev, '/');
-- 
1.8.0
