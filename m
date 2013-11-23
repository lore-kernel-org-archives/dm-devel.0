From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-table: remove unused buggy code that
 extends the targets array
Date: Fri, 22 Nov 2013 19:51:39 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311221951070.31923@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Device mapper table is allocated in the following way:
* The function dm_table_create is called, it gets the number of targets as
  an argument.
* For each target, we call dm_table_add_target

If we add more targets than was specified in dm_table_create, the function
dm_table_add_target reallocates the targets array. However, this
reallocation code is wrong - it moves the targets array to a new location,
while some target constructors hold pointers to the array in the old
location.

The following target drivers save the pointer to the target structure, so
they corrupt memory if the target array is moved: multipath, raid, mirror,
snapshot, stripe, switch, thin, verity.

Under normal circumstances, the reallocation function is not called
(because dm_table_create is called with the correct number of targets), so
the buggy reallocation code is not used.

The reallocation code could only be used in case the user specifies too
high value in target_count, such as 0xffffffff. In this case, the
expression "num_targets = dm_round_up(num_targets, KEYS_PER_NODE);"
overflows and zero targets is allocated. This overflow is fixed in the
next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

Index: linux-3.12-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.12-fast.orig/drivers/md/dm-table.c	2013-11-22 21:23:11.000000000 +0100
+++ linux-3.12-fast/drivers/md/dm-table.c	2013-11-22 21:24:52.000000000 +0100
@@ -155,7 +155,6 @@ static int alloc_targets(struct dm_table
 {
 	sector_t *n_highs;
 	struct dm_target *n_targets;
-	int n = t->num_targets;
 
 	/*
 	 * Allocate both the target array and offset array at once.
@@ -169,12 +168,7 @@ static int alloc_targets(struct dm_table
 
 	n_targets = (struct dm_target *) (n_highs + num);
 
-	if (n) {
-		memcpy(n_highs, t->highs, sizeof(*n_highs) * n);
-		memcpy(n_targets, t->targets, sizeof(*n_targets) * n);
-	}
-
-	memset(n_highs + n, -1, sizeof(*n_highs) * (num - n));
+	memset(n_highs, -1, sizeof(*n_highs) * num);
 	vfree(t->highs);
 
 	t->num_allocated = num;
@@ -256,17 +250,6 @@ void dm_table_destroy(struct dm_table *t
 }
 
 /*
- * Checks to see if we need to extend highs or targets.
- */
-static inline int check_space(struct dm_table *t)
-{
-	if (t->num_targets >= t->num_allocated)
-		return alloc_targets(t, t->num_allocated * 2);
-
-	return 0;
-}
-
-/*
  * See if we've already got a device in the list.
  */
 static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
@@ -726,8 +709,7 @@ int dm_table_add_target(struct dm_table 
 		return -EINVAL;
 	}
 
-	if ((r = check_space(t)))
-		return r;
+	BUG_ON(t->num_targets >= t->num_allocated);
 
 	tgt = t->targets + t->num_targets;
 	memset(tgt, 0, sizeof(*tgt));
