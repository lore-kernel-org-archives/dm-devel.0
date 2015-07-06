From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/2] Remove unused parameter in
	btree_split_sibling()
Date: Mon,  6 Jul 2015 11:55:40 -0400
Message-ID: <1436198141-19730-2-git-send-email-vgoyal@redhat.com>
References: <1436198141-19730-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1436198141-19730-1-git-send-email-vgoyal@redhat.com>
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
Cc: thornber@redhat.com, Vivek Goyal <vgoyal@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Looks like "dm_block_t root" is unused parameter in btree_split_sibling().
Remove it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/persistent-data/dm-btree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 200ac12..052e48b 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -420,8 +420,8 @@ EXPORT_SYMBOL_GPL(dm_btree_lookup);
  *
  * Where A* is a shadow of A.
  */
-static int btree_split_sibling(struct shadow_spine *s, dm_block_t root,
-			       unsigned parent_index, uint64_t key)
+static int btree_split_sibling(struct shadow_spine *s, unsigned parent_index,
+			       uint64_t key)
 {
 	int r;
 	size_t size;
@@ -625,7 +625,7 @@ static int btree_insert_raw(struct shadow_spine *s, dm_block_t root,
 			if (top)
 				r = btree_split_beneath(s, key);
 			else
-				r = btree_split_sibling(s, root, i, key);
+				r = btree_split_sibling(s, i, key);
 
 			if (r < 0)
 				return r;
-- 
2.1.0
