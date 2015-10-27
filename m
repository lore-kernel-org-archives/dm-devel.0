From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 5/6] dm-switch: Remove unnecessary condition
 in conditional
Date: Tue, 27 Oct 2015 19:03:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510271840420.4649@file01.intranet.prod.int.rdu2.redhat.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
	<1445974740-8362-5-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1445974740-8362-5-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids



On Wed, 28 Oct 2015, Tomohiro Kusumi wrote:

> It's always (sctx->nr_regions == nr_regions) considering
> the assignment right before this conditional, and this
> function is only used by .ctr.

The variable sctx->nr_regions has type unsigned long and the variable 
nr_regions has type sector_t.

Thus the variables may be different when overflow happens.

It could be changed to "if (nr_regions >= ULONG_MAX)".

Mikulas

> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> ---
>  drivers/md/dm-switch.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> index 50fca46..372ec34 100644
> --- a/drivers/md/dm-switch.c
> +++ b/drivers/md/dm-switch.c
> @@ -100,7 +100,7 @@ static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
>  		nr_regions++;
>  
>  	sctx->nr_regions = nr_regions;
> -	if (sctx->nr_regions != nr_regions || sctx->nr_regions >= ULONG_MAX) {
> +	if (sctx->nr_regions >= ULONG_MAX) {
>  		ti->error = "Region table too large";
>  		return -EINVAL;
>  	}
> -- 
> 1.7.1
> 
