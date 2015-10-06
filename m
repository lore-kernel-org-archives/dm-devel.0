From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH for v4.3-rc] dm: fix request-based dm error
	reporting
Date: Tue, 6 Oct 2015 04:19:54 +0000
Message-ID: <20151006041953.GA7948@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <2B0B6105193E0A45AE1DB47BA5A2EF44@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

end_clone_bio() is a endio callback for clone bio and should check
and save the clone's bi_error for error reporting.  However,
4246a0b63bd8 ("block: add a bi_error field to struct bio") changed
the function to check the original bio's bi_error, which is 0.

Without this fix, clone's error is ignored and reported to the
original request as success.  Thus data corruption will be observed.

Fixes: 4246a0b63bd8 ("block: add a bi_error field to struct bio")
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7289ece..dd6e667 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1001,7 +1001,9 @@ static void end_clone_bio(struct bio *clone)
 	struct dm_rq_target_io *tio = info->tio;
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
+	int error;
 
+	error = clone->bi_error;
 	bio_put(clone);
 
 	if (tio->error)
@@ -1011,13 +1013,13 @@ static void end_clone_bio(struct bio *clone)
 		 * the remainder.
 		 */
 		return;
-	else if (bio->bi_error) {
+	else if (error) {
 		/*
 		 * Don't notice the error to the upper layer yet.
 		 * The error handling decision is made by the target driver,
 		 * when the request is completed.
 		 */
-		tio->error = bio->bi_error;
+		tio->error = error;
 		return;
 	}
 
-- 
2.1.0
