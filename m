From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 06/13] Add Datacore SANSymphony to hwtable
Date: Wed, 16 Jan 2013 21:53:34 +0100
Message-ID: <1358369614.8351.9.camel@lapoo.opensvc.com>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
	<1358338456-1234-7-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-7-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mer., 2013-01-16 at 13:14 +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/hwtable.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
This configlet is for SANmelody, and the commit subject is
about SANsymphony.

I don't mind the subject being eroneous, but i'd like to be sure the
configlet is correct.

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 174df7e..9ed3a82 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1075,6 +1075,19 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.prio_args     = NULL,
>  	},
> +	{
> +		.vendor	       = "DataCore",
> +		.product       = "SANmelody",
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = NO_PATH_RETRY_QUEUE,
> +		.checker_name  = TUR,
> +		.prio_name     = PRIO_ALUA,
> +		.prio_args     = NULL,
> +	},
>  	/*
>  	 * EOL
>  	 */
