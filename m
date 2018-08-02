From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thin: stop no_space_timeout worker before switch
	to write-mode
Date: Thu, 2 Aug 2018 14:38:00 -0400
Message-ID: <20180802183800.GA30480@redhat.com>
References: <20180802081824.1398-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180802081824.1398-1-houtao1@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hou Tao <houtao1@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 02 2018 at  4:18am -0400,
Hou Tao <houtao1@huawei.com> wrote:

> Now both check_for_space() and do_no_space_timeout() will read & write
> error_if_no_space in pool->pf. If these functions run concurrently as
> shown in the following case, the error_if_no_space feature requested
> by user may get lost.
> 
> precondition:
>     * error_if_no_space = 0
>     * Out-of-Data-Space occurs
>     * no_space_timeout worker has been queued
> 
> CPU 0:                          CPU 1:
> // delete a thin device
> process_delete_mesg()
> // inovked by commit()
> set_pool_mode(pool, PM_WRITE)
>     pool->pf.error_if_no_space = \
>      pt->requested_pf.error_if_no_space
> 
> 				// timeout
> 				do_no_space_timeout
> 				    // the user configuration is lost
> 				    pool->pf.error_if_no_space = true
>     pool->pf.mode = new_mode
> 
> Fix it by stopping no_space_timeout worker before switching to write mode.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/md/dm-thin.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index b900723bbd0f..c6da4afc16cf 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1401,6 +1401,7 @@ static void check_for_space(struct pool *pool)
>  		return;
>  
>  	if (nr_free) {
> +		cancel_delayed_work_sync(&pool->no_space_timeout);
>  		set_pool_mode(pool, PM_WRITE);
>  		requeue_bios(pool);
>  	}
> -- 
> 2.16.2.dirty
> 

Thanks for the patch, I tweaked the header a bit and also moved the
cancel_delayed_work_sync() to set_pool_mode(), please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=eff8f4c73dd13f7d53015fc911d66f6671dd82b8

Please let me know if you have any issues with this, otherwise it is
staged for 4.19 inclussion.

Thanks,
Mike
