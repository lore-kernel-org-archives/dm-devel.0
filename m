From: Frans Pop <elendil@planet.nl>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 20:52:49 +0200
Message-ID: <200906252052.50364.elendil@planet.nl>
References: <200906250904.57149.elendil@planet.nl>
	<200906251953.34253.elendil@planet.nl>
	<20090625182302.GA23113@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090625182302.GA23113@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thursday 25 June 2009, Mike Snitzer wrote:
> OK, I found a really stupid bug.  I was passing the data start offset
> (pe_start) through to blk_stack_limits() in terms of sectors rather
> than bytes.  The following should silence your warnings:

Yes, all clear again. So not broken userspace after all ;-)

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>

Thanks,
FJP

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4899ebe..2cba557 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_target *ti,
> struct dm_dev *dev, return 0;
>  	}
>
> -	if (blk_stack_limits(limits, &q->limits, start) < 0)
> +	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
>  		DMWARN("%s: target device %s is misaligned",
>  		       dm_device_name(ti->table->md), bdevname(bdev, b));
