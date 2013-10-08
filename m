From: "Dong Mao Zhang" <dmzhang@suse.com>
Subject: Re: [PATCH 0/2] patches to improve cluster raid1
 performance [V2]
Date: Tue, 08 Oct 2013 02:33:34 -0600
Message-ID: <52545E0E0200007B0003F696@soto.provo.novell.com>
References: <cover.1380191501.git.dmzhang@suse.com>
	<7396AC8F-6B91-44AE-96C1-99C9000F8B4E@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7396AC8F-6B91-44AE-96C1-99C9000F8B4E@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, jbrassow@redhat.com
List-Id: dm-devel.ids



>>> Brassow Jonathan  09/30/13 10:28 PM >>>
Hi,

Couple quick questions/comments:
>> 1) Can you tell me more about how you are testing and comparing results?

I just setup a cluster raid1, and compare the performance before and after this patch by 'dd' command.(the block size in dd command is 
4k, 8k).
And it was tested on two kvm nodes. I guess I will test it on the real nodes in the next two week.
Do you have other suggestions on the test scenario?


>>There are some comments and other minor things to clean-up after that.  For example, I don't know if I like the name 'DM_SUPPORT_DELAY_FLUSH'...  I might >>rather prefer something that indicates that the 'mark' request is also responsible for 'flush'.  What is happening must be clear to anyone who might write a new >>log daemon in the future.  They must realize that the key change for them is that the 'mark' must handle the 'flush' - everything else is the same from their >>perspective.  It amounts to an API change.
Yes, I agree to the patch combines.
And how about the name 'DM_FLUSH_WITH_MARK'? any other ideas?



Thank you.




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


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
