From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Don't split SUB_JOB_SIZE jobs
Date: Thu, 19 May 2011 12:59:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191258290.17915@hs20-bc2-1.build.redhat.com>
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

Don't split SUB_JOB_SIZE jobs

If the job size equals SUB_JOB_SIZE, there is no point in splitting it.
Splitting it just unnecessarily wastes time, because the split job size
is SUB_JOB_SIZE too.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-kcopyd.c	2011-05-18 18:20:42.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c	2011-05-18 18:20:52.000000000 +0200
@@ -577,7 +577,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->fn = fn;
 	job->context = context;
 
-	if (job->source.count < SUB_JOB_SIZE)
+	if (job->source.count <= SUB_JOB_SIZE)
 		dispatch_job(job);
 
 	else {
