From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 2/5] dm: move dm definitions outside the private header to boot dm targets.
Date: Tue, 11 Apr 2017 17:33:41 +0200
Message-ID: <20170411153344.27092-3-enric.balletbo@collabora.com>
References: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170411153344.27092-1-enric.balletbo@collabora.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

To boot to device-mapper targets without an initr* we should be able to
use some dm functions, move these to the device-mapper include file so
we can call these functions from init/*

The functions moved are:

  dm_table_get_type()
  dm_lock_md_type()
  dm_unlock_md_type()
  dm_set_md_type()
  dm_get_md_type()
  dm_setup_md_queue()

Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/md/dm.h               | 7 -------
 include/linux/device-mapper.h | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index c54d2f1..6b501b5 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -63,7 +63,6 @@ void dm_table_presuspend_undo_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
-unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
@@ -73,14 +72,8 @@ bool dm_table_all_blk_mq_devices(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
-void dm_lock_md_type(struct mapped_device *md);
-void dm_unlock_md_type(struct mapped_device *md);
-void dm_set_md_type(struct mapped_device *md, unsigned type);
-unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
-int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
-
 /*
  * To check the return value from dm_table_find_target().
  */
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 70cb6af..013ac2e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -513,6 +513,14 @@ void dm_table_run_md_queue_async(struct dm_table *t);
 struct dm_table *dm_swap_table(struct mapped_device *md,
 			       struct dm_table *t);
 
+unsigned dm_table_get_type(struct dm_table *t);
+
+void dm_lock_md_type(struct mapped_device *md);
+void dm_unlock_md_type(struct mapped_device *md);
+void dm_set_md_type(struct mapped_device *md, unsigned type);
+unsigned dm_get_md_type(struct mapped_device *md);
+int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
+
 /*
  * A wrapper around vmalloc.
  */
-- 
2.9.3

