From: Joe Thornber <thornber@redhat.com>
Subject: Re: A bug in dm-persistent-data module which leads to
 dm-thin metadata corruption
Date: Fri, 7 Mar 2014 15:14:26 +0000
Message-ID: <20140307151425.GB10613@debian>
References: <CAKTMprO45LWFnN0sTES919GYQ9fcqtwzubUf=9s3nBpxTSbZsw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprO45LWFnN0sTES919GYQ9fcqtwzubUf=9s3nBpxTSbZsw@mail.gmail.com>
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

On Fri, Mar 07, 2014 at 12:00:07PM +0800, Teng-Feng Yang wrote:
> Dear all,
> 
> I had experienced a dm-thin metadata corruption a couple of days ago,
> and I found that someone had
> reported the similar corruption to dm-devel recently.
> http://www.redhat.com/archives/dm-devel/2014-February/msg00157.html
> 
> Since this issue will leads to unrecoverable metadata corruption and
> could be reproduced every time,
> we add some traces and hope to find out the root cause of this. After
> dumping the trace, I think we
> might find a bug in dm-persistent-data and I will try my best to
> explain it clearly in below.
> 
> When decreasing the reference count of a metadata block with its
> reference count equals 3,
> we will call dm_btree_remove() to remove this enrty from the B+tree
> which keeps the reference count info
> in metadata device.
> 
> The B+tree will try to rebalance the entry of the child nodes in each
> node it traversed, and
> the rebalance process contains the following steps.
> 
> (1) Finding the corresponding children in current node (shadow_current(s))
> (2) Shadow the children block (issue BOP_INC)
> (3) redistribute keys among children, and free children if necessary
> (issue BOP_DEC)
> 
> Since the update of a metadata block's reference count could be
> recursive, we will stash these
> reference count update operations in smm->uncommitted and then process
> them in a FILO fashion.
> The problem is that step(3) could free the children which is created
> in step(2), so the BOP_DEC issued
> in step(3) will be carried out  before the BOP_INC issued in step(2)
> since these BOPs will be processed in
> FILO fashion. Once the BOP_DEC from step(3) tries to decrease the
> reference count of newly shadow block,
> it will report failure for its reference equals 0 before decreasing.
> It looks like we can solve this issue by processing
> these BOPs in a FIFO fashion instead of FILO.
> 
> Any comment will be grateful.

Dennis,

That's a really impressive piece of analysis.  I think you've found
the issue.

Could you try with this patch please and see if it fixes things?

Thanks,

- Joe



commit f3764eeab80c2348391d6b1476a0dfb754121227
Author: Joe Thornber <ejt@redhat.com>
Date:   Fri Mar 7 14:57:19 2014 +0000

    [dm-thin, dm-cache, dm-era, persistent-data] Apply recursive space map ops in FIFO order rather than FILO.
    
    http://www.redhat.com/archives/dm-devel/2014-March/msg00021.html

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 536782e..0d74e9d 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -91,6 +91,69 @@ struct block_op {
 	dm_block_t block;
 };
 
