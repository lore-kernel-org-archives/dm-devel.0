From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 12/14] dm thin: cleanup overwrite's endio
	restore to be centralized
Date: Thu, 14 May 2015 17:05:10 -0400
Message-ID: <1431637512-64245-13-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index aa71bdd..b316450 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -766,6 +766,8 @@ static void overwrite_endio(struct bio *bio, int err)
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
 	struct dm_thin_new_mapping *m = h->overwrite_mapping;
 
+	bio->bi_end_io = m->saved_bi_end_io;
+
 	m->err = err;
 	complete_mapping_preparation(m);
 }
@@ -854,9 +856,6 @@ static void inc_remap_and_issue_cell(struct thin_c *tc,
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
-	if (m->bio)
-		m->bio->bi_end_io = m->saved_bi_end_io;
-
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
 	mempool_free(m, m->tc->pool->mapping_pool);
@@ -866,13 +865,9 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
 	struct pool *pool = tc->pool;
-	struct bio *bio;
+	struct bio *bio = m->bio;
 	int r;
 
-	bio = m->bio;
-	if (bio)
-		bio->bi_end_io = m->saved_bi_end_io;
-
 	if (m->err) {
 		cell_error(pool, m->cell);
 		goto out;
-- 
2.3.2 (Apple Git-55)
