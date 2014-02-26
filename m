From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Do not stall on invalid ioctls
Date: Wed, 26 Feb 2014 09:56:27 -0500
Message-ID: <20140226145624.GA32095@redhat.com>
References: <1393405624-46796-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1393405624-46796-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 26 2014 at  4:07am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> An invalid ioctl is an invalid ioctl, irrespective on whether
> multipath has active paths or not. And for invalid ioctls
> we do not have to wait for multipath to activate any paths,
> but can rather return the error code immediately.
> This resolves numerous instances of
> 
> udevd[]: worker [] unexpectedly returned with status 0x0100
> 
> we have seen during testing.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 6eb9dc9..e8431fb 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1626,8 +1626,13 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>  	/*
>  	 * Only pass ioctls through if the device sizes match exactly.
>  	 */
> -	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
> -		r = scsi_verify_blk_ioctl(NULL, cmd);
> +	if (!bdev || ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT) {
> +		int err;
> +
> +		err = scsi_verify_blk_ioctl(NULL, cmd);
> +		if (err)
> +			r = err;
> +	}
>  
>  	if (r == -ENOTCONN && !fatal_signal_pending(current))
>  		queue_work(kmultipathd, &m->process_queued_ios);

I've tweaked the header and code slightly, marked it for stable and
staged it here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a1989b330093578ea5470bea0a00f940c444c466

Should be on its way upstream on Friday.

Thanks.
