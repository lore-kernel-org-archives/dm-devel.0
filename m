From: Minfei Huang <huangminfei@ucloud.cn>
Subject: [PATCH] dm-io: Fix a race condition in the wake up code for sync_io
Date: Sat, 28 Jun 2014 08:21:46 +0800
Message-ID: <1403914906-577-1-git-send-email-huangminfei@ucloud.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>
List-Id: dm-devel.ids

There's a race condition between the atomic_dec_and_test(&io->count)
in dec_count() and the waking of the sync_io() thread.  If the thread
is spuriously woken immediately after the decrement it may exit,
making the on the stack io struct invalid, yet the dec_count could
still be using it.

There are smaller fixes than the one here (eg, just take the io object
off the stack).  But I feel this code could use a clean up.

- simplify dec_count().

  - It always calls a callback fn now.
  - It always frees the io object back to the pool.

- sync_io()

  - Take the io object off the stack and allocate it from the pool the
    same as async_io.
  - Use a completion object rather than an explicit io_schedule()
    loop.  The callback triggers the completion.

Signed-off-by: Minfei Huang <huangminfei@ucloud.cn>
---
 drivers/md/dm-io.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3842ac7..05583da 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -10,6 +10,7 @@
 #include <linux/device-mapper.h>
 
 #include <linux/bio.h>
+#include <linux/completion.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -32,7 +33,7 @@ struct dm_io_client {
 struct io {
 	unsigned long error_bits;
 	atomic_t count;
-	struct task_struct *sleeper;
+	struct completion *wait;
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
@@ -121,8 +122,8 @@ static void dec_count(struct io *io, unsigned int region, int error)
 			invalidate_kernel_vmap_range(io->vma_invalidate_address,
 						     io->vma_invalidate_size);
 
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+		if (io->wait)
+			complete(io->wait);
 
 		else {
 			unsigned long r = io->error_bits;
@@ -387,6 +388,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	 */
 	volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
 	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
@@ -395,7 +397,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = current;
+	io->wait = &wait;
 	io->client = client;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
@@ -403,15 +405,9 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
-	while (1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (!atomic_read(&io->count))
-			break;
-
-		io_schedule();
+	while (atomic_read(&io->count) != 0) {
+		wait_for_completion_io_timeout(&wait, 5);
 	}
-	set_current_state(TASK_RUNNING);
 
 	if (error_bits)
 		*error_bits = io->error_bits;
@@ -434,7 +430,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = NULL;
+	io->wait = NULL;
 	io->client = client;
 	io->callback = fn;
 	io->context = context;
-- 
1.7.1
