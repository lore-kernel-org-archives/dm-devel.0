From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] libmultipath: update 3PARdata builtin config
Date: Wed, 28 Jun 2017 19:48:38 +0200
Message-ID: <5d7143cd-4964-93ca-1e71-0119eb2a8ea1@gmail.com>
References: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 06/26/2017 09:03 PM, Benjamin Marzinski wrote:

> This updated config comes from hp.

It would be nice to have more information.
Why and when is this needed?


BTW: HPE 'MSA 205x' and 'StoreVirtual 3200'(LeftHand) are missing.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 390d143..54bdcfc 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -49,6 +49,8 @@ static struct hwentry default_hw[] = {
>  		.hwhandler     = "1 alua",
>  		.prio_name     = PRIO_ALUA,
>  		.no_path_retry = 18,
> +		.fast_io_fail  = 10,
> +		.dev_loss      = MAX_DEV_LOSS_TMO,
>  	},
>  	{
>  		/* RA8000 / ESA12000 */
>
