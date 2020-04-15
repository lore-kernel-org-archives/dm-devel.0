From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] md/persistent-data: exit_ro_spine func return
	void
Date: Wed, 15 Apr 2020 19:57:31 +0800
Message-ID: <a7643d1a-940b-c8a8-686e-a660f0feeb96@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: linfeilong <linfeilong@huawei.com>, "wubo (T)" <wubo40@huawei.com>, Mingfangsen <mingfangsen@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>
List-Id: dm-devel.ids

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

In commit 4c7da06f5a78 ("dm persistent data: eliminate unnecessary return values"),
r value in exit_ro_spine will not changes, so exit_ro_spine donot need
to return values.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 drivers/md/persistent-data/dm-btree-internal.h | 2 +-
 drivers/md/persistent-data/dm-btree-spine.c    | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index a240990a7f33..55a4096f1334 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -68,7 +68,7 @@ struct ro_spine {
 };

 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
-int exit_ro_spine(struct ro_spine *s);
+void exit_ro_spine(struct ro_spine *s);
 int ro_step(struct ro_spine *s, dm_block_t new_child);
 void ro_pop(struct ro_spine *s);
 struct btree_node *ro_node(struct ro_spine *s);
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index b27b8091a1ca..e03cb9e48773 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -132,15 +132,13 @@ void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
 	s->nodes[1] = NULL;
 }

-int exit_ro_spine(struct ro_spine *s)
+void exit_ro_spine(struct ro_spine *s)
 {
-	int r = 0, i;
+	int i;

 	for (i = 0; i < s->count; i++) {
 		unlock_block(s->info, s->nodes[i]);
 	}
-
-	return r;
 }

 int ro_step(struct ro_spine *s, dm_block_t new_child)
-- 
2.19.1
