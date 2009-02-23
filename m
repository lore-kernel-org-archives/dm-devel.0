From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 8/14] barriers
Date: Mon, 23 Feb 2009 14:21:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231421180.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
List-Id: dm-devel.ids

Move wait queue declaration and unplug to dm_wait_for_completion.

The purpose is to minimize duplicate code in the further patches.

The patch reorders functions a little bit. It doesn't change any
functionality. For proper non-deadlock operation, it is required 
hat add_wait_queue happens before set_current_state(interruptible)
and before the test for !atomic_read(&md->pending) --- and this
patch follows that.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:52:18.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:52:19.000000000 +0100
@@ -1375,6 +1375,11 @@ EXPORT_SYMBOL_GPL(dm_put);
 static int dm_wait_for_completion(struct mapped_device *md)
 {
 	int r = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	dm_unplug_all(md->queue);
+
+	add_wait_queue(&md->wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -1392,6 +1397,8 @@ static int dm_wait_for_completion(struct
 	}
 	set_current_state(TASK_RUNNING);
 
+	remove_wait_queue(&md->wait, &wait);
+
 	return r;
 }
 
@@ -1497,7 +1504,6 @@ static void unlock_fs(struct mapped_devi
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
-	DECLARE_WAITQUEUE(wait, current);
 	int r = 0;
 	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
 	int noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG ? 1 : 0;
@@ -1540,20 +1546,14 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 	set_bit(DMF_BLOCK_IO, &md->flags);
 
-	add_wait_queue(&md->wait, &wait);
 	up_write(&md->io_lock);
 
-	/* unplug */
-	if (map)
-		dm_table_unplug_all(map);
-
 	/*
 	 * Wait for the already-mapped ios to complete.
 	 */
 	r = dm_wait_for_completion(md);
 
 	down_write(&md->io_lock);
-	remove_wait_queue(&md->wait, &wait);
 
 	if (noflush)
 		__merge_pushback_list(md);
