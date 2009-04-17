From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: possible regression by the barrier patch in 2.6.30-rc2
Date: Fri, 17 Apr 2009 13:57:02 +0900
Message-ID: <49E80C1E.1040905@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair, Mikulas,

I have reviewed the barrier patch-set and found some possible
regression from 2.6.29 in dm-implement-basic-barrier-support.patch:
   http://git.kernel.org/?p=linux/kernel/git/agk/linux-2.6-dm.git;a=commitdiff;h=af7e466a1acededbc10beaba9eec8531d561c566;hp=92c639021ca6e962645114f02e356e7feb131d0b

Please take a look and consider to fix them (I don't have enough
time to make patches now unfortunately).

1. The semantics of flush suspend has been changed.
   For flush suspend, dm used to flush all bios submitted before
   the invocation of suspend.
   But now, dm may not flush such bios:
     1. submit a barrier => set QUEUE_IO_TO_THREAD flag and kick kdmflush
     2. submit some bios => queued into md->defered if the barrier
                            is still in progress
     3. invoke suspend   => set BLOCK_IO_FOR_SUSPEND flag
                            => kdmflush stops flushing md->defered
                               => complete suspend with holding the bios
   Then, we could expect bios submitted at 2 to be flushed, but
   we can't expect that any more now.
   I think no suspend user wants this semantics change.
   Is it intended change or just a bug?


2. Possible invalid pointer reference problem again.
   Milan had fixed a possible NULL pointer reference in 2.6.29 by
   http://git.kernel.org/?p=linux/kernel/git/agk/linux-2.6-dm.git;a=commitdiff;h=b35f8caa0890169000fec22902290d9a15274cbd;hp=b2174eebd1fadb76454dad09a1dacbc17081e6b0.
   His patch means that we must not touch md after calling bio_endio()
   in dec_pending() because the bio submitter can close/free the md
   once bio_endio() is called.
   The barrier patch breaks his fix and we get the possible invalid
   pointer reference problem again.
   The problematic part is below and free_io() should be called
   before bio_endio().
----------------------------------------------------------------------
-               free_io(md, io);
+               if (bio_barrier(bio)) {
+                       /*
+                        * There can be just one barrier request so we use
+                        * a per-device variable for error reporting.
+                        * Note that you can't touch the bio after end_io_acct
+                        */
+                       md->barrier_error = io_error;
+                       end_io_acct(io);
+               } else {
+                       end_io_acct(io);
 
-               if (io_error != DM_ENDIO_REQUEUE) {
-                       trace_block_bio_complete(md->queue, bio);
+                       if (io_error != DM_ENDIO_REQUEUE) {
+                               trace_block_bio_complete(md->queue, bio);
 
-                       bio_endio(bio, io_error);
+                               bio_endio(bio, io_error);
+                       }
                }
+
+               free_io(md, io);
----------------------------------------------------------------------

Thanks,
Kiyoshi Ueda
