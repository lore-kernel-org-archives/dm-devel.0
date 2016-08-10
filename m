From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 02/15] multipath-tools: remove
 pgpolicy=FAILOVER from Ceph/RBD
Date: Wed, 10 Aug 2016 11:51:16 -0500
Message-ID: <57AB5B84.5040002@redhat.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
	<1470846038-6590-2-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-2-git-send-email-xose.vazquez@gmail.com>
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

On 08/10/2016 11:20 AM, Xose Vazquez Perez wrote:
> It's already the default pgpolicy.
> 
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1222f47..90c9b5b 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -826,7 +826,6 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "Ceph",
>  		.product       = "RBD",
> -		.pgpolicy      = FAILOVER,
>  		.no_path_retry = NO_PATH_RETRY_FAIL,
>  		.checker_name  = RBD,
>  		.deferred_remove = DEFERRED_REMOVE_ON,
> 

Thanks.

Reviewed-by: Mike Christie <mchristi@redhat.com>
