From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] dm-log-writes: invalidate the bdev's for both of our devices
Date: Tue, 28 Nov 2017 12:30:25 -0500
Message-ID: <1511890225-16601-1-git-send-email-josef@toxicpanda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: snitzer@redhat.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-Id: dm-devel.ids

From: Josef Bacik <jbacik@fb.com>

Amir noticed that sometimes the xfstests using dm-log-writes would fail
randomly but would work fine after trying again manually.  This is
because dm-log-writes writes directly to the device, but the log replay
tools read and write via the block device page cache.  Sometimes this
resulted in stale data being in the block device's page cache which
would result in random failures.  To handle this simply invalidate the
block device page cache on destruction so any replay of the log device
that follows will be forced to read the new real contents.

Reported-and-tested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 drivers/md/dm-log-writes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 8b80a9ce9ea9..1c502930af5e 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -545,6 +545,8 @@ static void log_writes_dtr(struct dm_target *ti)
 		   !atomic_read(&lc->pending_blocks));
 	kthread_stop(lc->log_kthread);
 
+	invalidate_bdev(lc->logdev->bdev);
+	invalidate_bdev(lc->dev->bdev);
 	WARN_ON(!list_empty(&lc->logging_blocks));
 	WARN_ON(!list_empty(&lc->unflushed_blocks));
 	dm_put_device(ti, lc->dev);
-- 
2.7.5
