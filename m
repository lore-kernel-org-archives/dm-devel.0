From: dongmao zhang <dmzhang@suse.com>
Subject: [PATCH 0/1] ideas to improve the write performance of
	cluster dm-raid1
Date: Tue, 10 Sep 2013 17:25:11 +0800
Message-ID: <cover.1378804287.git.dmzhang@suse.com>
References: <yes>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yes>
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
Cc: dongmao zhang <dmzhang@suse.com>
List-Id: dm-devel.ids

Dear list,

Based on my test result, the cluster raid1 writes loss 80% performance. I found
that the most time is occupied by the function userspace_flush.

Usually userspace_flush needs three stages(mark, clear, flush)to communicate with cmirrord.
From the cmirrord's perspective, mark and flush functions run cluster_send first and then return to 
the kernel. And we can ignore the clear request which is fast.

In other words, the requests of mark_region and flush in userspace_flush 
at least require a cluster_send period to finish. this is the root cause
of bad performance.

The idea is to merge flush and mark request together in both cmirrord and dm-log-userspace.

A simple patch for cmirrord could be like this:

--- lvm2-2_02_98.orig/daemons/cmirrord/functions.c
+++ lvm2-2_02_98/daemons/cmirrord/functions.c
@@ -1720,7 +1720,8 @@ int do_request(struct clog_request *rq,
		r = clog_flush(&rq->u_rq, server);
		break;
	case DM_ULOG_MARK_REGION:
-   r = clog_mark_region(&rq->u_rq, rq->originator);
+   if (clog_mark_region(&rq->u_rq, rq->originator) == 0)
+     r = clog_flush(&rq->u_rq, server);
		break;
	case DM_ULOG_CLEAR_REGION:
		r = clog_clear_region(&rq->u_rq, rq->originator);

We run clog_flush directly after clog_mark_region. So the userspace_flush do not 
have to request flush again after requesting mark_region.  Moreover, I think the flush 
of clear region could be delayed. If we have both mark and clear region, only sending 
a mark_region request is OK, because clog_flush will automatically run.(ignore the clean_region 
time). It only takes one cluster_send period. If we have only mark region, 
a mark_region request is also OK, it takes one cluster_send period. If we have only 
clear_region, we could delay the flush of cleared_region for 3 seconds.

Overall, before the patch, mark_region require approximately two cluster_send
period(mark_region and flush), after the patch, mark_region only needs one 
cluster_send period. Based on my test, the performance is as twice as before.

So above are my some ideas to improve the performence. I have not tested it
in some node failure situation. If I am wrong ,please correct me.


dongmao zhang (1):
  improve the performance of dm-log-userspace

 drivers/md/dm-log-userspace-base.c |   57 ++++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 5 deletions(-)

-- 
1.7.3.4
