From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] dm-ebs: use dm_bufio_forget_buffers
Date: Tue, 02 Jun 2020 15:34:41 +0200
Message-ID: <20200602133513.046607000@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-ebs-forget-buffers.patch
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Use dm_bufio_forget_buffers instead of block-by-block loop and
dm_bufio_forget. dm_bufio_forget_buffers is faster than the loop because
it searches for used buffers using rb-tree.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ebs-target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-ebs-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ebs-target.c	2020-06-02 13:27:14.000000000 +0200
+++ linux-2.6/drivers/md/dm-ebs-target.c	2020-06-02 15:11:18.000000000 +0200
@@ -167,8 +167,8 @@ static void __ebs_forget_bio(struct ebs_
 	sector_t blocks, sector = bio->bi_iter.bi_sector;
 
 	blocks = __nr_blocks(ec, bio);
-	for (; blocks--; sector += ec->u_bs)
-		dm_bufio_forget(ec->bufio, __sector_to_block(ec, sector));
+
+	dm_bufio_forget_buffers(ec->bufio, __sector_to_block(ec, sector), blocks);
 }
 
 /* Worker funtion to process incoming bios. */
