From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 4/4] multipathd: don't resend change events
 for unknown devices
Date: Fri, 08 Feb 2019 10:21:34 +0100
Message-ID: <7c8a523cc53a51685dd4e6592e637f507644a385.camel@suse.de>
References: <20190207235302.21635-1-bmarzins@redhat.com>
	<20190207235302.21635-5-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190207235302.21635-5-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2019-02-07 at 17:53 -0600, Benjamin Marzinski wrote:
> If multipath fails to get the wwid for a device, and the device is
> of an unknown type (pp->bus == SYSFS_BUS_UNDEF), don't send change
> events. Instead, assume that the device was not meant to be used
> and skip it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  libmultipath/discovery.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 6aef188..10bd8cd 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1966,6 +1966,8 @@ int pathinfo(struct path *pp, struct config
> *conf, int mask)
>  	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
>  		get_uid(pp, path_state, pp->udev);
>  		if (!strlen(pp->wwid)) {
> +			if (pp->bus == SYSFS_BUS_UNDEF)
> +				return PATHINFO_SKIPPED;
>  			if (pp->initialized != INIT_FAILED) {
>  				pp->initialized = INIT_MISSING_UDEV;
>  				pp->tick = conf->retrigger_delay;
