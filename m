From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 2/4] dm writecache: add unlikely for returned value of rb_next/prev
Date: Thu, 25 Apr 2019 21:31:18 +0800
Message-ID: <20190425133120.13088-3-yehs2007@zoho.com>
References: <20190425133120.13088-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425133120.13088-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

In functions writecache_discard() and writecache_find_entry() there is a
high probablity that the pointer of structure rb_node won't equal NULL.
Add unlikely for the pointer node NULL.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-writecache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5b4d1c1..cfbbfbc 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -571,7 +571,7 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 			node = rb_prev(&e->rb_node);
 		else
 			node = rb_next(&e->rb_node);
-		if (!node)
+		if (unlikely(!node))
 			return e;
 		e2 = container_of(node, struct wc_entry, rb_node);
 		if (read_original_sector(wc, e2) != block)
@@ -804,7 +804,7 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 			writecache_free_entry(wc, e);
 		}
 
-		if (!node)
+		if (unlikely(!node))
 			break;
 
 		e = container_of(node, struct wc_entry, rb_node);
-- 
1.8.3.1
