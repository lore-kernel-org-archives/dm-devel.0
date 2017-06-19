From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] dm integrity tests crash kernel (4.12-rc5)
Date: Mon, 19 Jun 2017 17:16:38 +0200
Message-ID: <ad400234-fde1-5ff7-246e-91ded98764e2@redhat.com>
References: <2b97933e-3f94-8510-cefd-13fae445400e@redhat.com>
 <d32598d1-2ae3-6b0a-690f-7d7dfa43899e@redhat.com>
 <20170619142026.GA92582@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619142026.GA92582@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On 06/19/2017 04:20 PM, Mike Snitzer wrote:
>
> Looks like submit_flush_bio() is disabling/enabling interrupts from
> interrupt context.  Ondrej, does this patch fix the issue?

I let it spin for 30 minutes on patched dm-integrity and everything 
seems ok now. The moment I loaded back the old one it fell on face 
almost immediately again.

Thanks!

>
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 4ab10cf..93b1810 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -1105,10 +1105,13 @@ static void schedule_autocommit(struct dm_integrity_c *ic)
>  static void submit_flush_bio(struct dm_integrity_c *ic, struct dm_integrity_io *dio)
>  {
>  	struct bio *bio;
> -	spin_lock_irq(&ic->endio_wait.lock);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ic->endio_wait.lock, flags);
>  	bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
>  	bio_list_add(&ic->flush_bio_list, bio);
> -	spin_unlock_irq(&ic->endio_wait.lock);
> +	spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
> +
>  	queue_work(ic->commit_wq, &ic->commit_work);
>  }
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
