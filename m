From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: md.c: fix oops in mddev_suspend for raid0
Date: Mon, 9 May 2016 12:08:49 -0400
Message-ID: <20160509160849.GB22736@redhat.com>
References: <1462809042-2974-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462809042-2974-1-git-send-email-heinzm@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com
Cc: dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 09 2016 at 11:50am -0400,
heinzm@redhat.com <heinzm@redhat.com> wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> Introduced by upstream commit 70d9798b95562abac005d4ba71d28820f9a201eb
> 
> The raid0 personality does not create mddev->thread as oposed to
> other personalities leading to its unconditional access in
> mddev_suspend() causing an oops.
> 
> Patch checks for mddev->thread in order to keep the
> intention of aforementioned commit.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

Seems this should be marked with:

Fixes: 70d9798b9556 ("MD: warn for potential deadlock")
Cc: stable@vger.kernel.org # 4.5+

> 
> 
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 194580f..d91920d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -305,7 +305,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>   */
>  void mddev_suspend(struct mddev *mddev)
>  {
> -	WARN_ON_ONCE(current == mddev->thread->tsk);
> +	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
>  	if (mddev->suspended++)
>  		return;
>  	synchronize_rcu();
> -- 
> 2.5.5
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
