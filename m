From: Joe Thornber <thornber@redhat.com>
Subject: Patch [1/1] Fix bug in btree_split_beneath()
Date: Wed, 20 Dec 2017 09:56:06 +0000
Message-ID: <20171220095605.btuhhobayshhodns@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

[dm-thin] Fix bug in btree_split_beneath()

When inserting a new key/value pair into a btree we walk down the spine of
btree nodes performing the following 2 operations:

  i) space for a new entry
  ii) adjusting the first key entry if the new key is lower than any in the node.

If the _root_ node is full, the function btree_split_beneath() allocates 2 new
nodes, and redistibutes the root nodes entries between them.  The root node is
left with 2 entries corresponding to the 2 new nodes.

btree_split_beneath() then adjusts the spine to point to one of the two new
children.  This means the first key is never adjusted if the new key was lower,
ie. operation (ii) gets missed out.  This can result in the new key being
'lost' for a period; until another low valued key is inserted that will uncover
it.  A serious bug, and quite hard to make trigger in normal use.

Test case here:

    https://github.com/jthornber/thin-provisioning-tools/blob/master/functional-tests/device-mapper/dm-tests.scm#L593

This patch fixes the issue by changing btree_split_beneath() so it no longer
adjusts the spine.  Instead it unlocks both the new nodes, and lets the main
loop in btree_insert_raw() relock the appropriate one and make any neccessary
adjustments.


This bug was identified by Monty Pavel.

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 416060c2570..ee2c01685f5 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -572,23 +572,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 	pn->keys[1] = rn->keys[0];
 	memcpy_disk(value_ptr(pn, 1), &val, sizeof(__le64));
 
-	/*
-	 * rejig the spine.  This is ugly, since it knows too
-	 * much about the spine
-	 */
-	if (s->nodes[0] != new_parent) {
-		unlock_block(s->info, s->nodes[0]);
-		s->nodes[0] = new_parent;
-	}
-	if (key < le64_to_cpu(rn->keys[0])) {
-		unlock_block(s->info, right);
-		s->nodes[1] = left;
-	} else {
-		unlock_block(s->info, left);
-		s->nodes[1] = right;
-	}
-	s->count = 2;
-
+	unlock_block(s->info, left);
+	unlock_block(s->info, right);
 	return 0;
 }
 
