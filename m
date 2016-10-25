From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add support all STK
 OPENstorage rdac arrays
Date: Tue, 25 Oct 2016 15:04:20 +0200
Message-ID: <47f0f38b-2ed7-72d5-7ea0-396d3af9f3e2@gmail.com>
References: <20161025125706.4131-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161025125706.4131-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/25/2016 02:57 PM, Xose Vazquez Perez wrote:

> 9176, D173, D178, D210, D220, D240 and D280.

Please, drop this one. v2 with comments.
Thank you.

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1aa9ec3..b56d2bc 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -726,7 +726,7 @@ static struct hwentry default_hw[] = {
>  		/* Sun - StorageTek */
>  	{
>  		.vendor        = "STK",
> -		.product       = "OPENstorage D280",
> +		.product       = "OPENstorage",
>  		.bl_product    = "Universal Xport",
>  		.pgpolicy      = GROUP_BY_PRIO,
>  		.checker_name  = RDAC,
> 
