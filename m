From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] Update ETERNUS DX entry
Date: Wed, 27 Aug 2014 23:32:40 +0200
Message-ID: <20140827233240.000073e1@localhost>
References: <20140630233858.00001ed0@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140630233858.00001ed0@localhost>
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
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

I wrote:
> Add DX500 S3/DX600 S3.
> 
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> ---
>  libmultipath/hwtable.c  | 2 +-
>  multipath.conf.defaults | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index bb73a40..b774453 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {
>  	},
>  	{
>  		.vendor        = "FUJITSU",
> -		.product       = "ETERNUS_DX(L|400|8000)",
> +		.product       = "ETERNUS_DX(L|M|400|8000)",
>  		.features      = "1 queue_if_no_path",
>  		.hwhandler     = DEFAULT_HWHANDLER,
>  		.pgpolicy      = GROUP_BY_PRIO,
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index 12fb3f0..654be97 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -285,7 +285,7 @@
>  #	}
>  #	device {
>  #		vendor "FUJITSU"
> -#		product "ETERNUS_DX(L|400|8000)"
> +#		product "ETERNUS_DX(L|M|400|8000)"
>  #		path_grouping_policy "group_by_prio"
>  #		path_checker "tur"
>  #		features "1 queue_if_no_path"

Christophe, can you apply this?

Sebastian
