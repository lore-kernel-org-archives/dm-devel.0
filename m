From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 7/7] fix udev rules for failed multipath
	devices
Date: Mon, 13 Feb 2017 16:46:07 +0100
Message-ID: <24b735ac-9f74-3319-08ac-c28cc1d1f221@redhat.com>
References: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
	<1486790932-30917-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1486790932-30917-8-git-send-email-bmarzins@redhat.com>
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

On 02/11/2017 06:28 AM, Benjamin Marzinski wrote:
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 5559af3..b253433 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -2,39 +2,66 @@ ACTION!="add|change", GOTO="mpath_end"
>  ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  
> +IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
> +IMPORT{db}="MPATH_DEVICE_READY"
> +
> +# If this uevent didn't come from dm, don't try to update the
> +# device state
> +ENV{DM_ACTIVATION}!="1", DM_ACTION!="?*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
> +

...

> +# This event is either a PATH_REINSTATED or a table reload where
> +# there are active paths. Mark the device ready
> +ENV{MPATH_DEVICE_READY}=""
> +

If we're doing coldplug (the "udevadm trigger --action=add" or "echo add
> /sys/block/<devname>/uevent"), I think this will drop any existing
MPATH_DEVICE_READY="0" here. Thing is that the ENV{DM_ACTIVATION}="1" is
also set for the coldplug case which generates spurious events, not only
for uevents coming from DM directly.

What we can do though is that we can check for DM_COOKIE and
DM_ACTION="PATH_*" variable existence in which case the uevent surely
comes from DM/mpath driver directly from kernel, so we can rule out the
coldplug case with spurious events.

-- 
Peter
