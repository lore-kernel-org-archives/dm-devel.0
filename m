From: mpatocka@redhat.com
Subject: [patch 4/8] dm-bufio: fix slab cache attributes
Date: Mon, 26 Mar 2018 20:29:43 +0200
Message-ID: <20180326183056.234137097@debian.vm>
References: <20180326182939.169591126@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-drop-alignment.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msnitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The I/O buffer doesn't have to be aligned, so we can drop the alignment on
the slab cache. This patch also sets SLAB_RECLAIM_ACCOUNT, so that the
memory allocated from the cache is accounted as reclaimable and doesn't
inflate the 'used' entry in the free command.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-21 12:33:34.928416000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-21 12:35:14.938416000 +0100
@@ -618,7 +618,6 @@ static void use_inline_bio(struct dm_buf
 		unsigned this_step = min((unsigned)(PAGE_SIZE - offset_in_page(ptr)), len);
 		if (!bio_add_page(&b->bio, virt_to_page(ptr), this_step,
 				  offset_in_page(ptr))) {
-			BUG_ON(b->c->block_size <= PAGE_SIZE);
 			use_dmio(b, rw, sector, n_sectors, offset, end_io);
 			return;
 		}
@@ -1686,7 +1685,7 @@ struct dm_bufio_client *dm_bufio_client_
 	if (block_size < PAGE_SIZE) {
 		char name[26];
 		snprintf(name, sizeof name, "dm_bufio_cache-%u", c->block_size);
-		c->slab_cache = kmem_cache_create(name, c->block_size, c->block_size, 0, NULL);
+		c->slab_cache = kmem_cache_create(name, c->block_size, ARCH_KMALLOC_MINALIGN, SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
 			r = -ENOMEM;
 			goto bad;
