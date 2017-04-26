From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/13] dm: Verify suspend_locking assumptions at
	runtime
Date: Wed, 26 Apr 2017 11:37:23 -0700
Message-ID: <20170426183728.10821-9-bart.vanassche@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Ensure that the assumptions about the caller holding suspend_lock
are checked at runtime if lockdep is enabled.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-table.c | 4 ++++
 drivers/md/dm.c       | 9 ++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ad16d9c9d5a..92dbc85af53a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1661,6 +1661,8 @@ static void suspend_targets(struct dm_table *t, enum suspend_mode mode)
 	int i = t->num_targets;
 	struct dm_target *ti = t->targets;
 
+	lockdep_assert_held(&t->md->suspend_lock);
+
 	while (i--) {
 		switch (mode) {
 		case PRESUSPEND:
@@ -1708,6 +1710,8 @@ int dm_table_resume_targets(struct dm_table *t)
 {
 	int i, r = 0;
 
+	lockdep_assert_held(&t->md->suspend_lock);
+
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = t->targets + i;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfb75979e455..78706a04bab4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1686,11 +1686,10 @@ static void event_callback(void *context)
 	wake_up(&md->eventq);
 }
 
-/*
- * Protected by md->suspend_lock obtained by dm_swap_table().
- */
 static void __set_size(struct mapped_device *md, sector_t size)
 {
+	lockdep_assert_held(&md->suspend_lock);
+
 	set_capacity(md->disk, size);
 
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
@@ -2140,8 +2139,6 @@ static void unlock_fs(struct mapped_device *md)
  * If __dm_suspend returns 0, the device is completely quiescent
  * now. There is no request-processing activity. All new requests
  * are being added to md->deferred list.
- *
- * Caller must hold md->suspend_lock
  */
 static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 			unsigned suspend_flags, long task_state,
@@ -2357,6 +2354,8 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_fla
 {
 	struct dm_table *map = NULL;
 
+	lockdep_assert_held(&md->suspend_lock);
+
 	if (md->internal_suspend_count++)
 		return; /* nested internal suspend */
 
-- 
2.12.2
