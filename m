From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm kcopyd: remove SYNC from flags used in
	dm_io_request
Date: Tue, 23 Nov 2010 18:31:24 -0500
Message-ID: <20101123233124.GC24962@redhat.com>
References: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Removing the REQ_SYNC flag improves write throughput twice when writing
to the origin with a snapshot on the same device (using the CFQ I/O
scheduler).

Sequential write throughput (chunksize of 4k, 32k, 512k)
unpatched:  8.5,  8.6,  9.3 MB/s
patched:   15.2, 18.5, 17.5 MB/s

Snapshot exception reallocations are triggered by writes that are
usually async, so mark the associated dm_io_request as async as well.
This helps when using the CFQ I/O scheduler because it has separate
queues for sync and async I/O, async is optimized for throughput, sync
for latency.  With this change we're consciously favoring throughput
over latency.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-kcopyd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: updated patch header

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
