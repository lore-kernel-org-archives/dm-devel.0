From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] raid1: use __GFP_NOFAIL
Date: Mon, 27 Apr 2009 07:01:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270658390.12384@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is a bug I found when implementing the barriers. There should be 
__GFP_NOFAIL if the code can't handle an allocation failure.

Mikulas

--

If the code can't handle allocation failures, use __GFP_NOFAIL - so that
in case of memory pressure the allocator will retry indefinitely and
won't return NULL which would cause a crash in the function.

This is still not a correct fix, it may cause a classic deadlock when
memory manager waits for I/O being done and I/O waits for some free memory.
I/O code shouldn't allocate any memory. But in this case it probably
doesn't matter much in practice, people usually do not swap on RAID.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-region-hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-region-hash.c	2009-04-24 09:38:43.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c	2009-04-24 09:39:56.000000000 +0200
@@ -292,7 +292,7 @@ static struct dm_region *__rh_alloc(stru
 
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
 	if (unlikely(!nreg))
-		nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
+		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
 
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
