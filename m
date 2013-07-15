From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/29] Read directly from sysfs when checking the
	device size
Date: Mon, 15 Jul 2013 15:00:15 +0200
Message-ID: <1373893230-26077-15-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

Device sizes might change, so we need to be reading from sysfs
directly to avoid udev still caching the old value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |    5 ++---
 libmultipath/sysfs.c     |    8 +++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 96fe985..82f086b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -320,7 +320,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	struct udev_device *rport_dev = NULL;
 	char value[11];
 	char rport_id[32];
-	unsigned long long tmo;
+	unsigned long long tmo = 0;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
@@ -347,6 +347,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	 */
 	value[0] = '\0';
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
+	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
 		/* Check if we need to temporarily increase dev_loss_tmo */
 		if (sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
@@ -362,8 +363,6 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		}
 		if (mpp->fast_io_fail >= tmo) {
 			snprintf(value, 11, "%u", mpp->fast_io_fail);
-		} else {
-			tmo = 0;
 		}
 	} else if (mpp->dev_loss > 600) {
 		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 22b73b1..bab3837 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -149,14 +149,13 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 int
 sysfs_get_size (struct path *pp, unsigned long long * size)
 {
-	const char * attr;
+	char attr[255];
 	int r;
 
 	if (!pp->udev)
 		return 1;
 
-	attr = udev_device_get_sysattr_value(pp->udev, "size");
-	if (!attr) {
+	if (sysfs_attr_get_value(pp->udev, "size", attr, 255) == 0) {
 		condlog(3, "%s: No size attribute in sysfs", pp->dev);
 		return 1;
 	}
@@ -164,8 +163,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 	r = sscanf(attr, "%llu\n", size);
 
 	if (r != 1) {
-		condlog(3, "%s: Cannot parse size attribute '%s'",
-			pp->dev, attr);
+		condlog(3, "%s: Cannot parse size attribute", pp->dev);
 		return 1;
 	}
 
-- 
1.7.10.4
