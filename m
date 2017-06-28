From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RESEND] dm-raid: Do not call BUG() in
	__rdev_sectors()
Date: Wed, 28 Jun 2017 13:18:39 -0400
Message-ID: <20170628171839.GA12783@redhat.com>
References: <1498637057-23221-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1498637057-23221-1-git-send-email-hare@suse.de>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 28 2017 at  4:04P -0400,
Hannes Reinecke <hare@suse.de> wrote:

> __rdev_sectors() might be called for an invalid/non-existing
> RAID set during raid_ctr(), which is perfectly fine and no
> reason to panic.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-raid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 7d89322..9bbb596 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1571,7 +1571,8 @@ static sector_t __rdev_sectors(struct raid_set *rs)
>  			return rdev->sectors;
>  	}
>  
> -	BUG(); /* Constructor ensures we got some. */
> +	/* No valid raid devices */
> +	return 0;
>  }
>  
>  /* Calculate the sectors per device and per array used for @rs */
> -- 
> 1.8.5.6
> 

The use of BUG() is certainly suspect.  BUG() is very rarely the right
answer.

But I don't think returning 0 makes sense for all __rdev_sectors()
callers, e.g.: rs_setup_recovery()

__rdev_sectors() could easily be made to check if ti->error is passed as
a non-NULL pointer.. if so set *error, return 0, have ctr check for 0,
and gracefully fail ctr by returning the ti->error that __rdev_sectors()
set.  If the error pointer passed to __rdev_sectors() is NULL, resort to
BUG() still?  Would really like to avoid BUG().. but I'll defer to Heinz
on what might be a better response.

Alternatively, you could look to see where "Constructor ensures we got
some." and fix the fact that it clearly isn't ensuring as much for your
case?

Mike
