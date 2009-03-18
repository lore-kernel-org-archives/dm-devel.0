From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] kcopyd+snapshots race condition
Date: Wed, 18 Mar 2009 19:14:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903181914120.25113@hs20-bc2-1.build.redhat.com>
References: <20090316190642.GH5098@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903170920000.26754@hs20-bc2-1.build.redhat.com>
	<20090317203838.GQ3063@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903181913260.25113@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0903181913260.25113@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Test for job->pages being zero. This will be needed for the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.29-rc8-devel/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.29-rc8-devel.orig/drivers/md/dm-kcopyd.c	2009-03-18 20:39:07.000000000 +0100
+++ linux-2.6.29-rc8-devel/drivers/md/dm-kcopyd.c	2009-03-18 20:39:19.000000000 +0100
@@ -297,7 +297,8 @@ static int run_complete_job(struct kcopy
 	dm_kcopyd_notify_fn fn = job->fn;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	kcopyd_put_pages(kc, job->pages);
+	if (job->pages)
+		kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
