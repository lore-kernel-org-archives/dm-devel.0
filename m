From: Brian Norris <briannorris@chromium.org>
Subject: [PATCH] dm: move dm_table_destroy() to same header as dm_table_create()
Date: Tue, 28 Mar 2017 11:31:02 -0700
Message-ID: <20170328183102.80620-1-briannorris@chromium.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Brian Norris <briannorris@chromium.org>
List-Id: dm-devel.ids

If anyone is going to use dm_table_create(), they probably should be
able to use dm_table_destroy() too. Move the dm_table_destroy()
definition outside the private header, near dm_table_create()

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/md/dm.h               | 1 -
 include/linux/device-mapper.h | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f298b01f7ab3..c54d2f1934ce 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -48,7 +48,6 @@ struct dm_md_mempools;
 /*-----------------------------------------------------------------
  * Internal table functions.
  *---------------------------------------------------------------*/
-void dm_table_destroy(struct dm_table *t);
 void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a7e6903866fd..70cb6af56f67 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -472,6 +472,11 @@ void dm_table_set_type(struct dm_table *t, unsigned type);
 int dm_table_complete(struct dm_table *t);
 
 /*
+ * Destroy the table when finished.
+ */
+void dm_table_destroy(struct dm_table *t);
+
+/*
  * Target may require that it is never sent I/O larger than len.
  */
 int __must_check dm_set_target_max_io_len(struct dm_target *ti, sector_t len);
-- 
2.12.2.564.g063fe858b8-goog

