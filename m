From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/5] multipathd: fix version check for
 DM_DEV_ARM_POLL ioctl
Date: Fri, 21 Sep 2018 17:52:35 -0500
Message-ID: <20180921225235.GO3172@octiron.msp.redhat.com>
References: <20180914125103.1154-1-mwilck@suse.com>
	<20180914125103.1154-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180914125103.1154-4-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 14, 2018 at 02:51:02PM +0200, Martin Wilck wrote:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Make sure the checks in dmevent_poll_supported() and
> arm_dm_event_poll() use the same logic. Currently, the
> version check check fails in arm_dm_event_poll() if
> libdevmapper's DM_VERSION is newer than the kernel's.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/dmevents.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> index e98a974c..31e64a7e 100644
> --- a/multipathd/dmevents.c
> +++ b/multipathd/dmevents.c
> @@ -50,16 +50,20 @@ struct dmevent_waiter {
>  };
>  
>  static struct dmevent_waiter *waiter;
> +/*
> + * DM_VERSION_MINOR hasn't been updated when DM_DEV_ARM_POLL
> + * was added in kernel 4.13. 4.37.0 (4.14) has it, safely.
> + */
> +static const unsigned int DM_VERSION_FOR_ARM_POLL[] = {4, 37, 0};
>  
>  int dmevent_poll_supported(void)
>  {
> -	unsigned int minv[3] = {4, 37, 0};
>  	unsigned int v[3];
>  
>  	if (dm_drv_version(v))
>  		return 0;
>  
> -	if (VERSION_GE(v, minv))
> +	if (VERSION_GE(v, DM_VERSION_FOR_ARM_POLL))
>  		return 1;
>  	return 0;
>  }
> @@ -120,9 +124,9 @@ static int arm_dm_event_poll(int fd)
>  {
>  	struct dm_ioctl dmi;
>  	memset(&dmi, 0, sizeof(dmi));
> -	dmi.version[0] = DM_VERSION_MAJOR;
> -	dmi.version[1] = DM_VERSION_MINOR;
> -	dmi.version[2] = DM_VERSION_PATCHLEVEL;
> +	dmi.version[0] = DM_VERSION_FOR_ARM_POLL[0];
> +	dmi.version[1] = DM_VERSION_FOR_ARM_POLL[1];
> +	dmi.version[2] = DM_VERSION_FOR_ARM_POLL[2];
>  	/* This flag currently does nothing. It simply exists to
>  	 * duplicate the behavior of libdevmapper */
>  	dmi.flags = 0x4;
> -- 
> 2.18.0
