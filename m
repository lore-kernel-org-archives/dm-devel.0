From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 4/4] dm-core: Implement waiting for barrier in
 dm_suspend request
Date: Thu, 08 Jan 2009 17:13:46 +0100
Message-ID: <4966263A.9040401@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Implement waiting for barrier in dm_suspend request.

suspend_lock cannot be used inside barrier processing,
because there can be generated new barrier request during suspend
process (e.g. in lock_fs() call).

Add wait for for ongoing barrier to finish before suspending.

There are two status bits used:
DMF_BLOCK_IO -> all ios are queued
DMF_BARRIER  -> device is processing barrier (always include BLOCK_IO too).

Suspend call simply waits till DMF_BARRIER disappear and immediately
and switch to BLOCK_IO to prevent another barrier to start.

Signed-off-by: Milan Broz <mbroz@redhat.com>

---
 drivers/md/dm.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f3d1ee5..407f4a6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1508,6 +1508,13 @@ static void __flush_deferred_io(struct mapped_device *md, int barrier_flag)
 	while ((c = bio_list_pop(&md->deferred))) {
 		barrier = bio_barrier(c);
 
+		/* FIXME: is this possible here? */
+		/* New barrier and no flag */
+		if (barrier && !test_bit(DMF_BARRIER, &md->flags)) {
+			__submit_barrier(md, c);
+			return;
+		} 
+
 		if (__split_bio(md, c))
 			bio_io_error(c);
 
@@ -1647,6 +1654,47 @@ static void unlock_fs(struct mapped_device *md)
 	clear_bit(DMF_FROZEN, &md->flags);
 }
 
+static int _blockio_if_not_in_barrier(struct mapped_device *md)
+{
+	int in_barrier;
+
+	down_write(&md->io_lock);
+	smp_mb();
+	in_barrier = test_bit(DMF_BARRIER, &md->flags);
+	if (!in_barrier)
+		set_bit(DMF_BLOCK_IO, &md->flags);
+	up_write(&md->io_lock);
+
+	return !in_barrier;
+}
+
+static int dm_wait_blockio(struct mapped_device *md)
+{
+	int r = 0;
+
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (_blockio_if_not_in_barrier(md))
+			break;
+
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		/*
+		 * We cannot use io_schedule here
+		 * all io can be already processed.
+		 * FIXME: starvation here?
+		 */
+		schedule_timeout(HZ/100);
+	}
+	set_current_state(TASK_RUNNING);
+
+	return r;
+}
+
 /*
  * We need to be able to change a mapping table under a mounted
  * filesystem.  For example we might want to move some data in
@@ -1669,12 +1717,6 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
-	 /* FIXME: temporary, it must not fail here  */
-	if (test_bit(DMF_BARRIER, &md->flags)) {
-		r = -EBUSY;
-		goto out_unlock;
-	}
-
 	map = dm_get_table(md);
 
 	/*
@@ -1709,10 +1751,13 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 
 	/*
 	 * First we set the BLOCK_IO flag so no more ios will be mapped.
+	 * But wait for possible ongoing barrier to finish first.
 	 */
-	down_write(&md->io_lock);
-	set_bit(DMF_BLOCK_IO, &md->flags);
+	r = dm_wait_blockio(md);
+	if (r)
+		goto out;
 
+	down_write(&md->io_lock);
 	add_wait_queue(&md->wait, &wait);
 	up_write(&md->io_lock);
 
