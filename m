From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/3] dm: release _hash_lock when removing device
	in remove_all
Date: Tue, 08 Jun 2010 19:26:34 +0900
Message-ID: <4C0E1ADA.2030003@ct.jp.nec.com>
References: <4C0E19A0.1040804@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C0E19A0.1040804@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch changes dm_hash_remove_all() to release _hash_lock when
removing a device.  After removing the device, dm_hash_remove_all()
takes _hash_lock and searches the hash from scratch again.

This patch is a preparation for the next patch, which changes device
deletion code to wait for md reference to be 0.  Without this patch,
the wait in the next patch may cause AB-BA deadlock:
  CPU0                                CPU1
  -----------------------------------------------------------------------
  dm_hash_remove_all()
    down_write(_hash_lock)
                                      table_status()
                                        md = find_device()
                                               dm_get(md)
                                                 <increment md->holders>
                                        dm_get_live_or_inactive_table()
                                          dm_get_inactive_table()
                                            down_write(_hash_lock)
    <in the md deletion code>
      <wait for md->holders to be 0>

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |   46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

Index: 2.6.35-rc1/drivers/md/dm-ioctl.c
===================================================================
--- 2.6.35-rc1.orig/drivers/md/dm-ioctl.c
+++ 2.6.35-rc1/drivers/md/dm-ioctl.c
@@ -249,40 +249,42 @@ static void __hash_remove(struct hash_ce
 
 static void dm_hash_remove_all(int keep_open_devices)
 {
-	int i, dev_skipped, dev_removed;
+	int i, dev_skipped;
 	struct hash_cell *hc;
-	struct list_head *tmp, *n;
-
-	down_write(&_hash_lock);
+	struct mapped_device *md;
 
 retry:
-	dev_skipped = dev_removed = 0;
-	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_safe (tmp, n, _name_buckets + i) {
-			hc = list_entry(tmp, struct hash_cell, name_list);
+	down_write(&_hash_lock);
+	for (dev_skipped = 0, i = 0; i < NUM_BUCKETS; i++) {
+		list_for_each_entry(hc, _name_buckets + i, name_list) {
+			md = hc->md;
+			dm_get(md);
 
-			if (keep_open_devices &&
-			    dm_lock_for_deletion(hc->md)) {
+			if (keep_open_devices && dm_lock_for_deletion(md)) {
+				dm_put(md);
 				dev_skipped++;
 				continue;
 			}
+
 			__hash_remove(hc);
-			dev_removed = 1;
-		}
-	}
+			up_write(&_hash_lock);
 
-	/*
-	 * Some mapped devices may be using other mapped devices, so if any
-	 * still exist, repeat until we make no further progress.
-	 */
-	if (dev_skipped) {
-		if (dev_removed)
-			goto retry;
+			dm_put(md);
 
-		DMWARN("remove_all left %d open device(s)", dev_skipped);
+			/*
+			 * Some mapped devices may be using other mapped
+			 * devices, so repeat until we make no further
+			 * progress.
+			 * If a new mapped device is created here, it will be
+			 * also removed.
+			 */
+			goto retry;
+		}
 	}
-
 	up_write(&_hash_lock);
+
+	if (dev_skipped)
+		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 
 static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
