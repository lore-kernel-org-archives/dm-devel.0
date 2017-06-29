From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH RESEND] dm-raid: Do not call BUG() in
 __rdev_sectors()
Date: Thu, 29 Jun 2017 16:09:38 +0200
Message-ID: <17f4e017-f3f8-01dd-d305-dae30f93ae06@redhat.com>
References: <1498637057-23221-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498637057-23221-1-git-send-email-hare@suse.de>
Content-Language: de-CH
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi Hannes,

thanks for your patch.

BUG() is intentional there to catch what I've already fixed with patch

"[dm-devel] [PATCH] dm raid: fix oops on upgrading to extended 
superblock format"

on 06/23/2017.

IOW: returning 0 is never right and would hide bugs like that one fixed.

Heinz


On 06/28/2017 10:04 AM, Hannes Reinecke wrote:
> __rdev_sectors() might be called for an invalid/non-existing
> RAID set during raid_ctr(), which is perfectly fine and no
> reason to panic.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/md/dm-raid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 7d89322..9bbb596 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1571,7 +1571,8 @@ static sector_t __rdev_sectors(struct raid_set *rs)
>   			return rdev->sectors;
>   	}
>   
> -	BUG(); /* Constructor ensures we got some. */
> +	/* No valid raid devices */
> +	return 0;
>   }
>   
>   /* Calculate the sectors per device and per array used for @rs */
