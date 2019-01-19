From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/4] dm: fix missing bio_split() pattern code in
	__split_and_process_bio()
Date: Sat, 19 Jan 2019 13:05:05 -0500
Message-ID: <20190119180506.1300-4-snitzer@redhat.com>
References: <20190119180506.1300-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190119180506.1300-1-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Use the same BIO_QUEUE_ENTERED pattern that was established by commit
cd4a4ae4683dc ("block: don't use blocking queue entered for recursive
bio submits") by setting BIO_QUEUE_ENTERED after bio_split() and before
recursing via generic_make_request().

Also add trace_block_split() because it provides useful context about
bio splits in blktrace.

Depends-on: cd4a4ae4683dc ("block: don't use blocking queue entered for recursive bio submits")
Fixes: 18a25da84354 ("dm: ensure bio submission follows a depth-first tree walk")
Cc: stable@vger.kernel.org # 4.16+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fbadda68e23b..6e29c2d99b99 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1654,7 +1654,9 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 						   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
 				part_stat_unlock();
 
+				bio_set_flag(bio, BIO_QUEUE_ENTERED);
 				bio_chain(b, bio);
+				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
 				ret = generic_make_request(bio);
 				break;
 			}
-- 
2.15.0
