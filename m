From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Remove BIO_RW_SYNCIO flag from kcopyd
Date: Sun, 24 Oct 2010 21:02:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Alasdair Graeme Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Remove BIO_RW_SYNCIO flag from kcopyd

This improves write throughput twice when writing to the origin with snapshot
on the same device.

This helps for CFQ I/O scheduler that has separate queues for sync and async
I/O, async is optimized for throughput, sync for latency.
Reallocations are triggered by writes that are usually async, so mark it
as async as well.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.36-rc7-fast.orig/drivers/md/dm-kcopyd.c	2010-10-07 16:09:13.000000000 +0200
+++ linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c	2010-10-15 03:18:52.000000000 +0200
@@ -345,7 +345,7 @@ static int run_io_job(struct kcopyd_job 
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw | REQ_SYNC | REQ_UNPLUG,
+		.bi_rw = job->rw | REQ_UNPLUG,
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = job->offset,
