From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 6/7] dm: track the maximum number of bios in
 a cloned request
Date: Thu, 12 Sep 2013 18:55:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309121851160.31794@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-7-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379024698-10487-7-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

There's a race condition (it's not serious):

+               if (num_bios > ACCESS_ONCE(peak_rq_based_ios))
+                       ACCESS_ONCE(peak_rq_based_ios) = num_bios;

You can double-check it using code like this:
if (num_bios > ACCESS_ONCE(peak_rq_based_ios)) {
	spin_lock_irqsave(&peak_rq_based_ios_lock, flags);
	if (num_bios > peak_rq_based_ios)
		peak_rq_based_ios = num_bios;
	spin_unlock_irqrestore(&peak_rq_based_ios_lock, flags);
}


Maybe - reset the value peak_rq_based_ios if the user clears 
track_peak_rq_based_ios?

Mikulas

On Thu, 12 Sep 2013, Mike Snitzer wrote:

> If /sys/modules/dm_mod/parameters/track_peak_rq_based_ios is set to 1 it
> enables the tracking of the maximum number of bios in a cloned request.
> 
> The maximum number of bios in a cloned request is then exposed through
> the following read-only parameter:
> /sys/modules/dm_mod/parameters/peak_rq_based_ios
> 
> This information can be useful when deciding on a value for dm_mod's
> 'reserved_rq_based_ios' parameter.  Otherwise, 'track_peak_rq_based_ios'
> should be kept disabled (the default).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 186f77d..de83930 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -239,6 +239,12 @@ static unsigned reserved_rq_based_ios;
>  static unsigned reserved_rq_based_ios_latch;
>  
>  /*
> + * Optionally track the maximum numbers of IOs in a cloned request.
> + */
> +static unsigned track_peak_rq_based_ios;
> +static unsigned peak_rq_based_ios;
> +
> +/*
>   * This mutex protects reserved_bio_based_ios_latch and reserved_rq_based_ios_latch.
>   */
>  static DEFINE_MUTEX(dm_mempools_lock);
> @@ -1719,6 +1725,16 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
>  		return NULL;
>  	}
>  
> +	if (unlikely(ACCESS_ONCE(track_peak_rq_based_ios))) {
> +		struct bio *bio;
> +		unsigned num_bios = 0;
> +
> +		__rq_for_each_bio(bio, clone)
> +			num_bios++;
> +		if (num_bios > ACCESS_ONCE(peak_rq_based_ios))
> +			ACCESS_ONCE(peak_rq_based_ios) = num_bios;
> +	}
> +
>  	return clone;
>  }
>  
> @@ -3034,6 +3050,12 @@ MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
>  module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
>  
> +module_param(track_peak_rq_based_ios, uint, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(peak_rq_based_ios, "Enable tracking the maximum IOs in a cloned request");
> +
> +module_param(peak_rq_based_ios, uint, S_IRUGO);
> +MODULE_PARM_DESC(peak_rq_based_ios, "Tracks the maximum IOs in a cloned request");
> +
>  MODULE_DESCRIPTION(DM_NAME " driver");
>  MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
>  MODULE_LICENSE("GPL");
> -- 
> 1.8.1.4
> 
