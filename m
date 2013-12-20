From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 03/20] dm table: remove unused buggy
	code that extends the targets array
Date: Fri, 20 Dec 2013 18:37:16 -0500
Message-ID: <1387582653-13647-4-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

A device mapper table is allocated in the following way:
* The function dm_table_create is called, it gets the number of targets
  as an argument -- it allocates a targets array accordingly.
* For each target, we call dm_table_add_target.

If we add more targets than were specified in dm_table_create, the
function dm_table_add_target reallocates the targets array.  However,
this reallocation code is wrong - it moves the targets array to a new
location, while some target constructors hold pointers to the array in
the old location.

The following DM target drivers save the pointer to the target
structure, so they corrupt memory if the target array is moved:
multipath, raid, mirror, snapshot, stripe, switch, thin, verity.

Under normal circumstances, the reallocation function is not called
(because dm_table_create is called with the correct number of targets),
so the buggy reallocation code is not used.

Prior to the fix "dm table: fail dm_table_create on dm_round_up
overflow", the reallocation code could only be used in case the user
specifies too large a value in param->target_count, such as 0xffffffff.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ba6a38..6a7f2b8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -155,7 +155,6 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 {
 	sector_t *n_highs;
 	struct dm_target *n_targets;
-	int n = t->num_targets;
 
 	/*
 	 * Allocate both the target array and offset array at once.
@@ -169,12 +168,7 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 
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
@@ -261,17 +255,6 @@ void dm_table_destroy(struct dm_table *t)
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
@@ -731,8 +714,7 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		return -EINVAL;
 	}
 
-	if ((r = check_space(t)))
-		return r;
+	BUG_ON(t->num_targets >= t->num_allocated);
 
 	tgt = t->targets + t->num_targets;
 	memset(tgt, 0, sizeof(*tgt));
-- 
1.8.1.4
