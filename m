From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 2/2]] multipath-tools: inform that regex
 can be used in vendor, product, .revision and bl_product
Date: Sat, 6 Aug 2016 01:23:16 +0200
Message-ID: <e32c64d6-e36b-8e83-dff1-244425d4f25d@gmail.com>
References: <1470332641-11282-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470332641-11282-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/04/2016 07:44 PM, Xose Vazquez Perez wrote:

Please, DROP also this one(v2). Thanks.
v3 is coming.

> Right now they are too wide regex, for example: "HITACHI"/"DF" or "SGI"/"IS".
> It should be used more extensively, at least, in product-ID.
> As I did in 34e345e8
> 
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 6180751..797ea45 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -868,6 +868,7 @@ static struct hwentry default_hw[] = {
>  	 * Keep only mandatory and modified attributes.
>  	 * Attributes with default values must be removed.
>  	 * .vendor and .product are mandatory, all other are optional.
> +	 * POSIX regex can be used in .vendor, .product, .revision and .bl_product
>  	 *
>  	 * COMPANY_NAME
>  	 *
> 
