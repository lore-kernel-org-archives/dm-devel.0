From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Re: [PATCH 0/0] dm-mpath: queue-length oriented dynamic
	load balancer
Date: Fri, 30 Jan 2009 17:10:38 +0900
Message-ID: <4982B5FE.5040807@ct.jp.nec.com>
References: <498153BE.60104@ct.jp.nec.com>
	<20090129140335.GA27390@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090129140335.GA27390@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, stefan.bader@canonical.com
List-Id: dm-devel.ids

Hi Alasdair,

Sorry for confusing you.

On 01/29/2009 11:03 PM +0900, Alasdair G Kergon wrote:
> On Thu, Jan 29, 2009 at 03:59:10PM +0900, Kiyoshi Ueda wrote:
>> This patch-set can be applied on top of 2.6.29-rc2.
> 
> It's not clear: are you reordering the dependencies now?
> 
> Previously there were three sets of patches taken in this order:
>   1 change to request-based
>   2 add queue length ps
>   3 add service time ps
> i.e. 2 and 3 depend on 1
> 
> Are you now changing that so that 2 and 3 could go upstream before 1?

I had sent those three sets in the order above since 1 enhances 2 and 3.
But 2 and 3 don't functionally depend on 1 (although 1 and 3 have
a few cosmetic dependencies), so we can reorder that as we want.

2 and 3 are simpler patches than 1, and I found some problems in 1,
so I think reordering might be a good idea if you are OK.
As for 3, I still want to get feedback from others as it'll involve
discussion about the optimal interface for load balancer.

Thanks,
Kiyoshi Ueda
