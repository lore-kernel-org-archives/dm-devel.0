From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 07/18] dm io: fix panic on large request
Date: Wed, 11 Jul 2007 21:58:46 +0100
Message-ID: <20070711205846.GY24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>

bio_alloc_bioset() will return NULL if 'num_vecs' is too large.
Use bio_get_nr_vecs() to get estimation of maximum number.

Signed-off-by: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-io.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/md/dm-io.c
===================================================================
--- linux.orig/drivers/md/dm-io.c	2007-07-11 21:37:32.000000000 +0100
+++ linux/drivers/md/dm-io.c	2007-07-11 21:37:43.000000000 +0100
@@ -293,7 +293,10 @@ static void do_region(int rw, unsigned i
 		 * bvec for bio_get/set_region() and decrement bi_max_vecs
 		 * to hide it from bio_add_page().
 		 */
-		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
+		num_bvecs = dm_sector_div_up(remaining,
+					     (PAGE_SIZE >> SECTOR_SHIFT));
+		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
+				      num_bvecs);
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
