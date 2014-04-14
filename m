From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-verity: Fix biovecs hash calculation
	regression
Date: Mon, 14 Apr 2014 22:02:30 +0200
Message-ID: <1397505750-18783-1-git-send-email-gmazyland@gmail.com>
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
Cc: kmo@daterainc.com, mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>, snitzer@redhat.com
List-Id: dm-devel.ids

The commit
  003b5c5719f159f4f4bf97511c4702a0638313dd
  block: Convert drivers to immutable biovecs

incorrectly converted biovec iteration in dm-verity to always
calculate hash from full biovec, while the function need
to calculate hash only from part of it (up to "todo"
calculated value).

This patch fixes the issue by limiting hash input to only
really requested data size.

The problem is easily reproducible using cryptsetup
regression test for veritysetup (verity-compat-test).

(Patch should be applied also to 3.14 stable.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-verity.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 796007a..7a7bab8 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -330,15 +330,17 @@ test_block_hash:
 				return r;
 			}
 		}
-
 		todo = 1 << v->data_dev_block_bits;
-		while (io->iter.bi_size) {
+		do {
 			u8 *page;
+			unsigned len;
 			struct bio_vec bv = bio_iter_iovec(bio, io->iter);
 
 			page = kmap_atomic(bv.bv_page);
-			r = crypto_shash_update(desc, page + bv.bv_offset,
-						bv.bv_len);
+			len = bv.bv_len;
+			if (likely(len >= todo))
+				len = todo;
+			r = crypto_shash_update(desc, page + bv.bv_offset, len);
 			kunmap_atomic(page);
 
 			if (r < 0) {
@@ -346,8 +348,9 @@ test_block_hash:
 				return r;
 			}
 
-			bio_advance_iter(bio, &io->iter, bv.bv_len);
-		}
+			bio_advance_iter(bio, &io->iter, len);
+			todo -= len;
+		} while (todo);
 
 		if (!v->version) {
 			r = crypto_shash_update(desc, v->salt, v->salt_size);
-- 
1.9.2
