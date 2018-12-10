From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] dm: fix inflight IO check
Date: Mon, 10 Dec 2018 15:45:53 -0700
Message-ID: <4fec4b01-35f9-8008-22ec-2ac8af58b854@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

After switching to percpu inflight counters, the inflight check
is totally buggy. It's perfectly valid for some counters to be
non-zero while having a total inflight IO count of 0, that's how
these kinds of counters work (inc on one CPU, dec on another).
Fix the md_in_flight() check to sum all counters before returning
a false positive, potentially.

While at it, remove the inflight read for IO completion. We don't
need it, just wake anyone that's waiting for the IO count to drop
to zero. The caller needs to re-check that value anyway when woken,
which it does.

Fixes: 6f75723190d8 ("dm: remove the pending IO accounting")
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 70568f8b6c53..79ad4b3d215c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -650,14 +650,14 @@ static bool md_in_flight(struct mapped_device *md)
 {
 	int cpu;
 	struct hd_struct *part = &dm_disk(md)->part0;
+	long sum = 0;
 
 	for_each_possible_cpu(cpu) {
-		if (part_stat_local_read_cpu(part, in_flight[0], cpu) ||
-		    part_stat_local_read_cpu(part, in_flight[1], cpu))
-			return true;
+		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
+		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
 	}
 
-	return false;
+	return sum != 0;
 }
 
 static void start_io_acct(struct dm_io *io)
@@ -691,10 +691,8 @@ static void end_io_acct(struct dm_io *io)
 				    true, duration, &io->stats_aux);
 
 	/* nudge anyone waiting on suspend queue */
-	if (unlikely(waitqueue_active(&md->wait))) {
-		if (!md_in_flight(md))
-			wake_up(&md->wait);
-	}
+	if (unlikely(waitqueue_active(&md->wait)))
+		wake_up(&md->wait);
 }
 
 /*

-- 
Jens Axboe
