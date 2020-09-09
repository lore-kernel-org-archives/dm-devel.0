From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipath-tools: add HPE MSA 1060/2060 to
	hwtable
Date: Wed, 09 Sep 2020 21:24:04 +0200
Message-ID: <070b155d8d8d1b27c8c7be64c03b64d5b5c5e70d.camel@suse.com>
References: <20200909154805.8210-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200909154805.8210-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-09-09 at 17:48 +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

I'm assuming you have this information from reliable sources. So:

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index d1fcfdb3..55162e0e 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -181,9 +181,9 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  	},
>  	{
> -		/* MSA 1040, 1050, 2040 and 2050 families */
> +		/* MSA 1040, 1050, 1060, 2040, 2050 and 2060 families
> */
>  		.vendor        = "HP",
> -		.product       = "MSA [12]0[45]0 SA[NS]",
> +		.product       = "MSA [12]0[456]0 SA[NS]",
>  		.pgpolicy      = GROUP_BY_PRIO,
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  		.no_path_retry = 18,
