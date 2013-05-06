From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm stripe: fix regression in stripe_width
	calculation
Date: Mon,  6 May 2013 16:39:29 -0400
Message-ID: <1367872769-4526-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

The stripe_width is the stripe device length divided by the number of
stripes.  Unfortunately, commit eb850de ("dm stripe: support for non
power of 2 chunksize") introduced a regression that resulted in the
stripe_width being set to stripe device length divided by chunk_size *
stripe_count.

For example, a stripe device's table with: 0 33553920 striped 3 512 ...
should result in a stripe_width of 11184640 (33553920 / 3), but due to
the bug it was being getting set to 21845 (33553920 / (512 * 3)).

The impact of this bug is that device topologies that previously worked
fine with the stripe target are no longer considered valid.  In
particular, there is a higher risk of seeing this issue if one of the
stripe devices has a 4K logical block size.  Resulting in an error
message like this:
"device-mapper: table: 253:4: len=21845 not aligned to h/w logical block size 4096 of dm-1"

The fix is to not use the 'width' variable as a temporary variable that
is modified as a side-effect of the sector_div() as part of an earlier
negative check before the stripe_width calculation (which also uses the
'width' variable).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 3.6+
---
 drivers/md/dm-stripe.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index ea5e878..9e1ec9b 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -94,7 +94,7 @@ static int get_stripe(struct dm_target *ti, struct stripe_c *sc,
 static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct stripe_c *sc;
-	sector_t width;
+	sector_t width, temp;
 	uint32_t stripes;
 	uint32_t chunk_size;
 	int r;
@@ -115,13 +115,14 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	width = ti->len;
-	if (sector_div(width, chunk_size)) {
+	temp = ti->len;
+	if (sector_div(temp, chunk_size)) {
 		ti->error = "Target length not divisible by "
 		    "chunk size";
 		return -EINVAL;
 	}
 
+	width = ti->len;
 	if (sector_div(width, stripes)) {
 		ti->error = "Target length not divisible by "
 		    "number of stripes";
-- 
1.7.1
