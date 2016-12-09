From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: add .skip_kpartx and
 .max_sectors_kb to template in hwtable
Date: Fri, 9 Dec 2016 10:03:09 -0600
Message-ID: <20161209160309.GD25309@octiron.msp.redhat.com>
References: <20161208214500.14514-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161208214500.14514-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ACK

Thanks
-Ben

On Thu, Dec 08, 2016 at 10:45:00PM +0100, Xose Vazquez Perez wrote:
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c6fc3d1..f5a5f7b 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1115,6 +1115,8 @@ static struct hwentry default_hw[] = {
>  		.deferred_remove = DEFERRED_REMOVE_OFF,
>  		.delay_watch_checks = DELAY_CHECKS_OFF,
>  		.delay_wait_checks = DELAY_CHECKS_OFF,
> +		.skip_kpartx = SKIP_KPARTX_OFF,
> +		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
>  	},
>  #endif
>  	/*
> -- 
> 2.11.0
