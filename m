From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm-snapshot: use GFP_KERNEL when
 initializing the snapshot
Date: Sat, 11 Jan 2014 12:30:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The list of initial exceptions is loaded in the target constructor. We are
allowed to allocate memory with GFP_KERNEL at this point. So, change
alloc_completed_exception to use GFP_KERNEL when being called from the
constructor.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-snap.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-snap.c	2014-01-09 20:42:51.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-snap.c	2014-01-09 20:43:41.000000000 +0100
@@ -610,12 +610,12 @@ static struct dm_exception *dm_lookup_ex
 	return NULL;
 }
 
-static struct dm_exception *alloc_completed_exception(void)
+static struct dm_exception *alloc_completed_exception(gfp_t gfp)
 {
 	struct dm_exception *e;
 
-	e = kmem_cache_alloc(exception_cache, GFP_NOIO);
-	if (!e)
+	e = kmem_cache_alloc(exception_cache, gfp);
+	if (!e && gfp == GFP_NOIO)
 		e = kmem_cache_alloc(exception_cache, GFP_ATOMIC);
 
 	return e;
@@ -697,7 +697,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(GFP_KERNEL);
 	if (!e)
 		return -ENOMEM;
 
@@ -1405,7 +1405,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(GFP_NOIO);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
