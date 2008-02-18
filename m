From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] dm core: remove dead codes
Date: Mon, 18 Feb 2008 15:45:38 -0500 (EST)
Message-ID: <20080218.154538.71086906.k-ueda@ct.jp.nec.com>
References: <20080215.175505.34761653.k-ueda@ct.jp.nec.com>
	<20080218122148.GI1788@agk.fab.redhat.com>
	<20080218123403.GJ1788@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080218123403.GJ1788@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

On Mon, 18 Feb 2008 12:34:03 +0000, Alasdair G Kergon wrote:
> On Mon, Feb 18, 2008 at 12:21:48PM +0000, Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 05:55:05PM -0500, Kiyoshi Ueda wrote:
> > > This patch removes dead codes for the noflush suspend.
> > I've been sent (unfinished) patches for 2.6.26 (or even 2.6.25 if people
> > consider the reinstatement of flushing support important enough) that
> > build on this one.
>  
> That was ambiguous:-(  I meant that code has only just got added to the
> kernel and there are patches waiting to be finished that use it - it's
> not dead code.

You mean that the DM_WQ_FLUSH_ALL will be used, but the code
in dm_suspend() below won't be used, right?

If so, I'd like to remove only that part, since nobody won't run
the 'flush_and_out' part.
Is it OK for you?

> @@ -1472,7 +1468,7 @@ int dm_suspend(struct mapped_device *md,
>  		if (!md->suspended_bdev) {
>  			DMWARN("bdget failed in dm_suspend");
>  			r = -ENOMEM;
> -			goto flush_and_out;
> +			goto out;
>  		}
>  
>  		/*
> @@ -1523,14 +1519,6 @@ int dm_suspend(struct mapped_device *md,
>  
>  	set_bit(DMF_SUSPENDED, &md->flags);
>  
> -flush_and_out:
> -	if (r && noflush)
> -		/*
> -		 * Because there may be already I/Os in the pushback list,
> -		 * flush them before return.
> -		 */
> -		dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL);
> -
>  out:
>  	if (r && md->suspended_bdev) {
>  		bdput(md->suspended_bdev);

Thanks,
Kiyoshi Ueda
