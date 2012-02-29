From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/13] dm btree remove: fix center node entry
	redistribution in redistribute3 function
Date: Wed, 29 Feb 2012 09:50:09 -0500
Message-ID: <1330527017-28618-6-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

The code to redistribute entries among 3 nodes wasn't taking into
consideration the case where the central node has so few entries that
some need to go from left to right, or vice versa.

Signed-off-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/persistent-data/dm-btree-remove.c |   49 +++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 6c8e9a7..aa71e23 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -179,6 +179,15 @@ static int exit_child(struct dm_btree_info *info, struct child *c)
 
 static void shift(struct node *left, struct node *right, int count)
 {
+	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
+	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
+	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
+	uint32_t r_max_entries = le32_to_cpu(right->header.max_entries);
+
+	BUG_ON(max_entries != r_max_entries);
+	BUG_ON(nr_left - count > max_entries);
+	BUG_ON(nr_right + count > max_entries);
+
 	if (!count)
 		return;
 
@@ -190,13 +199,8 @@ static void shift(struct node *left, struct node *right, int count)
 		node_shift(right, count);
 	}
 
-	left->header.nr_entries =
-		cpu_to_le32(le32_to_cpu(left->header.nr_entries) - count);
-	BUG_ON(le32_to_cpu(left->header.nr_entries) > le32_to_cpu(left->header.max_entries));
-
-	right->header.nr_entries =
-		cpu_to_le32(le32_to_cpu(right->header.nr_entries) + count);
-	BUG_ON(le32_to_cpu(right->header.nr_entries) > le32_to_cpu(right->header.max_entries));
+	left->header.nr_entries = cpu_to_le32(nr_left - count);
+	right->header.nr_entries = cpu_to_le32(nr_right + count);
 }
 
 static void __rebalance2(struct dm_btree_info *info, struct node *parent,
@@ -302,12 +306,39 @@ static void redistribute3(struct dm_btree_info *info, struct node *parent,
 			  struct node *left, struct node *center, struct node *right,
 			  uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
 {
+	int s;
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
 	unsigned target = (nr_left + nr_center + nr_right) / 3;
 	BUG_ON(target > max_entries);
 
-	shift(left, center, nr_left - target);
-	shift(center, right, target - nr_right);
+	if (nr_left < nr_right) {
+		s = nr_left - target;
+
+		if (s < 0 && nr_center < -s) {
+			/* not enough in central node */
+			shift(left, center, nr_center);
+			s = nr_center - target;
+			shift(left, right, s);
+			nr_right += s;
+		} else
+			shift(left, center, s);
+
+		shift(center, right, target - nr_right);
+
+	} else {
+		s = target - nr_right;
+		if (s > 0 && nr_center < s) {
+			/* not enough in central node */
+			shift(center, right, nr_center);
+			s = target - nr_center;
+			shift(left, right, s);
+			nr_left -= s;
+		} else
+			shift(center, right, s);
+
+		shift(left, center, nr_left - target);
+	}
+
 	*key_ptr(parent, c->index) = center->keys[0];
 	*key_ptr(parent, r->index) = right->keys[0];
 }
-- 
1.7.1
