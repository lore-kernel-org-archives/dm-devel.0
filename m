From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] Update ETERNUS DX entry
Date: Fri, 13 Mar 2015 15:11:53 +0100
Message-ID: <20150313151153.00001b2a@localhost>
References: <44563972.MCcuCWMjxF@tabasco>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44563972.MCcuCWMjxF@tabasco>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Wilck, Martin" <Martin.Wilck@ts.fujitsu.com>, Gerhard.Wichert@ts.fujitsu.com, "Montag,
	Rainer" <Rainer.Montag@ts.fujitsu.com>
List-Id: dm-devel.ids

Gerhard Wichert wrote:
> Add DX8700 S3 and DX8900 S3
> 
> Signed-off-by: Gerhard Wichert <gerhard.wichert@ts.fujitsu.com>
> ---
>  libmultipath/hwtable.c  | 2 +-
>  multipath.conf.defaults | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index bf2c2ca..6de915b 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {
>         },
>         {
>                 .vendor        = "FUJITSU",
> -               .product       = "ETERNUS_DX(L|M|400|8000)",
> +               .product       = "ETERNUS_DX(H|L|M|400|8000)",
>                 .features      = "1 queue_if_no_path",
>                 .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index cf8cfdb..c5f12e8 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -285,7 +285,7 @@
>  #      }
>  #      device {
>  #              vendor "FUJITSU"
> -#              product "ETERNUS_DX(L|M|400|8000)"
> +#              product "ETERNUS_DX(H|L|M|400|8000)"
>  #              path_grouping_policy "group_by_prio"
>  #              path_checker "tur"
>  #              features "1 queue_if_no_path"
> 

Can we keep the product list sorted (entry, mid-range, high-end)?
Like "ETERNUS_DX(L|M|400|H|8000)" or "ETERNUS_DX(L|400|M|8000|H)".

Sebastian
