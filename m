From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 20/31] 11-dm-mpath.rules: don't set
	READY->ACTIVATION
Date: Wed, 13 Sep 2017 16:19:06 -0500
Message-ID: <20170913211906.GM3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-21-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170902223900.7339-21-mwilck@suse.com>
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

On Sun, Sep 03, 2017 at 12:38:49AM +0200, Martin Wilck wrote:
> The fact alone that a map changes from not ready to ready does
> not imply that it is activating.

NAK on this one and
[PATCH 21/31] 11-dm-mpath.rules: Remember DM_ACTIVATION

This breaks things. It's often the case that there are devices stacked
on top of multipath.  When multipath loses all of its paths, if it
doesn't have queue_if_no_path set, it can fail IO up to these higher
devices, forcing them to react to the failure.  There is no way that I
know of to be able to check in udev to see if this has occured. The only
safe course of action is to assume the worst and notify lvm that things
are better now.

A simple reproducer of the problem is something like:

- create 2 multipath devices (call them mpatha and mpathb)
- set up raid1 on top of them

# pvcreate /dev/mapper/mpatha
# pvcreate /dev/mapper/mpathc
# vgcreate test /dev/mapper/mpathb /dev/mapper/mpatha
# lvcreate --type raid1 -m 1 -L 1G -n raid test

- verify that everything is o.k.

# dd if=/dev/zero of=/dev/test/raid bs=1M count=100
# multipath -ll
# pvs
# vgs
# lvs

- remove all of the path devices from mpatha
- verify that the raid device is in partial mode

# dd if=/dev/zero of=/dev/test/raid bs=1M count=100 
# multipath -ll
# pvs
# vgs
# lvs

- add the path devices back to the system
- check if the raid device has recovered

# multipath -ll
# pvs
# vgs
# lvs

With these patches, the raid device remains in partial mode, and the
mpatha pv is still listed as unknown. If I revert these two patches,
everything works fine again.

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 0be22ae4..3f47744f 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -64,8 +64,7 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1",\
>  ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
>  ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
> -	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
> -	ENV{DM_ACTIVATION}="1"
> +	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=""
>  
>  LABEL="scan_import"
>  ENV{DM_NOSCAN}!="1", GOTO="mpath_end"
> -- 
> 2.14.0
