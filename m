From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 14/16] multipath.rules:
 find_multipaths+ignore_wwids logic
Date: Fri, 19 Jan 2018 12:12:19 -0600
Message-ID: <20180119181219.GD5638@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-15-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180119002916.10323-15-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 01:29:14AM +0100, Martin Wilck wrote:
> Solve the problem that, when the first path to a device appears,
> we don't know if more paths are going to follow.
> 
> These rules apply only if both find_multipaths and ignore_wwids are
> set in multipath.conf.
> 
> multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if a device is "maybe"
> a multipath member (not blacklisted, only one path seen).
> In that case, pretend to be a multipath member and disallow further
> processing by systemd (allowing multipathd some time to grab the path),
> and check again after some time. If the path is still not multipathed by then,
> pass it on to systemd for further processing. Ensure that this happens only
> once. The timeout values FIND_MULTIPATHS_BOOT_TMO (time to wait since system
> boot) and FIND_MULTIPATHS_PATH_TMO (time to wait after detection of first
> path) can be configured in udev rules that are run before "multipath.rules".
> The earlier timeout wins, thus if the first path is detected after
> FIND_MULTIPATHS_BOOT_TMO has expired, the timer will expire immediately.

RedHat defaults to using find_multipaths. Most customers have some local
non-multipathed storage.  As far as I can see, this change is adding at
least 30 seconds to the boot time or every boot in our standard case, to
solve a problem that is either in your Nice-to-Have category, or is as
far as I know, only theoretical, and also which can be fixed by simply
mounting a filesystem, albeit from an emergency shell.  RedHat has been
defaulting to find_multipaths since not long after I first posted it
(which is long before it finally got accepted upstream), and like I
said, I've never receieved a bug report for that issue with new storage
causing boot to fail. I admit, new storage being not multipathed has
happened (when there is existing LVM/MD metadata on it), and cleaning
that up does involve adding the wwid, which isn't obvious, which is why
i made a multipath command to make it as simple as possible. But the
only bug I've ever received for this has been from the RedHat system
installer, where you are adding a lot of new storage all at once, and
it's very likely to have old LVM/MD metadata on it.

I would personally be much happier if you just added the "-i" to the
upstream rules, and RedHat just reverted some commits on our own. 30
seconds feels too long to wait on every boot in the (for us) standard
case, and making the timeout short enough to not be bothersome doesn't
(or didn't when I tried something similar, when I first wrote
find_multipaths) work when there were a large number of devices being
discovered at boot.  And if the timeout is too short, you end up in the
same situation that the current RedHat setup has, with one important
difference. Multipathd is now much more likely to win the race, and
multipath a device that it has not claimed, which is the only way you
can get into the more serious boot issue I described before.

IMHO a better way to avoid this would be to give multipathd a
configurable timeout to wait before creating a multipath device on new
storage if find_multipaths is set, it order to give you the same sort of
guarantee that the race will go one way. I realize that if there is
existing metadata on the device or a fstab entry for it, this would make
the new device always be incorrectly not multipathed, but it has the
benefit of not slowing boot and reducing the chance of the worst
outcome, regardless of how long the timeout is. It would essentially be
like keeping the guarantees of your original "imply -n" patch, but with
the benefit that if nothing else wanted to assemble on the device,
multipathd would eventually try and succeed, and then update the udev
database afterwards.

Thoughts?
-Ben

> ---
>  multipath/multipath.rules | 59 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> index 5b3c3c9c1135..6b4a418d0009 100644
> --- a/multipath/multipath.rules
> +++ b/multipath/multipath.rules
> @@ -19,9 +19,64 @@ LABEL="test_dev"
>  ENV{MPATH_SBIN_PATH}="/sbin"
>  TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
>  
> +# find_multipaths + ignore_wwids logic, part 1
> +#
> +# Recover environment on next uevent after waiting for the timer.
> +# This happens only once because DM_MULTIPATH_SAVED_FS_TYPE will be empty
> +# on subsequent events.
> +
> +IMPORT{db}="DM_MULTIPATH_WAIT_DONE"
> +IMPORT{db}="DM_MULTIPATH_SAVED_FS_TYPE"
> +ENV{DM_MULTIPATH_WAIT_DONE}!="1", GOTO="skip_restore"
> +ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="", GOTO="skip_restore"
> +
> +# Reset if it's our dummy value, see below
> +ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="dm_multipath_unkown", ENV{DM_MULTIPATH_SAVED_FS_TYPE}=""
> +ENV{ID_FS_TYPE}="$env{DM_MULTIPATH_SAVED_FS_TYPE}"
> +ENV{DM_MULTIPATH_SAVED_FS_TYPE}=""
> +ENV{DM_MULTIPATH_DEVICE_PATH}=""
> +ENV{SYSTEMD_READY}=""
> +
> +# Special case:
> +# An "add" event happened while we were waiting for the timer.
> +# This happens during "coldplug" after switching root FS, if a timer
> +# started during initramfs processing was interrupted. We may not have
> +# waited long enough: try again.
> +ACTION=="add", ENV{DM_MULTIPATH_WAIT_DONE}=""
> +
> +LABEL="skip_restore"
> +
>  # multipath -u sets DM_MULTIPATH_DEVICE_PATH
> -ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT="$env{MPATH_SBIN_PATH}/multipath -u %k"
> +ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
>  ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
> -	ENV{SYSTEMD_READY}="0"
> +	ENV{SYSTEMD_READY}="0", GOTO="end_mpath"
> +
> +# find_multipaths + ignore_wwids logic, part 2
> +#
> +# multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if a device is "maybe"
> +# a multipath member (not blacklisted, only one path seen).
> +# In that case, pretend to be a multipath member (allowing multipathd
> +# some time to grab the path), and check again after some time.
> +# If the path is still not multipathed by then, pass it on to systemd
> +# for further processing.
> +# DM_MULTIPATH_WAIT_DONE ensures that this happens only once.
> +# (But see "special case" exception above).
> +
> +ENV{DM_MULTIPATH_WAIT_DONE}=="1", GOTO="end_mpath"
> +ENV{DM_MULTIPATH_DEVICE_PATH}!="2", GOTO="end_mpath"
> +
> +# Default timeout values for the timer. Use early udev rules files to customize.
> +# Timeouts are in seconds after system boot, and seconds after first path
> +# discovery, respectively. The earlier timeout wins.
> +ENV{FIND_MULTIPATHS_BOOT_TMO}!="?*", ENV{FIND_MULTIPATHS_BOOT_TMO}="180"
> +ENV{FIND_MULTIPATHS_PATH_TMO}!="?*", ENV{FIND_MULTIPATHS_PATH_TMO}="30"
> +
> +ENV{DM_MULTIPATH_WAIT_DONE}="1"
> +ENV{DM_MULTIPATH_SAVED_FS_TYPE}="$env{ID_FS_TYPE}"
> +ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="", ENV{DM_MULTIPATH_SAVED_FS_TYPE}="dm_multipath_unkown"
> +ENV{ID_FS_TYPE}="maybe_mpath_member"
> +ENV{DM_MULTIPATH_DEVICE_PATH}="1"
> +ENV{SYSTEMD_READY}="0"
> +RUN+="/usr/bin/systemd-run --action change --on-boot $env{FIND_MULTIPATHS_BOOT_TMO} --on-active $env{FIND_MULTIPATHS_PATH_TMO} /usr/bin/udevadm trigger $sys$devpath"
>  
>  LABEL="end_mpath"
> -- 
> 2.15.1