+struct bop_ring_buffer {
+	unsigned begin;
+	unsigned end;
+	struct block_op bops[MAX_RECURSIVE_ALLOCATIONS + 1];
+};
+
+static void brb_init(struct bop_ring_buffer *brb)
+{
+	brb->begin = 0;
+	brb->end = 0;
+}
+
+static bool brb_empty(struct bop_ring_buffer *brb)
+{
+	return brb->begin == brb->end;
+}
+
+static unsigned brb_next(struct bop_ring_buffer *brb, unsigned old)
+{
+	unsigned r = old + 1;
+	return (r >= (sizeof(brb->bops) / sizeof(*brb->bops))) ? 0 : r;
+}
+
+static int brb_push(struct bop_ring_buffer *brb,
+		    enum block_op_type type, dm_block_t b)
+{
+	struct block_op *bop;
+	unsigned next = brb_next(brb, brb->end);
+
+	/*
+	 * We don't allow the last bop to be filled, this way we can
+	 * differentiate between full and empty.
+	 */
+	if (next == brb->begin)
+		return -ENOMEM;
+
+	bop = brb->bops + brb->end;
+	bop->type = type;
+	bop->block = b;
+
+	brb->end = next;
+
+	return 0;
+}
+
+static int brb_pop(struct bop_ring_buffer *brb, struct block_op *result)
+{
+	struct block_op *bop;
+
+	if (brb_empty(brb))
+		return -ENODATA;
+
+	bop = brb->bops + brb->begin;
+	result->type = bop->type;
+	result->block = bop->block;
+
+	brb->begin = brb_next(brb, brb->begin);
+
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
 struct sm_metadata {
 	struct dm_space_map sm;
 
@@ -101,25 +164,20 @@ struct sm_metadata {
 
 	unsigned recursion_count;
 	unsigned allocated_this_transaction;
-	unsigned nr_uncommitted;
-	struct block_op uncommitted[MAX_RECURSIVE_ALLOCATIONS];
+	struct bop_ring_buffer uncommitted;
 
 	struct threshold threshold;
 };
 
 static int add_bop(struct sm_metadata *smm, enum block_op_type type, dm_block_t b)
 {
-	struct block_op *op;
+	int r = brb_push(&smm->uncommitted, type, b);
 
-	if (smm->nr_uncommitted == MAX_RECURSIVE_ALLOCATIONS) {
+	if (r) {
 		DMERR("too many recursive allocations");
 		return -ENOMEM;
 	}
 
-	op = smm->uncommitted + smm->nr_uncommitted++;
-	op->type = type;
-	op->block = b;
-
 	return 0;
 }
 
@@ -158,11 +216,17 @@ static int out(struct sm_metadata *smm)
 		return -ENOMEM;
 	}
 
-	if (smm->recursion_count == 1 && smm->nr_uncommitted) {
-		while (smm->nr_uncommitted && !r) {
-			smm->nr_uncommitted--;
-			r = commit_bop(smm, smm->uncommitted +
-				       smm->nr_uncommitted);
+	if (smm->recursion_count == 1) {
+		while (!brb_empty(&smm->uncommitted)) {
+			struct block_op bop;
+
+			r = brb_pop(&smm->uncommitted, &bop);
+			if (r) {
+				DMERR("bug in bop ring buffer");
+				break;
+			}
+
+			r = commit_bop(smm, &bop);
 			if (r)
 				break;
 		}
@@ -217,7 +281,8 @@ static int sm_metadata_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
 static int sm_metadata_get_count(struct dm_space_map *sm, dm_block_t b,
 				 uint32_t *result)
 {
-	int r, i;
+	int r;
+	unsigned i;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 	unsigned adjustment = 0;
 
@@ -225,8 +290,10 @@ static int sm_metadata_get_count(struct dm_space_map *sm, dm_block_t b,
 	 * We may have some uncommitted adjustments to add.  This list
 	 * should always be really short.
 	 */
-	for (i = 0; i < smm->nr_uncommitted; i++) {
-		struct block_op *op = smm->uncommitted + i;
+	for (i = smm->uncommitted.begin;
+	     i != smm->uncommitted.end;
+	     i = brb_next(&smm->uncommitted, i)) {
+		struct block_op *op = smm->uncommitted.bops + i;
 
 		if (op->block != b)
 			continue;
@@ -254,7 +321,8 @@ static int sm_metadata_get_count(struct dm_space_map *sm, dm_block_t b,
 static int sm_metadata_count_is_more_than_one(struct dm_space_map *sm,
 					      dm_block_t b, int *result)
 {
-	int r, i, adjustment = 0;
+	int r, adjustment = 0;
+	unsigned i;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 	uint32_t rc;
 
@@ -262,8 +330,11 @@ static int sm_metadata_count_is_more_than_one(struct dm_space_map *sm,
 	 * We may have some uncommitted adjustments to add.  This list
 	 * should always be really short.
 	 */
-	for (i = 0; i < smm->nr_uncommitted; i++) {
-		struct block_op *op = smm->uncommitted + i;
+	for (i = smm->uncommitted.begin;
+	     i != smm->uncommitted.end;
+	     i = brb_next(&smm->uncommitted, i)) {
+
+		struct block_op *op = smm->uncommitted.bops + i;
 
 		if (op->block != b)
 			continue;
@@ -671,7 +742,7 @@ int dm_sm_metadata_create(struct dm_space_map *sm,
 	smm->begin = superblock + 1;
 	smm->recursion_count = 0;
 	smm->allocated_this_transaction = 0;
-	smm->nr_uncommitted = 0;
+	brb_init(&smm->uncommitted);
 	threshold_init(&smm->threshold);
 
 	memcpy(&smm->sm, &bootstrap_ops, sizeof(smm->sm));
@@ -713,7 +784,7 @@ int dm_sm_metadata_open(struct dm_space_map *sm,
 	smm->begin = 0;
 	smm->recursion_count = 0;
 	smm->allocated_this_transaction = 0;
-	smm->nr_uncommitted = 0;
+	brb_init(&smm->uncommitted);
 	threshold_init(&smm->threshold);
 
 	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
