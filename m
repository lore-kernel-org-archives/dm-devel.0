From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Free dm_io structure before calling bio_endio
Date: Mon, 1 Mar 2010 19:48:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1003011944510.10656@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This partially fixes a problem described here
https://www.redhat.com/archives/dm-devel/2010-February/msg00109.html
I fixes a bug when device removal happens immediatelly after bio_endio.

Note that rmmod is still not safe. These rmmod bugs seem to be ubiquitous.

Mikulas

---

Free dm_io structure before calling bio_endio

There is a possible race:

thread 1:
bio_endio(bio, io_error);
/* scheduling happens */
					thread 2:
					close the device
					remove the device
thread 1:
free_io(md, io);

Thread 2, when removing the device, sees nonempty md->io_pool (because the
io hasn't been freed by thread 1 yet) and may crash with BUG in mempool_free.
Thread 1 may also crash, when freeing into a nonexisting mempool.

To fix this bug, we must make sure that bio_endio is the last call and
the md structure is not accessed after bio_endio was signaled.

There is another bio_endio in process_barrier, but it is called from the thread
and the thread is destroyed prior to freeing the mempools, so this call is
not affected by the bug.

Similar bug exists for module unloads (the module may be unloaded immediatelly
after bio_endio), but it can't be fixed without redesigning module refcounts.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.33-rc8-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.33-rc8-fast.orig/drivers/md/dm.c	2010-03-01 22:50:47.000000000 +0100
+++ linux-2.6.33-rc8-fast/drivers/md/dm.c	2010-03-01 22:52:48.000000000 +0100
@@ -635,8 +635,10 @@ static void dec_pending(struct dm_io *io
 			if (!md->barrier_error && io_error != -EOPNOTSUPP)
 				md->barrier_error = io_error;
 			end_io_acct(io);
+			free_io(md, io);
 		} else {
 			end_io_acct(io);
+			free_io(md, io);
 
 			if (io_error != DM_ENDIO_REQUEUE) {
 				trace_block_bio_complete(md->queue, bio);
@@ -644,8 +646,6 @@ static void dec_pending(struct dm_io *io
 				bio_endio(bio, io_error);
 			}
 		}
-
-		free_io(md, io);
 	}
 }
 
