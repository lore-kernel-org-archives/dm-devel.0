From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/4] dm stripe: add WRITE SAME support
Date: Thu, 20 Dec 2012 00:57:13 -0500
Message-ID: <1355983033-17863-4-git-send-email-snitzer@redhat.com>
References: <20121220054725.GA17619@redhat.com>
	<1355983033-17863-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355983033-17863-1-git-send-email-snitzer@redhat.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

Rename stripe_map_discard to stripe_map_range and reuse it for WRITE
SAME bio processing.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-stripe.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 6b0e5ea..c89cde8 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -162,6 +162,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_requests = stripes;
 	ti->num_discard_requests = stripes;
+	ti->num_write_same_requests = stripes;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
@@ -251,8 +252,8 @@ static void stripe_map_range_sector(struct stripe_c *sc, sector_t sector,
 		*result += sc->chunk_size;		/* next chunk */
 }
 
-static int stripe_map_discard(struct stripe_c *sc, struct bio *bio,
-			      uint32_t target_stripe)
+static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
+			    uint32_t target_stripe)
 {
 	sector_t begin, end;
 
@@ -283,10 +284,11 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 		bio->bi_bdev = sc->stripe[target_request_nr].dev->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
-	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio->bi_rw & REQ_DISCARD) ||
+	    unlikely(bio->bi_rw & REQ_WRITE_SAME)) {
 		target_request_nr = dm_bio_get_target_request_nr(bio);
 		BUG_ON(target_request_nr >= sc->stripes);
-		return stripe_map_discard(sc, bio, target_request_nr);
+		return stripe_map_range(sc, bio, target_request_nr);
 	}
 
 	stripe_map_sector(sc, bio->bi_sector, &stripe, &bio->bi_sector);
-- 
1.7.1
