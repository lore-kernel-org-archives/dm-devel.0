From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] dm-bufio: clean up rbtree block ordering
Date: Tue, 02 Jun 2020 15:34:39 +0200
Message-ID: <20200602133510.561174480@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-bufio-cleanup-tree.patch
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

dm-bufio use unnatural ordering in the rb-tree - blocks with smaller
nubmers were put to the right node and blocks with bigget numbers were put
to the left node.

This patch reverses the logic, so that i's natural.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2020-06-02 13:27:14.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2020-06-02 14:26:32.000000000 +0200
@@ -256,7 +256,7 @@ static struct dm_buffer *__find(struct d
 		if (b->block == block)
 			return b;
 
-		n = (b->block < block) ? n->rb_left : n->rb_right;
+		n = block < b->block ? n->rb_left : n->rb_right;
 	}
 
 	return NULL;
@@ -276,8 +276,8 @@ static void __insert(struct dm_bufio_cli
 		}
 
 		parent = *new;
-		new = (found->block < b->block) ?
-			&((*new)->rb_left) : &((*new)->rb_right);
+		new = b->block < found->block ?
+			&found->node.rb_left : &found->node.rb_right;
 	}
 
 	rb_link_node(&b->node, parent, new);
