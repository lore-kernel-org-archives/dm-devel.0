From: Dennis Yang <shinrairis@gmail.com>
Subject: Possible bug when redistributing entries between
	dm-btree node
Date: Tue, 25 Aug 2015 19:12:15 +0800
Message-ID: <CAKTMprMdHAg4cFUw5NACnCg1zTJx-i=N8w0NRY8zujKQdoOYeA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

A couple of months ago, I had been working on a dm-btree-remove bug
reported before in this mailing list.
(https://www.redhat.com/archives/dm-devel/2013-February/msg00063.html)
We eventually found a bug in dm-btree-remove.c and delivered a patch
to fix this, and you can find the discussion in this thread.
(https://www.redhat.com/archives/dm-devel/2015-May/msg00113.html)

However, I surprisingly find out that this patch did not solve our
original issue which triggers the BUG_ON of shift() in
dm-btree-remove.c when removing entries from btrees. Finally, we have
discovered another corner case which might be the root cause of this
issue. When redistributing entries between three nodes L (with #MAX
entries), C (with #MAX-1 entries), and R (with #MAX entries), the
redistribute3() will set target to #MAX-1 entries and start to move
entry in the following steps.

1. Move 1 entry from node R to node C to make node R meet the target
(#MAX-1) we set.
2. Move 1 entry from node L to node C to make node L also meet the
target (#MAX-1)

After step1, both node L and node C will have #MAX entries while node
R has #MAX-1 entries.
When doing step2, moving 1 entry from node L to node C will make node
C has #MAX+1 entries which is not allowed and triggers the BUG_ON of
shift().

To solve this, we could bypass step2 or simply skip redistributing
entries between nodes when the total entries of all three nodes equals
(3 * #MAX + 2).

PATCH 1: skip redistributing entries
======================================================================================================
diff --git a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
index 6ec6065..592cd63 100644
--- a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
+++ b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
@@ -313,7 +313,8 @@ static void redistribute3(struct dm_btree_info
*info, struct btree_node *parent,
        unsigned target = (nr_left + nr_center + nr_right) / 3;
        BUG_ON(target > max_entries);

+       if (nr_left + nr_center + nr_right == max_entries * 3 + 2)
+               return;

        if (nr_left < nr_right) {
                s = nr_left - target;

PATCH 2: bypass step 2
======================================================================================================
diff --git a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
index 6ec6065..2844a71 100644
--- a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
+++ b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
@@ -327,6 +325,9 @@ static void redistribute3(struct dm_btree_info
*info, struct btree_node *parent,
                } else
                        shift(left, center, s);

+               if (nr_left + nr_center + nr_right == max_entries * 3 + 2)
+                               return;
+
                shift(center, right, target - nr_right);

        } else {
@@ -340,6 +341,9 @@ static void redistribute3(struct dm_btree_info
*info, struct btree_node *parent,
                } else
                        shift(center, right, s);

+               if (nr_left + nr_center + nr_right == max_entries * 3 + 2)
+                               return;
+
                shift(left, center, nr_left - target);
        }

Dennis
