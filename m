From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm crypt: fix lost ioprio when queuing
 crypto bios from task with ioprio
Date: Thu, 6 Dec 2018 16:04:42 -0700
Message-ID: <3cc2f4c2-956d-bae4-563f-33d122e258e8@kernel.dk>
References: <20181206221507.5423-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181206221507.5423-1-snitzer@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com
List-Id: dm-devel.ids

 > diff --git a/block/bio.c b/block/bio.c
> index 0c2208a5446d..ed68fdd78547 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -647,6 +647,30 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
>  }
>  EXPORT_SYMBOL(bio_clone_fast);
>  
> +/**
> + *	bio_set_task_prio - set bio's ioprio to task's ioprio, if any.
> + *	@bio: bio to set the ioprio of, can be NULL
> + *	@task: task of interest
> + *	@gfp_flags: allocation flags, used if allocation is necessary
> + *	@node: allocation node, used if allocation is necessary
> + */
> +void bio_set_task_prio(struct bio *bio, struct task_struct *task,
> +		       gfp_t gfp_flags, int node)
> +{
> +	struct io_context *ioc;
> +
> +	if (!bio)
> +		return;
> +
> +	ioc = get_task_io_context(current, gfp_flags, node);
> +	if (ioc) {
> +		if (ioprio_valid(ioc->ioprio))
> +			bio_set_prio(bio, ioc->ioprio);
> +		put_io_context(ioc);
> +	}
> +}
> +EXPORT_SYMBOL(bio_set_task_prio);
>

Shouldn't this just be a lookup, not a create io context? If the io
priority has been set, the ioc would exist anyway.

void bio_set_prio_from_current(struct bio *bio)
{
	struct io_context *ioc = current->io_context;

	if (ioc && ioprio_valid(ioc->ioprio))
		bio_set_prio(bio, ioc->ioprio);
}

and rename it like so. I don't like passing in the task, and all the
users are 'current' anyway. Passing in a task_struct implies that we
could have looked it up and would need a reference to it.

And don't make it pass in bio == NULL, that's just odd.

Apart from that, looks fine ;-)

-- 
Jens Axboe
