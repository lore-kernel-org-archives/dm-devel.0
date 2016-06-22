From: Martin George <marting@netapp.com>
Subject: Re: [PATCH] multipath-tools: unreachable controllers
	maintainers
Date: Wed, 22 Jun 2016 08:08:07 +0530
Message-ID: <5769FA0F.9030307@netapp.com>
References: <1465156471-20249-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/6/2016 1:24 AM, Xose Vazquez Perez wrote:
> Replace 3 unreachable controllers maintainers, their emails are bounced,
> with the default maintainer(Christophe Varoqui <christophe.varoqui@opensvc.com>)
>
> @@ -790,8 +790,8 @@ static struct hwentry default_hw[] = {
>   	/*
>   	 * NETAPP controller family
>   	 *
> -	 * Maintainer : Dave Wysochanski
> -	 * Mail : davidw@netapp.com
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
>   	 */
>   	{
>   		.vendor        = "NETAPP",
> @@ -835,8 +835,8 @@ static struct hwentry default_hw[] = {
>   	/*
>   	 * IBM NSeries (NETAPP) controller family
>   	 *
> -	 * Maintainer : Dave Wysochanski
> -	 * Mail : davidw@netapp.com
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
>   	 */
>   	{
>   		.vendor        = "IBM",
>

I can take up the maintainer's role here for the NetApp controller 
family. Please let me know if this mail suffices, or whether you need me 
to send a separate patch for this.

Thanks,
-Martin George (marting@netapp.com)
