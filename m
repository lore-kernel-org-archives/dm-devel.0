From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 1/5] dm: move dm_table_destroy() to same header as dm_table_create()
Date: Tue, 11 Apr 2017 17:33:40 +0200
Message-ID: <20170411153344.27092-2-enric.balletbo@collabora.com>
References: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170411153344.27092-1-enric.balletbo@collabora.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Brian Norris <briannorris@chromium.org>
List-Id: dm-devel.ids

From: Brian Norris <briannorris@chromium.org>

If anyone is going to use dm_table_create(), they probably should be
able to use dm_table_destroy() too. Move the dm_table_destroy()
definition outside the private header, near dm_table_create()

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/md/dm.h               | 1 -
 include/linux/device-mapper.h | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f298b01..c54d2f1 100644
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
index a7e6903..70cb6af 100644
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
2.9.3

