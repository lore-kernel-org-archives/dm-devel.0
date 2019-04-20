From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH] dm-writecache: avoid unnecessary lookups in writecache_find_entry
Date: Sun, 21 Apr 2019 00:21:02 +0800
Message-ID: <20190420162102.6460-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

Only when entry has been found, that would only be necessary to check the
lowest or highest seq-count.

Add local variable "found" in writecache_find_entry, if no entry has been
found, it is meaningless that having a useless rb_prev or rb_next.

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
