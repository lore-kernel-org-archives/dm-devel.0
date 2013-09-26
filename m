From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/2] patches to improve cluster raid1
	performance [V2]
Date: Thu, 26 Sep 2013 12:17:32 -0500
Message-ID: <5CE90943-3783-472B-BCCD-BF1F392599C3@redhat.com>
References: <cover.1380191501.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1380191501.git.dmzhang@suse.com>
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
Cc: agk@redhat.com, dongmao zhang <dmzhang@suse.com>
List-Id: dm-devel.ids

I'll try to look these patches over during the next couple days.  Thanks for sending.

One thing I'll be looking for is that any delays in the flush don't violate the need for dm-raid1.c to ensure that the log changes have hit the disk before performing any writes.

 brassow

On Sep 26, 2013, at 5:50 AM, dongmao zhang wrote:

> This patch change DM_ULOG_REQUEST_VERSION from 2 to 3. It could
> tell cmirrord that kernel is now supporting delay some flushes, and
> cmirrord will do someting accordingly.
> 
> 
> Based on my test result, the cluster raid1 writes loss 80% performance. I found
> that the most time is occupied by the function userspace_flush.
> 
> Usually userspace_flush needs three stages(mark, clear, flush)to communicate with cmirrord.
> 
>> From the cmirrord's perspective, mark and flush functions run cluster_send first and then return to 
> the kernel.
> 
> In other words, the requests of mark_region and flush in userspace_flush 
> at least require a cluster_send period to finish. this is the root cause
> of bad performance.
> 
> The idea is to merge flush and mark request together in both cmirrord and dm-log-userspace.
> 
> We run clog_flush directly after clog_mark_region. So the userspace_flush do not 
> have to request flush again after requesting mark_region.  Moreover, I think the flush 
> of clear region could be delayed. If we have both mark and clear region, only sending 
> a mark_region request is OK, because clog_flush will automatically run.(ignore the clean_region 
> time). It only takes one cluster_send period. If we have only mark region, 
> a mark_region request is also OK, it takes one cluster_send period. If we have only 
> clear_region, we could delay the flush of cleared_region for 3 seconds.
> 
> Overall, before the patch, mark_region require approximately two cluster_send
> period(mark_region and flush), after the patch, mark_region only needs one 
> cluster_send period. Based on my test, the performance is as twice as before.
> 
> 
> 
> dongmao zhang (2):
>  improve the performance of dm-log-userspace
>  change API of dm-log-userspace to support delay flush
> 
> drivers/md/dm-log-userspace-base.c    |  109 ++++++++++++++++++++++++++++++---
> include/uapi/linux/dm-log-userspace.h |    2 +-
> 2 files changed, 101 insertions(+), 10 deletions(-)
> 
> -- 
> 1.7.3.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
