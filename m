From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 15:14:17 -0500
Message-ID: <20180117201417.GA6455@redhat.com>
References: <a096db4d-1c32-4682-844d-4a7fc02d47da@email.android.com>
	<1516218304.2820.51.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516218304.2820.51.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  2:45pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Wed, 2018-01-17 at 14:36 -0500, Mike Snitzer wrote:
> > That tree doesn't have the revert you think it does (because it doesn't have _any_ of the dm-4.16 changes).
> > 
> > So there is some other reason for your hang.
> 
> Hello Mike,
> 
> Please have another look, namely at the following commit:
> https://github.com/bvanassche/linux/commit/cd0b6b9f8779a0b692b1ef1d1f5ba6cb2fd981c5
> 
> That contents of that commit is as follows:
> 
> Subject: [PATCH] Revert "dm rq: Avoid that request processing stalls sporadically"
> 
> This reverts commit 6077c2d706097c00d8f2fed57d3f3c45cd228ee8.
> ---
>  drivers/md/dm-rq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 85d80b8ccc33..a9e0f6ec62b6 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -773,7 +773,6 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		/* Undo dm_start_request() before requeuing */
>  		rq_end_stats(md, rq);
>  		rq_completed(md, rq_data_dir(rq), false);
> -		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
>  		return BLK_STS_RESOURCE;
>  	}
>  

Fine, the chrome browser on my phone displayed "master" rather than your
other branch.

BUT my broader point stands: you aren't testing the dm-4.16 changes.  By
just reverting that commit you're creating a self-fulfilling prophecy
(that you'll see hangs without it).

Fact is you should pull all of dm-4.16 in, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16

But these dm-4.16 changes are particularly important:
050af08ffb1b dm mpath: return DM_MAPIO_REQUEUE on blk-mq rq allocation failure
459b54019cfe dm mpath: return DM_MAPIO_DELAY_REQUEUE if QUEUE_IO or PG_INIT_REQUIRED
ec3eaf9a6731 dm mpath: don't call blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE
4dd6edd23e7e dm mpath: delay the retry of a request if the target responded as busy

This last one is the commit that _should_ serve as a proper replacement
for the change you manually reverted in your branch.

Please re-test after pulling in dm-4.16 and let us know how things fair.

Thanks!
Mike
