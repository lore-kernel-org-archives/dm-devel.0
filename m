From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 48/57] dmparser: Use find_path_by_dev()
Date: Wed, 27 Apr 2016 13:10:49 +0200
Message-ID: <1461755458-29225-49-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

There are two functions for looking up paths, find_path_by_dev() and
find_path_by_devt(). To avoid any inconsistencies we should be
using find_path_by_dev() here and allocate a path with both values.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c |  6 +++++-
 libmultipath/dmparser.c  | 12 +++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index dee749b..ed6cf98 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -969,7 +969,11 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 
 	if (dev_type == DEV_DEVT) {
 		strchop(dev);
-		pp = find_path_by_devt(pathvec, dev);
+		if (devt2devname(buff, FILE_NAME_SIZE, dev)) {
+			condlog(0, "%s: cannot find block device\n", dev);
+			return 1;
+		}
+		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
 			struct udev_device *udevice = udev_device_new_from_devnum(conf->udev, 'b', parse_devt(dev));
 
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index c19c5d2..289be89 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -320,14 +320,23 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 		FREE(word);
 
 		for (j = 0; j < num_paths; j++) {
+			char devname[FILE_NAME_SIZE];
+
 			pp = NULL;
 			p += get_word(p, &word);
 
 			if (!word)
 				goto out;
 
+			if (devt2devname(devname, FILE_NAME_SIZE, word)) {
+				condlog(2, "%s: cannot find block device",
+					word);
+				FREE(word);
+				continue;
+			}
+
 			if (pathvec)
-				pp = find_path_by_devt(pathvec, word);
+				pp = find_path_by_dev(pathvec, devname);
 
 			if (!pp) {
 				pp = alloc_path();
@@ -336,6 +345,7 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 					goto out1;
 
 				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
+				strncpy(pp->dev, devname, FILE_NAME_SIZE);
 				if (strlen(mpp->wwid)) {
 					strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
 				}
-- 
2.6.6
