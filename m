From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm-sysfs: Add empty release function to avoid
	debug warning.
Date: Tue, 20 Oct 2009 15:07:04 +0200
Message-ID: <1256044024-16099-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

The kobject is embedded in mapped device struct, so
code do not need to release memory explicitly here.

This patch just removes annoying warning:
 kobject: 'dm': does not have a release() function,
 it is broken and must be fixed.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-sysfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 4b04590..b000de3 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -80,12 +80,20 @@ static struct sysfs_ops dm_sysfs_ops = {
 };
 
 /*
+ * The sysfs structure is embedded in md struct, nothing to do here
+ */
+static void dm_sysfs_release(struct kobject *kobj)
+{
+}
+
+/*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
  */
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
+	.release	= dm_sysfs_release
 };
 
 /*
-- 
1.6.5
