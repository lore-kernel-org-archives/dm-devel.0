From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Reserve just one mempool entry
Date: Thu, 19 May 2011 12:55:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191255080.17915@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Reserve just one mempool entry

If our implementation is deadlock-free, we don't need large mempool
reserve. Just one entry is enough.

Note that in normal case, when if there is no memory pressure, we can
still allocate arbitrary number of entries from the slab cache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-kcopyd.c	2011-05-18 18:15:35.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c	2011-05-18 18:16:31.000000000 +0200
@@ -29,6 +29,7 @@
 
 #define SUB_JOB_SIZE	128
 #define SPLIT_COUNT	8
+#define MIN_JOBS	1
 
 /*-----------------------------------------------------------------
  * Each kcopyd client has its own little pool of preallocated
@@ -223,9 +224,6 @@ struct kcopyd_job {
 	struct kcopyd_job *master_job;
 };
 
-/* FIXME: this should scale with the number of pages */
-#define MIN_JOBS 512
-
 static struct kmem_cache *_job_cache;
 
 int __init dm_kcopyd_init(void)
