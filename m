From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] multipath-tools: add FUJITSU/ETERNUS
 2000/4000/8000 to hwtable
Date: Sat, 8 Oct 2016 22:30:49 +0200
Message-ID: <20161008223049.00006901@gmx.de>
References: <20161005211252.9761-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161005211252.9761-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Vazquez Perez wrote:
> Based on documentation provided by the manufacturer:
> http://storage-system.fujitsu.com/global/manual/diskarray/pdf/p3am-3192-en.pdf
> 
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index e1ed7ef..367aa0a 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -268,6 +268,14 @@ static struct hwentry default_hw[] = {
>  		.product       = "FC2502",
>  		.pgpolicy      = MULTIBUS,
>  	},
> +	{
> +		.vendor        = "FUJITSU",
> +		.product       = "E[248]000",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.no_path_retry = 10,
> +		.prio_name     = PRIO_ALUA,
> +	},
>  	/*
>  	 * Hitachi
>  	 *

Now that you dropped the path selector as suggested back in July [1]
why not merge this with the ETERNUS DX entry?

[1] https://www.redhat.com/archives/dm-devel/2016-July/msg00595.html

Sebastian
