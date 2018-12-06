From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 1/7] dm: dont rewrite
	dm_disk(md)->part0.in_flight
Date: Thu,  6 Dec 2018 11:41:16 -0500
Message-ID: <20181206164122.2166-2-snitzer@redhat.com>
References: <20181206164122.2166-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181206164122.2166-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

generic_start_io_acct and generic_end_io_acct already update the variable
in_flight using atomic operations, so we don't have to overwrite them
again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a733e4c920af..a8ae7931bce7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -663,8 +663,7 @@ static void start_io_acct(struct dm_io *io)
 	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
 			      &dm_disk(md)->part0);
 
-	atomic_set(&dm_disk(md)->part0.in_flight[rw],
-		   atomic_inc_return(&md->pending[rw]));
+	atomic_inc(&md->pending[rw]);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -693,7 +692,6 @@ static void end_io_acct(struct dm_io *io)
 	 * a flush.
 	 */
 	pending = atomic_dec_return(&md->pending[rw]);
-	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
 	pending += atomic_read(&md->pending[rw^0x1]);
 
 	/* nudge anyone waiting on suspend queue */
-- 
2.15.0
