From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 21/31] 11-dm-mpath.rules: Remember
	DM_ACTIVATION
Date: Wed, 13 Sep 2017 16:19:42 -0500
Message-ID: <20170913211942.GN3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-22-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170902223900.7339-22-mwilck@suse.com>
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

On Sun, Sep 03, 2017 at 12:38:50AM +0200, Martin Wilck wrote:
> If DM_ACTIVATION is set by the general dm rules, we need to
> bring up this device. But if the mpath device is not ready,
> that would be dangerous; it could hang or produce lots of IO
> errors. So remember this state, and try to activate when the
> map becomes usable later.

NAK. See reasons in

[PATCH 20/31] 11-dm-mpath.rules: don't set READY->ACTIVATION

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 3f47744f..9bfd75f8 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -4,6 +4,7 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  
>  IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
>  IMPORT{db}="MPATH_DEVICE_READY"
> +IMPORT{db}="MPATH_NEEDS_ACTIVATION"
>  
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> @@ -55,6 +56,13 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_ACTIVATION}="0"
>  # We'd like to avoid this, especially within udev processing.
>  ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
>  
> +# If DM_ACTIVATION is set, but can't be satisfied, remember it
> +# in MPATH_NEEDS_ACTIVATION, and activate at the next opportunity.
> +ENV{MPATH_DEVICE_READY}=="0", ENV{DM_ACTIVATION}=="1", \
> +	ENV{MPATH_NEEDS_ACTIVATION}="1", ENV{DM_ACTIVATION}="0"
> +ENV{MPATH_DEVICE_READY}!="0", ENV{MPATH_NEEDS_ACTIVATION}=="1", \
> +	ENV{DM_ACTIVATION}="1", ENV{MPATH_NEEDS_ACTIVATION}=""
> +
>  # Also skip all foreign rules if no path is available.
>  # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
>  # and restore it back once we have at least one path available.
> -- 
> 2.14.0
