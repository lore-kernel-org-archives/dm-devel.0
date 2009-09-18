From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm: Set safe default max_sectors for
	targets with no underlying device
Date: Fri, 18 Sep 2009 11:52:17 -0400
Message-ID: <20090918155217.GA28926@redhat.com>
References: <4AB3A4CC.4010708@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB3A4CC.4010708@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 18 2009 at 11:18am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> This is a preparation for the next patch, which changes
> blk_set_default_limits() to set 0 for max_sectors/max_hw_sectors.
> With the next patch, for dm targets like 'zero', where there's no
> underlying device, those values remain 0 and the dm device becomes
> unusable.
> 
> So check the max_sectors and set to SAFE_MAX_SECTORS if 0.
> 
> Check this thread for further background:
> https://www.redhat.com/archives/dm-devel/2009-September/msg00176.html
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: David Strand <dpstrand@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/md/dm-table.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux-2.6.31.work/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.31.work.orig/drivers/md/dm-table.c
> +++ linux-2.6.31.work/drivers/md/dm-table.c
> @@ -707,6 +707,17 @@ static int validate_hardware_logical_blo
>  		    device_logical_block_size_sects - next_target_start : 0;
>  	}
> 
> +	/*
> +	 * blk_set_default_limits() sets max_sectors/max_hw_sectors to 0.
> +	 * When all targets have no underlying device, they are
> +	 * left unchanged from the default values and cause problems.
> +	 * Use SAFE_MAX_SECTORS for such cases.
> +	 */
> +	if (limits->max_hw_sectors == 0)
> +		limits->max_hw_sectors = SAFE_MAX_SECTORS;
> +	if (limits->max_sectors == 0)
> +		limits->max_sectors = SAFE_MAX_SECTORS;
> +
>  	if (remaining) {
>  		DMWARN("%s: table line %u (start sect %llu len %llu) "
>  		       "not aligned to h/w logical block size %u",

The blk_set_default_limits() that matters, as referenced in your comment
block, is actually in dm_calculate_queue_limits().

It would be better to put these checks in dm_calculate_queue_limits()
just before the call to validate_hardware_logical_block_alignment().

Either way works because the checks are effectively at the end of
dm_calculate_queue_limits() -- which is where they need to be.

But I think you're polluting validate_hardware_logical_block_alignment()
with unrelated checks.

Thanks,
Mike
