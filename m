From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 1/8] dm thin: synchronize
 the pool mode during suspend
Date: Fri, 21 Feb 2014 13:58:12 +0000
Message-ID: <20140221135811.GB13298@debian>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1392951365-9829-2-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

ACK

On Thu, Feb 20, 2014 at 09:55:58PM -0500, Mike Snitzer wrote:
> Commit b5330655 ("dm thin: handle metadata failures more consistently")
> increased potential for the pool's mode to be changed in response to
> metadata operation failures.
> 
> When the pool mode is changed it isn't synchronized with the mode in
> pool_features stored in the target's context (ti->private) that is used
> as the basis for (re)establishing the pool mode during resume via
> bind_control_target.
> 
> It is important that we synchronize the pool mode when suspending
> otherwise the pool may experience and unexpected mode transition on the
> next resume (especially if there was no new table load).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-thin.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index d501e43..9facc6f 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -2364,6 +2364,12 @@ static void pool_postsuspend(struct dm_target *ti)
>  	cancel_delayed_work(&pool->waker);
>  	flush_workqueue(pool->wq);
>  	(void) commit(pool);
> +
> +	/*
> +	 * The pool mode may have changed, sync it so bind_control_target()
> +	 * doesn't cause an unexpected mode transition on resume.
> +	 */
> +	pt->adjusted_pf.mode = get_pool_mode(pool);
>  }
>  
>  static int check_arg_count(unsigned argc, unsigned args_required)
> -- 
> 1.8.3.1
> 
