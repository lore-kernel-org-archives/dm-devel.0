From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] Flush deferred queue when dm_suspend() is
	interrupted
Date: Thu, 09 Mar 2006 18:48:29 -0500
Message-ID: <4410BECD.9080908@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030505000803080700040304"
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

This is a multi-part message in MIME format.
--------------030505000803080700040304
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello,

I found in a code review that dm_suspend() doesn't flush
deferred queue when it's interrupted and failed to suspend.

Attached patch theoretically fixes this problem.
But I don't have a testcase to pick this point
and would like to hear comment from others whether
there is something to prevent this.

Also, modifying DMF_BLOCK_IO outside of io_lock may
cause a race like this:
   CPU0 (dm_suspend)         CPU1 (dm_request)
   -------------------------------------------------
   set_bit(DMF_BLOCK_IO)
   ...
   up_write(io_lock)
                               down_read(io_lock)
                               test_bit(DMF_BLOCK_IO)
                               up_read(io_lock)
                               queue_io(deferred)
                                 down_write(io_lock)
                                 test_bit(DMF_BLOCK_IO)
                                 up_write(io_lock)
   clear_bit(DMF_BLOCK_IO)

   The deferred I/O never be flushed until dm_resume().


For the failed dm_suspend() case, there is another problem
that presuspend is not reverted.
It may require a new method like suspend_cancel() for
any target which implements presuspend().

I would appreicate a comment for this as well.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------030505000803080700040304
Content-Type: text/x-patch;
 name="dm-flush-queue-eintr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-flush-queue-eintr.patch"

When dm_suspend() is interrupted, it's possible that some bios are
queued to deferred list.
DMF_BLOCK_IO modification must be protected by io->lock.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>


--- linux-2.6.16-rc5.orig/drivers/md/dm.c	2006-02-27 00:09:35.000000000 -0500
+++ linux-2.6.16-rc5/drivers/md/dm.c	2006-03-08 14:54:09.000000000 -0500
@@ -1152,9 +1152,10 @@ int dm_suspend(struct mapped_device *md,
 	/* were we interrupted ? */
 	r = -EINTR;
 	if (atomic_read(&md->pending)) {
+		clear_bit(DMF_BLOCK_IO, &md->flags);
+		__flush_deferred_io(md, bio_list_get(&md->deferred));
 		up_write(&md->io_lock);
 		unlock_fs(md);
-		clear_bit(DMF_BLOCK_IO, &md->flags);
 		goto out;
 	}
 	up_write(&md->io_lock);

--------------030505000803080700040304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030505000803080700040304--
