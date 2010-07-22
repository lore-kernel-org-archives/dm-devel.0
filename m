From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-kcopyd: Remove BIO_RW_SYNCIO flag
Date: Thu, 22 Jul 2010 11:23:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007221121500.19285@hs20-bc2-1.build.redhat.com>
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
Cc: ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Remove BIO_RW_SYNCIO flag from kcopyd

This improves write throughput twice when writing to the origin with snapshot
on the same device.

I don't know the exact reason, BIO_RW_SYNCIO is not documented and
its effects on queueing are not obvious from the code. There seem to
be two sets of limits, one for sync and the other for async requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.34-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.34-fast.orig/drivers/md/dm-kcopyd.c	2010-07-21 17:57:35.000000000 +0200
+++ linux-2.6.34-fast/drivers/md/dm-kcopyd.c	2010-07-22 15:24:02.000000000 +0200
@@ -345,7 +345,7 @@ static int run_io_job(struct kcopyd_job 
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG),
+		.bi_rw = job->rw | (1 << BIO_RW_UNPLUG),
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = job->offset,
