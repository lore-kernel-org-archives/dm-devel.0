From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: get right sysfs value for
	checker_timeout
Date: Tue, 4 Oct 2011 23:15:05 -0500
Message-ID: <20111005041505.GQ24133@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

sysfs_get_timeout() wasn't looking in the correct directory for the
checker timeout value. It was looking at .../block/<devname>/timeout,
instead of  .../block/<devname>/device/timeout

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-110916/libmultipath/discovery.c
===================================================================
--- multipath-tools-110916.orig/libmultipath/discovery.c
+++ multipath-tools-110916/libmultipath/discovery.c
@@ -166,7 +166,7 @@ sysfs_get_timeout(struct sysfs_device *d
 	if (safe_sprintf(attr_path, "%s/device", dev->devpath))
 		return 1;
 
-	len = sysfs_attr_get_value(dev->devpath, "timeout", attr, NAME_SIZE);
+	len = sysfs_attr_get_value(attr_path, "timeout", attr, NAME_SIZE);
 	if (!len) {
 		condlog(3, "%s: No timeout value in sysfs", dev->devpath);
 		return 1;
