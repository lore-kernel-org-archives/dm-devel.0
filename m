From: akpm@osdl.org
Subject: dm: Fix deadlock under high i/o load in raid1 setup.
Date: Sun, 27 Aug 2006 01:23:24 -0700
Message-ID: <200608270823.k7R8NO3M020753@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: torvalds@osdl.org
Cc: akpm@osdl.org, kobras@linux.de, stable@kernel.org, agk@redhat.com
List-Id: dm-devel.ids

From: Daniel Kobras <kobras@linux.de>

On an nForce4-equipped machine with two SATA disk in raid1 setup using dmraid,
we experienced frequent deadlock of the system under high i/o load.  'cat
/dev/zero > ~/zero' was the most reliable way to reproduce them: Randomly
after a few GB, 'cp' would be left in 'D' state along with kjournald and
kmirrord.  The functions cp and kjournald were blocked in did vary, but
kmirrord's wchan always pointed to 'mempool_alloc()'.  We've seen this pattern
on 2.6.15 and 2.6.17 kernels.  http://lkml.org/lkml/2005/4/20/142 indicates
that this problem has been around even before.

So much for the facts, here's my interpretation: mempool_alloc() first tries
to atomically allocate the requested memory, or falls back to hand out
preallocated chunks from the mempool.  If both fail, it puts the calling
process (kmirrord in this case) on a private waitqueue until somebody refills
the pool.  Where the only 'somebody' is kmirrord itself, so we have a
deadlock.

I worked around this problem by falling back to a (blocking) kmalloc when
before kmirrord would have ended up on the waitqueue.  This defeats part of
the benefits of using the mempool, but at least keeps the system running.  And
it could be done with a two-line change.  Note that mempool_alloc() clears the
GFP_NOIO flag internally, and only uses it to decide whether to wait or return
an error if immediate allocation fails, so the attached patch doesn't change
behaviour in the non-deadlocking case.  Path is against current git
(2.6.18-rc4), but should apply to earlier versions as well.  I've tested on
2.6.15, where this patch makes the difference between random lockup and a
stable system.

Signed-off-by: Daniel Kobras <kobras@linux.de>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.17.11.orig/drivers/md/dm-raid1.c
+++ linux-2.6.17.11/drivers/md/dm-raid1.c
@@ -253,7 +253,9 @@ static struct region *__rh_alloc(struct 
 	struct region *reg, *nreg;
 
 	read_unlock(&rh->hash_lock);
-	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
+	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
+	if (unlikely(!nreg))
+		nreg = kmalloc(sizeof(struct region), GFP_NOIO);
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		RH_CLEAN : RH_NOSYNC;
 	nreg->rh = rh;

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-fix-metadata-writing-when-suspending

commit 927ffe7c9a156e259aae31c07dd76072c459ec57
Author: Mark McLoughlin <markmc@redhat.com>
Date:   Tue Oct 3 01:15:27 2006 -0700

    [PATCH] dm snapshot: fix metadata writing when suspending
    
    When suspending a device-mapper device, dm_suspend() sleeps until all
    necessary I/O is completed.  This state is triggered by a callback from
    persistent_commit().  But some I/O can still be issued *after* the callback
    (to prepare the next metadata area for use if the current one is full).  This
    patch delays the callback until after that I/O is complete.
    
    Signed-off-by: Mark McLoughlin <markmc@redhat.com>
    Signed-off-by: Alasdair G Kergon <agk@redhat.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 002417d..99cdffa 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -536,6 +536,16 @@ static void persistent_commit(struct exc
 		if (r)
 			ps->valid = 0;
 
+		/*
+		 * Have we completely filled the current area ?
+		 */
+		if (ps->current_committed == ps->exceptions_per_area) {
+			ps->current_committed = 0;
+			r = zero_area(ps, ps->current_area + 1);
+			if (r)
+				ps->valid = 0;
+		}
+
 		for (i = 0; i < ps->callback_count; i++) {
 			cb = ps->callbacks + i;
 			cb->callback(cb->context, r == 0 ? 1 : 0);
@@ -543,16 +553,6 @@ static void persistent_commit(struct exc
 
 		ps->callback_count = 0;
 	}
-
-	/*
-	 * Have we completely filled the current area ?
-	 */
-	if (ps->current_committed == ps->exceptions_per_area) {
-		ps->current_committed = 0;
-		r = zero_area(ps, ps->current_area + 1);
-		if (r)
-			ps->valid = 0;
-	}
 }
 
 static void persistent_drop(struct exception_store *store)

--WIyZ46R2i8wDzkSu--
