From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] raid1: use __GFP_NOFAIL
Date: Fri, 1 May 2009 00:14:43 +0100
Message-ID: <20090430231443.GD23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904270658390.12384@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904270658390.12384@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27, 2009 at 07:01:22AM -0400, Mikulas Patocka wrote:
> This is a bug I found when implementing the barriers. There should be 
> __GFP_NOFAIL if the code can't handle an allocation failure.
 
See also this one:
  dm-raid1-mempool-bug-workaround-reversion.patch

Has the original reason for that workaround gone away now or is that
mempool still being used incorrectly?

Alasdair


From: Alasdair G Kergon <agk@redhat.com>

Implement private fallback if immediate allocation from mempool fails.
Standard mempool_alloc() fallback can yield a deadlock when only the
calling process is able to refill the pool. In out-of-memory situations,
instead of waiting for itself, kmirrord now waits for someone else to
free some space, using a standard blocking allocation.

Signed-off-by: Daniel Kobras <kobras@linux.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
[AGK - This patch reverses the mempool workaround described above.]

 drivers/md/dm-raid1.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.19/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.19.orig/drivers/md/dm-raid1.c	2006-12-06 20:49:41.000000000 +0000
+++ linux-2.6.19/drivers/md/dm-raid1.c	2006-12-06 20:49:44.000000000 +0000
@@ -261,9 +261,7 @@ static struct region *__rh_alloc(struct 
 	struct region *reg, *nreg;
 
 	read_unlock(&rh->hash_lock);
-	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
-	if (unlikely(!nreg))
-		nreg = kmalloc(sizeof(struct region), GFP_NOIO);
+	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		RH_CLEAN : RH_NOSYNC;
 	nreg->rh = rh;
