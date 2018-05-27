From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] dm writecache: fix missing goto in error handling code
Date: Sun, 27 May 2018 23:25:12 +0100
Message-ID: <20180527222512.25280-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Colin Ian King <colin.king@canonical.com>

Currently, the -EFBIG error condition when n_bitmaps_bits is
too large is falling through to the next statement and the
error assignment to r is potentially being ignored.  The code
should be exiting to the error path via label 'bad'. Fix
this by adding the missing goto statement.

Detected by CoverityScan, CID#1469377 ("Unused value")

Fixes: bb15b431d650 ("dm: add writecache target")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-writecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 1ef06e738eb6..e61704b6eae1 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2077,6 +2077,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		if (n_bitmap_bits > 1U << 31) {
 			r = -EFBIG;
 			ti->error = "Invalid device size";
+			goto bad;
 		}
 
 		wc->memory_map = vmalloc(n_metadata_blocks << wc->block_size_bits);
-- 
2.17.0
