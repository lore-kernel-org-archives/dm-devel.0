From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/4] dm: export suspended state
Date: Fri, 20 Nov 2009 16:14:05 +0900
Message-ID: <4B0641BD.6090104@ct.jp.nec.com>
References: <4B06408A.1080700@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B06408A.1080700@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds the exported dm_suspended() function so that targets
can check whether themselves are suspended or not.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c               |   11 +++++++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 12 insertions(+)

Index: 2.6.32-rc7/drivers/md/dm.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm.c
+++ 2.6.32-rc7/drivers/md/dm.c
@@ -2676,6 +2676,17 @@ int dm_suspended_md(struct mapped_device
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_suspended(struct dm_target *ti)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	int r = dm_suspended_md(md);
+
+	dm_put(md);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_suspended);
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	struct mapped_device *md = dm_table_get_md(ti->table);
Index: 2.6.32-rc7/include/linux/device-mapper.h
===================================================================
--- 2.6.32-rc7.orig/include/linux/device-mapper.h
+++ 2.6.32-rc7/include/linux/device-mapper.h
@@ -235,6 +235,7 @@ void dm_uevent_add(struct mapped_device 
 const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
+int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
