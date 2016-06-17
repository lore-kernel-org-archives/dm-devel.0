From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: unreachable controllers
	maintainers
Date: Fri, 17 Jun 2016 12:32:55 +0200
Message-ID: <7731a278-4876-049d-3454-42f6bbb673f9@gmail.com>
References: <1465156471-20249-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465156471-20249-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: matthias.rudolph@hds.com, sramani@pillardata.com, yacine@alyseo.com, g.shyamsundar@yahoo.co.in, device-mapper development <dm-devel@redhat.com>, sean.stewart@netapp.com, brking@linux.vnet.ibm.com, bartb@pivot3.com, egoggin@emc.com
List-Id: dm-devel.ids

On 06/05/2016 09:54 PM, Xose Vazquez Perez wrote:
> Replace 3 unreachable controllers maintainers, their emails are bounced,
> with the default maintainer(Christophe Varoqui <christophe.varoqui@opensvc.com>)

Please DROP this patch.

> Compellent Technologies, Inc.: Jim Lester <jim.lester@compellent.com>
> NETAPP controller family: Dave Wysochanski <davidw@netapp.com>
> IBM NSeries (NETAPP) controller family: Dave Wysochanski <davidw@netapp.com>
> 
> 
> Cc: bartb@pivot3.com
> Cc: brking@linux.vnet.ibm.com
> Cc: egoggin@emc.com
> Cc: g.shyamsundar@yahoo.co.in
> Cc: matthias.rudolph@hds.com
> Cc: sean.stewart@netapp.com
> Cc: sramani@pillardata.com
> Cc: yacine@alyseo.com
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> 
> ---
> 
> If anyone in the Cc: list is not currently in charge of a listed controller
> at hwtable.c, please drop here an email, thanks.
> Ideally, an impersonal address is desired, e.g.: linux-mpt@mycompany.com
> 
> ---
>  libmultipath/hwtable.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 66b5123..5c49e32 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -20,8 +20,8 @@ static struct hwentry default_hw[] = {
>  	/*
>  	 * Compellent Technologies, Inc.
>  	 *
> -	 * Maintainer : Jim Lester, Compellent
> -	 * Mail : jim.lester@compellent.com
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
>  	 */
>  	{
>  		.vendor        = "COMPELNT",
> @@ -790,8 +790,8 @@ static struct hwentry default_hw[] = {
>  	/*
>  	 * NETAPP controller family
>  	 *
> -	 * Maintainer : Dave Wysochanski
> -	 * Mail : davidw@netapp.com
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
>  	 */
>  	{
>  		.vendor        = "NETAPP",
> @@ -835,8 +835,8 @@ static struct hwentry default_hw[] = {
>  	/*
>  	 * IBM NSeries (NETAPP) controller family
>  	 *
> -	 * Maintainer : Dave Wysochanski
> -	 * Mail : davidw@netapp.com
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
>  	 */
>  	{
>  		.vendor        = "IBM",
> 
