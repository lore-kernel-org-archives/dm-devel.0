From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 9/14] barriers
Date: Mon, 23 Feb 2009 14:22:04 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231421510.23293@hs20-bc2-1.build.redhat.com>
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

Allow uninterruptible wait for pending IOs.

Add argument "interruptible" to dm_wait_for_completion that specifies
either interruptible or uninterruptible waiting.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:52:19.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:52:23.000000000 +0100
@@ -1372,7 +1372,7 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static int dm_wait_for_completion(struct mapped_device *md)
+static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 {
 	int r = 0;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1382,13 +1382,13 @@ static int dm_wait_for_completion(struct
 	add_wait_queue(&md->wait, &wait);
 
 	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(interruptible);
 
 		smp_mb();
 		if (!atomic_read(&md->pending))
 			break;
 
-		if (signal_pending(current)) {
+		if (interruptible == TASK_INTERRUPTIBLE && signal_pending(current)) {
 			r = -EINTR;
 			break;
 		}
@@ -1551,7 +1551,7 @@ int dm_suspend(struct mapped_device *md,
 	/*
 	 * Wait for the already-mapped ios to complete.
 	 */
-	r = dm_wait_for_completion(md);
+	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE);
 
 	down_write(&md->io_lock);
 
