From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: fix md_write_start() deadlock w/o
	metadata devices
Date: Sun, 18 Feb 2018 10:12:21 -0800
Message-ID: <20180218181221.a5l5nzgav7s6smor@kernel.org>
References: <054eff295e0cd2df2b11a3f9ba3b3d66e89beb47.1517609290.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <054eff295e0cd2df2b11a3f9ba3b3d66e89beb47.1517609290.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 02, 2018 at 11:13:19PM +0100, Heinz Mauelshagen wrote:
> If no metadata devices are configured on raid1/4/5/6/10
> (e.g. via dm-raid), md_write_start() unconditionally waits
> for superblocks to be written thus deadlocking.
> 
> Fix introduces mddev->has_superblocks bool, defines it in md_run()
> and checks for it in md_write_start() to conditionally avoid waiting.
> 
> Once on it, check for non-existing superblocks in md_super_write().
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=198647
> Fixes: cc27b0c78c796 ("md: fix deadlock between mddev_suspend() and md_write_start()")

Applied, thanks! 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/md.c | 10 ++++++++++
>  drivers/md/md.h |  2 ++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0081ace39a64..8a7e7034962c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -801,6 +801,9 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>  	struct bio *bio;
>  	int ff = 0;
>  
> +	if (!page)
> +		return;
> +
>  	if (test_bit(Faulty, &rdev->flags))
>  		return;
>  
> @@ -5452,6 +5455,7 @@ int md_run(struct mddev *mddev)
>  	 * the only valid external interface is through the md
>  	 * device.
>  	 */
> +	mddev->has_superblocks = false;
>  	rdev_for_each(rdev, mddev) {
>  		if (test_bit(Faulty, &rdev->flags))
>  			continue;
> @@ -5465,6 +5469,9 @@ int md_run(struct mddev *mddev)
>  				set_disk_ro(mddev->gendisk, 1);
>  		}
>  
> +		if (rdev->sb_page)
> +			mddev->has_superblocks = true;
> +
>  		/* perform some consistency tests on the device.
>  		 * We don't want the data to overlap the metadata,
>  		 * Internal Bitmap issues have been handled elsewhere.
> @@ -8049,6 +8056,7 @@ EXPORT_SYMBOL(md_done_sync);
>  bool md_write_start(struct mddev *mddev, struct bio *bi)
>  {
>  	int did_change = 0;
> +
>  	if (bio_data_dir(bi) != WRITE)
>  		return true;
>  
> @@ -8081,6 +8089,8 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
>  	rcu_read_unlock();
>  	if (did_change)
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +	if (!mddev->has_superblocks)
> +		return true;
>  	wait_event(mddev->sb_wait,
>  		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>  		   mddev->suspended);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 58cd20a5e85e..fbc925cce810 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -468,6 +468,8 @@ struct mddev {
>  	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>  	struct md_cluster_info		*cluster_info;
>  	unsigned int			good_device_nr;	/* good device num within cluster raid */
> +
> +	bool	has_superblocks:1;
>  };
>  
>  enum recovery_flags {
> -- 
> 2.14.3
> 
