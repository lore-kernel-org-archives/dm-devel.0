From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] dm cache: Avoid conflicting remove_mapping() in mq policy
Date: Fri, 16 Aug 2013 01:31:18 -0700
Message-ID: <520DE356.9060506@roeck-us.net>
References: <1374825451-30463-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hexagon-owner@vger.kernel.org>
In-Reply-To: <1374825451-30463-1-git-send-email-geert@linux-m68k.org>
Sender: linux-hexagon-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: dm-devel.ids

On 07/26/2013 12:57 AM, Geert Uytterhoeven wrote:
> On sparc32, which includes <linux/swap.h> from <asm/pgtable_32.h>:
>
> drivers/md/dm-cache-policy-mq.c:962:13: error: conflicting types for 'remove_mapping'
> include/linux/swap.h:285:12: note: previous declaration of 'remove_mapping' was here
>
> As mq_remove_mapping() already exists, and the local remove_mapping() is
> used only once, inline it manually to avoid the conflict.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Is this patch going anyhere ? The problem breaks the sparc32:allmodconfig build,
so it would be useful to get it fixed.

Thanks,
Guenter

> ---
> I think this is also needed on hexagon, which includes <linux/swap.h> from
> <asm/pgtable.h>.
>
>   drivers/md/dm-cache-policy-mq.c |   16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
> index dc112a7..4296155 100644
> --- a/drivers/md/dm-cache-policy-mq.c
> +++ b/drivers/md/dm-cache-policy-mq.c
> @@ -959,23 +959,21 @@ out:
>   	return r;
>   }
>
> -static void remove_mapping(struct mq_policy *mq, dm_oblock_t oblock)
> +static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
>   {
> -	struct entry *e = hash_lookup(mq, oblock);
> +	struct mq_policy *mq = to_mq_policy(p);
> +	struct entry *e;
> +
> +	mutex_lock(&mq->lock);
> +
> +	e = hash_lookup(mq, oblock);
>
>   	BUG_ON(!e || !e->in_cache);
>
>   	del(mq, e);
>   	e->in_cache = false;
>   	push(mq, e);
> -}
>
> -static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
> -{
> -	struct mq_policy *mq = to_mq_policy(p);
> -
> -	mutex_lock(&mq->lock);
> -	remove_mapping(mq, oblock);
>   	mutex_unlock(&mq->lock);
>   }
>
>
