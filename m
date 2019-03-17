From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 01/12] libmultipath: disable
 user_friendly_names for NetApp
Date: Sun, 17 Mar 2019 16:04:20 +0100
Message-ID: <f0ff0f72-e1f8-4b24-308b-7ba044b37a09@gmail.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-2-git-send-email-bmarzins@redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 3/9/19 12:11 AM, Benjamin Marzinski wrote:

> NetApp has tools that rely on devices using WWID names. To avoid
> breaking these, NetApp devices should continue to use WWID names, even
> if the default config is set to enable user_friendly_names. If users
> want to use user_friendly_names on NetApp devices, the must specifically
> override the device config.
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index d3a8d9b..8776411 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -719,6 +719,7 @@ static struct hwentry default_hw[] = {
>  		.flush_on_last_del = FLUSH_ENABLED,
>  		.dev_loss      = MAX_DEV_LOSS_TMO,
>  		.prio_name     = PRIO_ONTAP,
                /* WWID names needed by NetApp tool ... */
> +		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
>  	},
>  	{
>  		/*
> 

A minimal explanation should be added for a quick reference.
