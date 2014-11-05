From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm: do not call dm_sync_table() when creating
	new devices
Date: Wed,  5 Nov 2014 14:35:50 +0100
Message-ID: <1415194550-121498-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

When creating new devices dm_sync_table() calls
synchronize_rcu_expedited(), causing _all_ pending
RCU pointers to be flushed. This causes a latency
overhead especially noticeable when creating lots
of devices.
And all of this is pointless as there are no old
maps to be disconnected, and hence no stale pointers
which would need to be cleared up.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 58f3927..2c2c6cf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2341,7 +2341,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	else
 		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
-	dm_sync_table(md);
+	if (old_map)
+		dm_sync_table(md);
 
 	return old_map;
 }
@@ -2782,7 +2783,8 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	 * flush_workqueue(md->wq).
 	 */
 	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
-	synchronize_srcu(&md->io_barrier);
+	if (map)
+		synchronize_srcu(&md->io_barrier);
 
 	/*
 	 * Stop md->queue before flushing md->wq in case request-based
@@ -2802,7 +2804,8 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 
 	if (noflush)
 		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
-	synchronize_srcu(&md->io_barrier);
+	if (map)
+		synchronize_srcu(&md->io_barrier);
 
 	/* were we interrupted ? */
 	if (r < 0) {
-- 
1.8.5.2
