From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm mpath: only retry ioctl if
 queue_if_no_path was configured
Date: Wed, 12 Sep 2012 13:01:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1209121301070.32704@file.rdu.redhat.com>
References: <20120831150428.GA31566@fury.redhat.com>
	<20120904145843.GA19388@redhat.com>
	<20120904161016.GA20209@redhat.com> <20120904161242.GB20209@redhat.com>
	<Pine.LNX.4.64.1209081242500.13731@file.rdu.redhat.com>
	<20120912153756.GA15930@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120912153756.GA15930@redhat.com>
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
Cc: dm-devel@redhat.com, David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

On Wed, 12 Sep 2012, Mike Snitzer wrote:

> On Sat, Sep 08 2012 at 12:50pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>  
> > It's hard to say what should be done correctly ... if you create a 
> > multipath device with "queue_if_no_path" and no active path, it should 
> > delay all requests until a path becomes available ... and it is doing 
> > that.
> > 
> > Maybe we could move the waiting loop up to dm_blk_ioctl so that it unlocks 
> > when someone reloads the target?
> 
> I think it much more likely that multipathd will restore a path then an
> entirely new table be loaded.
>  
> > BTW. there is also -EAGAIN dm_blk_ioctl if dm_suspended_md ... should this 
> > -EAGAIN be removed too or not?
> 
> Don't think it needs to be removed.  Here is a patch that addresses the
> issue for me.
> 
> ---
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: [PATCH] dm mpath: only retry ioctl if queue_if_no_path was configured
> 
> commit 35991652b ("dm mpath: allow ioctls to trigger pg init") should
> have checked if queue_if_no_path was configured before queueing IO.
> 
> Checking for the queue_if_no_path feature, like is done in map_io(),
> allows the following table load to work without blocking in the
> multipath_ioctl retry loop:
> 
>   echo "0 1024 multipath 0 0 0 0" | dmsetup create mpath_nodevs
> 
> Without this fix the multipath_ioctl will block with the following stack
> trace:
> 
>   blkid           D 0000000000000002     0 23936      1 0x00000000
>    ffff8802b89e5cd8 0000000000000082 ffff8802b89e5fd8 0000000000012440
>    ffff8802b89e4010 0000000000012440 0000000000012440 0000000000012440
>    ffff8802b89e5fd8 0000000000012440 ffff88030c2aab30 ffff880325794040
>   Call Trace:
>    [<ffffffff814ce099>] schedule+0x29/0x70
>    [<ffffffff814cc312>] schedule_timeout+0x182/0x2e0
>    [<ffffffff8104dee0>] ? lock_timer_base+0x70/0x70
>    [<ffffffff814cc48e>] schedule_timeout_uninterruptible+0x1e/0x20
>    [<ffffffff8104f840>] msleep+0x20/0x30
>    [<ffffffffa0000839>] multipath_ioctl+0x109/0x170 [dm_multipath]
>    [<ffffffffa06bfb9c>] dm_blk_ioctl+0xbc/0xd0 [dm_mod]
>    [<ffffffff8122a408>] __blkdev_driver_ioctl+0x28/0x30
>    [<ffffffff8122a79e>] blkdev_ioctl+0xce/0x730
>    [<ffffffff811970ac>] block_ioctl+0x3c/0x40
>    [<ffffffff8117321c>] do_vfs_ioctl+0x8c/0x340
>    [<ffffffff81166293>] ? sys_newfstat+0x33/0x40
>    [<ffffffff81173571>] sys_ioctl+0xa1/0xb0
>    [<ffffffff814d70a9>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index d8abb90..034233e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1555,6 +1555,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>  			   unsigned long arg)
>  {
>  	struct multipath *m = ti->private;
> +	struct pgpath *pgpath;
>  	struct block_device *bdev;
>  	fmode_t mode;
>  	unsigned long flags;
> @@ -1570,12 +1571,14 @@ again:
>  	if (!m->current_pgpath)
>  		__choose_pgpath(m, 0);
>  
> -	if (m->current_pgpath) {
> -		bdev = m->current_pgpath->path.dev->bdev;
> -		mode = m->current_pgpath->path.dev->mode;
> +	pgpath = m->current_pgpath;
> +
> +	if (pgpath) {
> +		bdev = pgpath->path.dev->bdev;
> +		mode = pgpath->path.dev->mode;
>  	}
>  
> -	if (m->queue_io)
> +	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
>  		r = -EAGAIN;
>  	else if (!bdev)
>  		r = -EIO;
> -- 
> 1.7.1
> 
