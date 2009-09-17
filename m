From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm: dec_pending() needs locking to save error
	value
Date: Thu, 17 Sep 2009 10:12:41 +0900
Message-ID: <4AB18D09.9090300@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

While implementing the barrier support patch for request-based dm,
I found a possible bug in bio-based dm.

In the patch posted here:
    http://patchwork.kernel.org/patch/48189/
I added 'barrier_error_lock' to struct mapped_device to save error
values from multiple barrier I/Os safely like below:
	if (error) {
		spin_lock_irqsave(&md->barrier_error_lock, flags);
		if (!md->barrier_error || error == -EOPNOTSUPP ||
		    (md->barrier_error != -EOPNOTSUPP &&
		     error == DM_ENDIO_REQUEUE))
			md->barrier_error = error;
		spin_unlock_irqrestore(&md->barrier_error_lock, flags);
	}

On the other hand, bio-based dm has been doing the same thing
in dec_pending() without any lock:
        if (error && !(io->error > 0 && __noflush_suspending(md)))
                io->error = error;

Though I have never experienced actual problem without locking and
just found this during code inspection, I believe it needs locking
here, too.

This patch adds the locking.
I've done compile, boot and basic I/O testings.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: 2.6.31/drivers/md/dm.c
===================================================================
--- 2.6.31.orig/drivers/md/dm.c
+++ 2.6.31/drivers/md/dm.c
@@ -47,6 +47,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *bio;
 	unsigned long start_time;
+	spinlock_t endio_lock;
 };
 
 /*
@@ -590,8 +591,12 @@ static void dec_pending(struct dm_io *io
 	struct mapped_device *md = io->md;
 
 	/* Push-back supersedes any I/O errors */
-	if (error && !(io->error > 0 && __noflush_suspending(md)))
-		io->error = error;
+	if (unlikely(error)) {
+		spin_lock_irqsave(&io->endio_lock, flags);
+		if (!(io->error > 0 && __noflush_suspending(md)))
+			io->error = error;
+		spin_unlock_irqrestore(&io->endio_lock, flags);
+	}
 
 	if (atomic_dec_and_test(&io->io_count)) {
 		if (io->error == DM_ENDIO_REQUEUE) {
@@ -1300,6 +1305,7 @@ static void __split_and_process_bio(stru
 	atomic_set(&ci.io->io_count, 1);
 	ci.io->bio = bio;
 	ci.io->md = md;
+	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
 	if (unlikely(bio_empty_barrier(bio)))
