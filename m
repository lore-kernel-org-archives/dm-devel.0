From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-crypt: sort writes
Date: Fri, 13 Feb 2015 16:01:57 -0500
Message-ID: <20150213210157.GA7075@redhat.com>
References: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 13 2015 at  8:27P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Write requests are sorted in a red-black tree structure and are submitted
> in the sorted order.
> 
> In theory the sorting should be performed by the underlying disk scheduler,
> however, in practice the disk scheduler accepts and sorts only 128 requests.
> In order to sort more requests, we need to implement our own sorting.
> 
> In testing, it was shown that this patch slightly increases performance in
> some situations
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

FYI, I've folded this patch in to cleanup rb_tree node access:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 954ba1f..e6a1460 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1175,9 +1175,13 @@ static void kcryptd_io_write(struct dm_crypt_io *io)
 	generic_make_request(clone);
 }
 
+#define crypt_io_from_node(node) rb_entry((node), struct dm_crypt_io, rb_node)
+
 static int dmcrypt_write(void *data)
 {
 	struct crypt_config *cc = data;
+	struct dm_crypt_io *io;
+
 	while (1) {
 		struct rb_root write_tree;
 		struct blk_plug plug;
@@ -1221,8 +1225,7 @@ pop_from_list:
 		 */
 		blk_start_plug(&plug);
 		do {
-			struct dm_crypt_io *io = rb_entry(rb_first(&write_tree),
-						struct dm_crypt_io, rb_node);
+			io = crypt_io_from_node(rb_first(&write_tree));
 			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
 		} while (!RB_EMPTY_ROOT(&write_tree));
@@ -1237,7 +1240,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	struct crypt_config *cc = io->cc;
 	unsigned long flags;
 	sector_t sector;
-	struct rb_node **p, *parent;
+	struct rb_node **rbp, *parent;
 
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
@@ -1252,19 +1255,17 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
-	p = &cc->write_tree.rb_node;
+	rbp = &cc->write_tree.rb_node;
 	parent = NULL;
 	sector = io->sector;
-	while (*p) {
-		parent = *p;
-#define io_node rb_entry(parent, struct dm_crypt_io, rb_node)
-		if (sector < io_node->sector)
-			p = &io_node->rb_node.rb_left;
+	while (*rbp) {
+		parent = *rbp;
+		if (sector < crypt_io_from_node(parent)->sector)
+			rbp = &(*rbp)->rb_left;
 		else
-			p = &io_node->rb_node.rb_right;
-#undef io_node
+			rbp = &(*rbp)->rb_right;
 	}
-	rb_link_node(&io->rb_node, parent, p);
+	rb_link_node(&io->rb_node, parent, rbp);
 	rb_insert_color(&io->rb_node, &cc->write_tree);
 
 	wake_up_locked(&cc->write_thread_wait);
