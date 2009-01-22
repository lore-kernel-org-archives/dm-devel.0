From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] crash in dm-io when signal is pending
Date: Wed, 21 Jan 2009 22:04:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901212203090.31606@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

If someone sends signal to a process performing synchronous dm-io call,
the kernel may crash.

The function sync_io attempts to exit with -EINTR if it has pending signal,
however the structure "io" is allocated on stack, so already submitted io
requests end up touching unallocated stack space and corrupting kernel memory.

sync_io sets its state to TASK_UNINTERRUPTIBLE, so the signal can't break out
of io_schedule() --- however, if the signal was pending before sync_io entered
while (1) loop, the corruption of kernel memory will happen.

There is no way to cancel in-progress IOs, so the best solution is to ignore
signals at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6.29-rc1-devel/drivers/md/dm-io.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/drivers/md/dm-io.c	2009-01-22 03:46:09.000000000 +0100
+++ linux-2.6.29-rc1-devel/drivers/md/dm-io.c	2009-01-22 03:46:50.000000000 +0100
@@ -368,16 +368,13 @@ static int sync_io(struct dm_io_client *
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!atomic_read(&io.count) || signal_pending(current))
+		if (!atomic_read(&io.count))
 			break;
 
 		io_schedule();
 	}
 	set_current_state(TASK_RUNNING);
 
-	if (atomic_read(&io.count))
-		return -EINTR;
-
 	if (error_bits)
 		*error_bits = io.error_bits;
 
