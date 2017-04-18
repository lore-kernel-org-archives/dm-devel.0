From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH v6 1/3] dm: make some mapped_device functions
	available
Date: Tue, 18 Apr 2017 18:42:38 +0200
Message-ID: <20170418164240.18079-2-enric.balletbo@collabora.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170418164240.18079-1-enric.balletbo@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Guenter Roeck <groeck@google.com>, linux-doc@vger.kernel.org, Brian Norris <briannorris@chromium.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

From: Brian Norris <briannorris@chromium.org>

For init to build a mapped_device, it must hold the appropriate locks,
able to use dm_table_destroy() and the functions to get/set the md
type, so move these to the common header.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
v6: added more functions required
v5: first version of this specific patch in the series
---
 drivers/md/dm.h               |  8 --------
 include/linux/device-mapper.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f298b01..6b501b5 100644
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
@@ -64,7 +63,6 @@ void dm_table_presuspend_undo_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
-unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
@@ -74,14 +72,8 @@ bool dm_table_all_blk_mq_devices(struct dm_table *t);
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
index b7ab76e..9f70b21 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -479,6 +479,11 @@ void dm_table_set_type(struct dm_table *t, unsigned type);
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
@@ -515,6 +520,14 @@ void dm_table_run_md_queue_async(struct dm_table *t);
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
