From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-zoned: Fix overflow in exposed capacity
Date: Fri, 9 Jun 2017 08:03:39 -0400
Message-ID: <20170609120339.GB11110@redhat.com>
References: <20170609040605.4340-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170609040605.4340-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 09 2017 at 12:06am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> Cast unsigned int to sector_t before shifting. Otherwise, the target
> length overflows and becomes incorrect.
> 
> Also fix an incorrect setting of the target suspend
> operation.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-zoned-target.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 4438f30..f947166 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -773,7 +773,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->split_discard_bios = true;
>  
>  	/* The exposed capacity is the number of chunks that can be mapped */
> -	ti->len = dmz_nr_chunks(dmz->metadata) << dev->zone_nr_sectors_shift;
> +	ti->len = (sector_t)dmz_nr_chunks(dmz->metadata) << dev->zone_nr_sectors_shift;
>  
>  	/* Zone BIO */
>  	dmz->bio_set = bioset_create_nobvec(DMZ_MIN_BIOS, 0);

I folded this in, thanks.

> @@ -944,7 +944,8 @@ static struct target_type dmz_type = {
>  	.end_io		 = dmz_end_io,
>  	.io_hints	 = dmz_io_hints,
>  	.prepare_ioctl	 = dmz_prepare_ioctl,
> -	.suspend	 = dmz_suspend,
> +	.presuspend	 = dmz_suspend,
> +	.presuspend_undo = dmz_resume,
>  	.resume		 = dmz_resume,
>  	.iterate_devices = dmz_iterate_devices,
>  };

I've switched from .presuspend to .postsuspend, and eliminated the
.presuspend_undo

I'm not seeing any reason for .presuspend_undo

See dm-cache-target.c for a .postsuspend that is pretty comparable to
what dm-zoned's is doing.

As for .presuspend_undo, dm-thinp has a need for it but most target do
not.  And I'm not seeing why dm-zoned needs it.

I've pushed to linux-dm.git's 'for-next' to get more test coverage;
doesn't mean that I consider dm-zoned's review complete.

Thanks,
Mike
