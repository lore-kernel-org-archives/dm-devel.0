From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2] multipath-tools: Add Dell SC name and
	maintainer
Date: Tue, 16 Aug 2016 16:09:18 +0200
Message-ID: <9f70088f-f9f1-f3c3-1334-2a8abc1ae1dc@gmail.com>
References: <1471353703993.24933@DELL.com>
	<8b816ec6-a84d-9804-d5a4-e8d5aab32ec6@gmail.com>
	<11d65170cc0845f08c67a765f6086463@AUSX13MPC103.AMER.DELL.COM>
	<e35a8bd8-2c1b-410b-f6ea-50d0206d6d2a@gmail.com>
	<62813472-e66b-587f-feea-6e4791b06918@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62813472-e66b-587f-feea-6e4791b06918@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sean_McGinnis@DELL.com, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/16/2016 04:00 PM, Xose Vazquez Perez wrote:


drop v2. Thank you.

> from: Sean McGinnis <sean_mcginnis@dell.com>
> 
> Compellent Storage Center is now Dell SC Series storage. Added
> contact name for maintenance.
> 
> Signed-off-by: Sean McGinnis <sean_mcginnis@dell.com>
> ---
>  libmultipath/hwtable.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1bc6f2c..a76fbfc 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -211,6 +211,12 @@ static struct hwentry default_hw[] = {
>  	 * DELL
>  	 */
>  	{
> +                /*
> +                 * Dell SC Series, formerly Compellent
> +                 *
> +                 * Maintainer : Sean McGinnis
> +                 * Mail: sean_mcginnis@dell.com
> +                 */
>  		.vendor        = "COMPELNT",
>  		.product       = "Compellent Vol",
>  		.pgpolicy      = MULTIBUS,
> 
