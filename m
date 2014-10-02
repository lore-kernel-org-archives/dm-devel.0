From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid: add RAID discard support
Date: Wed, 1 Oct 2014 21:31:36 -0400
Message-ID: <20141002013135.GA21091@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<20141001133237.GB16521@redhat.com>
	<20141002093403.25cc832f@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141002093403.25cc832f@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

Hi,

On Wed, Oct 01 2014 at  7:34pm -0400,
NeilBrown <neilb@suse.de> wrote:

> On Wed, 1 Oct 2014 09:32:37 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > 
> > I had the same thought and would be happy with this too.  I was going to
> > update Heinz's patch to have the same default off but allow user to
> > enable:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8e0cff64f35971135a6de7907bbc8c3a010aff8f
> > 
> > But I'd love to just follow what you arrive at with MD (using the same
> > name for the module param in dm-raid).
> > 
> > I'm open to getting this done now and included in 3.18 if you are.
> > 
> > Mike
> 
> How about something like this?
> I want to keep it well away from regular API stuff as I hope it is just a
> temporary hack until a more general solution can be found and implemented.
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 183588b11fc1..3ed668c5378c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -64,6 +64,10 @@
>  #define cpu_to_group(cpu) cpu_to_node(cpu)
>  #define ANY_GROUP NUMA_NO_NODE
>  
> +static bool devices_handle_discard_safely = false;
> +module_param(devices_handle_discard_safely, bool, false);
> +MODULE_PARM_DESC(devices_handle_discard_safely,
> +		 "Set to Y if all devices in array reliably return zeroes on reads from discarded regions");
>  static struct workqueue_struct *raid5_wq;
>  /*
>   * Stripe cache
> @@ -6208,7 +6212,7 @@ static int run(struct mddev *mddev)
>  		mddev->queue->limits.discard_granularity = stripe;
>  		/*
>  		 * unaligned part of discard request will be ignored, so can't
> -		 * guarantee discard_zerors_data
> +		 * guarantee discard_zeroes_data
>  		 */
>  		mddev->queue->limits.discard_zeroes_data = 0;
>  
> @@ -6233,6 +6237,18 @@ static int run(struct mddev *mddev)
>  			    !bdev_get_queue(rdev->bdev)->
>  						limits.discard_zeroes_data)
>  				discard_supported = false;
> +			/* Unfortunately, discard_zeroes_data is not currently
> +			 * a guarantee - just a hint.  So we only allow DISCARD
> +			 * if the sysadmin has confirmed that only safe devices
> +			 * are in use but setting a module parameter.
> +			 */
> +			if (!devices_handle_discard_safely) {
> +				if (discard_supported) {
> +					pr_info("md/raid456: discard support disabled due to uncertainty.\n");
> +					pr_info("Set raid456.devices_handle_discard_safely=Y to override.\n");
> +				}
> +				discard_supported = false;
> +			}
>  		}
>  
>  		if (discard_supported &&


There is a typo in the new block comment above: "are in use but setting
a module parameter".  s/but/by/

But thinking further: should this be a per array override?  E.g. for DM
this could easily be a dm-raid table parameter.  But I know the MD
implementation would likely be more cumbersome (superblock update?).

Though given the (hopefully) temporary nature of this, maybe it isn't
worth it for MD.  Maybe be a bit more precise in the MODULE_PARM_DESC
with: 
"Set to Y if all devices in each array reliably returns zeroes on reads
from discarded regions" ?
