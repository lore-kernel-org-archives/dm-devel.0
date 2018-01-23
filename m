From: Scott Bauer <scott.bauer@intel.com>
Subject: [PATCH] dm unstripe: Fix target length versus number of
	stripes size check.
Date: Tue, 23 Jan 2018 10:55:18 -0700
Message-ID: <20180123175518.27574-1-scott.bauer@intel.com>
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
Cc: keith.busch@intel.com, heinzm@redhat.com, Scott Bauer <scott.bauer@intel.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Since the unstripe target takes a target length which is the
size of *one* striped member we're trying to expose, not the
total size of *all* the striped members the check does not
make sense and fails for some striped setups.

For example, say we have a 4TB striped device:
or 3907018496 sectors per underlying device:

if (sector_div(width, uc->stripes)) :
   3907018496 / 2(num stripes)  == 1953509248;

tmp_len = width;
if (sector_div(tmp_len, uc->chunk_size)) {
   1953509248 / 256(chunk size) == 7630895.5;
   (fails)

This patch removes the first check which isn't valid for un striping.

Signed-off-by: Scott Bauer <scott.bauer@intel.com>
---
 drivers/md/dm-unstripe.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 061b4f10bf5c..65f838fa2e99 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -44,7 +44,7 @@ static void cleanup_unstripe(struct unstripe_c *uc, struct dm_target *ti)
 static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct unstripe_c *uc;
-	sector_t width, tmp_len;
+	sector_t tmp_len;
 	unsigned long long start;
 	char dummy;
 
@@ -100,13 +100,7 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = fls(uc->chunk_size) - 1;
 
-	width = ti->len;
-	if (sector_div(width, uc->stripes)) {
-		ti->error = "Target length not divisible by number of stripes";
-		goto err;
-	}
-
-	tmp_len = width;
+	tmp_len = ti->len;
 	if (sector_div(tmp_len, uc->chunk_size)) {
 		ti->error = "Target length not divisible by chunk size";
 		goto err;
-- 
2.11.0
