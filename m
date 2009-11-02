From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: accept zero-size jobs
Date: Sun, 1 Nov 2009 21:09:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911012108001.18194@hs20-bc2-1.build.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This is a simple patch that makes kcopyd accept zero-size jobs. It is 
needed for handling snapshot resizing in shared snapshots.

Mikulas

--

dm-kcopyd: accept zero-size jobs

This patch changes dm-kcopyd so that it accepts zero-size jobs and completes
them immediatelly via its completion thread.

It is needed for multisnapshots snapshot resizing. When we are writing to
a chunk beyond origin end, no copying is done. To simplify the code, we submit
an empty request to kcopyd and let kcopyd complete it. If we didn't submit
a request to kcopyd and called the completion routine immediatelly, it would
violate the principle that completion is called only from one thread and
it would need additional locking.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.31.5-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.31.5-fast.orig/drivers/md/dm-kcopyd.c	2009-11-02 01:21:49.000000000 +0100
+++ linux-2.6.31.5-fast/drivers/md/dm-kcopyd.c	2009-11-02 01:22:01.000000000 +0100
@@ -450,7 +450,10 @@ static void dispatch_job(struct kcopyd_j
 {
 	struct dm_kcopyd_client *kc = job->kc;
 	atomic_inc(&kc->nr_jobs);
-	push(&kc->pages_jobs, job);
+	if (unlikely(!job->source.count))
+		push(&kc->complete_jobs, job);
+	else
+		push(&kc->pages_jobs, job);
 	wake(kc);
 }
 
