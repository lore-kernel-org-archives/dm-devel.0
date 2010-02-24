From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: rqdm: bad usage of dm_get/dm_put (Was: Re: dm mpath: fix
 stall when requeueing io)
Date: Wed, 24 Feb 2010 17:16:28 +0900
Message-ID: <4B84E05C.4070300@ct.jp.nec.com>
References: <20100219163257.186977438@kvm.kroah.org>
	<4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com>
	<20100223175331.GE560@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mikulas, Alasdair,

Thank you for spotting this.

On 02/24/2010 04:52 AM +0900, Mikulas Patocka wrote:
> Another problem:
> dm_request_fn can be called in an interrupt context, I scanned it for 
> calling process-context functions and found:
> 
> It may call rq_completed (either directly, via
> dm_request_fn->map_request->dm_kill_unmapped_request->dm_complete_request
> ->dm_done->dm_end_request->dm_put) or indirectly, when the request is
> completed from host controller interrupt. And dm_put is a process_context 
> function.
>
> I believe it doesn't cause a real crash, because dm_put is called in 
> dm_blk_close, thus there is always at least one reference. When the device 
> is closed with dm_blk_close, there should be no requests on it.
> 
> But it is simply a logic error to call a process-context function from 
> an interrupt context. I'd remove those dm_get/dm_put from 
> request-based-dm --- they are not needed anyway, as long as there are 
> requests, the "mapped_device" structure can't disappear.
 
Indeed, we shouldn't use the current dm_put() in any interrupt-context.
But the "mapped_device" can disappear in request-based dm while there
is a request after all bios complete, so I used dm_get()/dm_put() there.
I'll consider another way to prevent the problem without dm_get()/dm_put().
E.g. wait for request completion in dm_put() instead.


> You can apply this (in 2.6.34-rc1) to catch all the errorneous users of 
> dm_put.
<snip>
> @@ -2188,6 +2188,7 @@ void dm_put(struct mapped_device *md)
>  	struct dm_table *map;
>  
>  	BUG_ON(test_bit(DMF_FREEING, &md->flags));
> +	might_sleep();
>  
>  	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
>  		map = dm_get_live_table(md);

The current request-based dm usually calls dm_put() from softirq context
and is warned a lot, so don't apply this patch until I fix the problem
above with another way.

Thanks,
Kiyoshi Ueda
