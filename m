From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 4/4] dm writecache: avoid unnecessary lookups in writecache_find_entry
Date: Thu, 25 Apr 2019 21:31:20 +0800
Message-ID: <20190425133120.13088-5-yehs2007@zoho.com>
References: <20190425133120.13088-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425133120.13088-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

Only when entry has been found, that would only be necessary to check the
lowest or highest seq-count.

Add local variable "found" in writecache_find_entry, if no entry has been
found, it is meaningless that having a useless rb_prev or rb_next.

This patch is not designed for fixing logical error. That is used for
optimizing the behavior of writecache_find_entry.

Give an example to illustrate the point below.
Suppose that is the case, here is a normal READ bio comes to writecache_map.
And because of bio's direction is READ, writecache_find_entry would be called
with flags WFE_RETURN_FOLLOWING.

Now there are two scenarios,
1. writecache_find_entry successfully get an existing entry by searching
   rb_tree, we could call it HIT. Then the first 'while' will be finished by
   'break'. Next it will move to second 'while' loop, because of the flags
   hasn't been marked as WFE_LOWEST_SEQ. writecache_find_entry will try to
   return an entry with HIGHEST_SEQ, if there are other entries which has same
   original_sector in rb_tree.
   For this situation, the current code is okay to deal with that.

2. writecache_find_entry couldn't get an existing entry from rb_tree, we
   could call it MISS. Because of same flags WFE_RETURN_FOLLOWING,
   writecache_find_entry will get other entry, which's original_sector will
   slightly larger than input parameter block, with big probability.
   For this scenario, function writecache_find_entry doesn't need to enter
   second 'while' loop. But current code would still try to check there were
   other entry with same original_sector.
   So the additional rb_next or rb_prev is unnecessary by this case, also the
   code doesn't need to compare the original_sector of 'e2' with parameter
   'block'.

This patch is designed to optimize the second case. so it could skip the
second 'while' loop when the block is missed from rb_tree.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index ddf1732..047ae09 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -537,14 +537,18 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 {
 	struct wc_entry *e;
 	struct rb_node *node = wc->tree.rb_node;
+	bool found = false;
 
 	if (unlikely(!node))
 		return NULL;
 
 	while (1) {
 		e = container_of(node, struct wc_entry, rb_node);
-		if (read_original_sector(wc, e) == block)
+		if (read_original_sector(wc, e) == block) {
+			found = true;
 			break;
+		}
+
 		node = (read_original_sector(wc, e) >= block ?
 			e->rb_node.rb_left : e->rb_node.rb_right);
 		if (unlikely(!node)) {
@@ -564,7 +568,8 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 		}
 	}
 
-	while (1) {
+	/* only need to check lowest or highest seq-count when entry has been found */
+	while (found) {
 		struct wc_entry *e2;
 		if (flags & WFE_LOWEST_SEQ)
 			node = rb_prev(&e->rb_node);
@@ -577,6 +582,9 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 			return e;
 		e = e2;
 	}
+
+	/* no entry has been found, return the following entry */
+	return e;
 }
 
 static void writecache_insert_entry(struct dm_writecache *wc, struct wc_entry *ins)
-- 
1.8.3.1
