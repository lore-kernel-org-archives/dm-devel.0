From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm: use revalidate_disk to update device
 size after set_capacity
Date: Wed, 20 Oct 2010 14:42:19 +0900
Message-ID: <4CBE813B.6050105@ce.jp.nec.com>
References: <20101019220711.GA25169@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101019220711.GA25169@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

(10/20/10 07:07), Mike Snitzer wrote:
> Avoid taking md->bdev->bd_inode->i_mutex to update the DM block device's
> size.  Doing so eliminates the potential for deadlock if an fsync is
> racing with a device resize.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f934e98..fd315a7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1995,10 +1995,7 @@ static void event_callback(void *context)
>  static void __set_size(struct mapped_device *md, sector_t size)
>  {
>  	set_capacity(md->disk, size);
> -
> -	mutex_lock(&md->bdev->bd_inode->i_mutex);
> -	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
> -	mutex_unlock(&md->bdev->bd_inode->i_mutex);
> +	revalidate_disk(md->disk);
>  }

Some concerns/questions:

- revalidate_disk() calls bdget() inside it.
  Does bdget() no longer block on I/O?
  Sometime ago, bdget() has been blocked by I_LOCK,
  where process holding I_LOCK blocked by resize.
  Since I_LOCK has disappeared, I suspect this might not
  be a valid concern anymore.
  FYI, past discussion on this topic:
  http://www.redhat.com/archives/dm-devel/2007-October/msg00134.html
  (it's not my intention to push the patch in the above URL)

- revalidate_disk() ends up with get_super():
    revalidate_disk
      check_disk_size_change
        flush_disk
          __invalidate_device
            get_super
  and get_super() takes sb->s_umount.
  OTOH, there are codes which wait on I/O holding s_umount
  exclusively. E.g. freeze_super() calls sync_filesystem().
  So it seems there is a possible deadlock if you use
  revalidate_disk from dm_swap_table.

I've been away from that part of the code for a while.
So it's nice if the above is just a false alarm...

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
