From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath-tools: RH-patches for upstream ???
Date: Thu, 3 Oct 2019 16:44:20 -0500
Message-ID: <20191003214420.GE25414@octiron.msp.redhat.com>
References: <e2b955d0-69ea-2c2b-9f0f-ccf3b5f369d0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e2b955d0-69ea-2c2b-9f0f-ccf3b5f369d0@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Thu, Oct 03, 2019 at 08:28:06PM +0200, Xose Vazquez Perez wrote:
> Hi Benjamin,
> 
> 
> Is there any relevant RH-patch for upstream in fedora repo:
> https://src.fedoraproject.org/rpms/device-mapper-multipath/ ???
> 
> Maybe:
> 
> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0022-RH-Remove-the-property-blacklist-exception-builtin.patch
> 
>    Subject: [PATCH] RH: Remove the property blacklist exception builtin
> 
>     Multipath set the default property blacklist exceptions to	
>     (ID_SCSI_VPD|ID_WWN).  This has the effect of blacklisting some internal
>     devices.  These devices may never have multiple paths, but it is nice
>     to be able to set multipath up on them all the same.  This patch simply
>     removes the default, and makes it so that if no property
>     blacklist_exception is given, then devices aren't failed for not matching
>     it.

Redhat doesn't include the udev rules file that sets ID_SCSI_VPD, so
there are some rare cases where this property blacklists valid devices.
Thus, it's easier for us to simply include this property line in the
default multipath.conf, and let users remove it if necessary. I would be
fine with this being included upstream, but I suspect it would mess with
other ditsros which are currently assuming that it is there.

> 
> 
> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0026-RH-add-wwids-from-kernel-cmdline-mpath.wwids-with-A.patch
> 
>    Subject: [PATCH] RH: add wwids from kernel cmdline mpath.wwids with -A
> 
>     This patch adds another option to multipath, "-A", which reads
>     /proc/cmdline for mpath.wwid=<WWID> options, and adds any wwids it finds
>     to /etc/multipath/wwids.  While this isn't usually important during
>     normal operation, since these wwids should already be added, it can be
>     helpful during installation, to make sure that multipath can claim
>     devices as its own, before LVM or something else makes use of them.  The
>     patch also execs "/sbin/multipath -A" before running multipathd in
>     multipathd.service
> 

I posted this upstream and Hannes NAKed it a while back. We still find
it useful, since the default multipath.conf file for Redhat sets
find_multipaths to yes. You can currently avoid the race that this is
fixing by setting find_multipaths to smart, but there were objections to
using that as a default in Redhat. However, I never really understood
the objection to this patch, and I'd be fine with re-posting it.

> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0027-RH-warn-on-invalid-regex-instead-of-failing.patch
> 
>    Subject: [PATCH] RH: warn on invalid regex instead of failing
> 
>     multipath.conf used to allow "*" as a match everything regular expression,
>     instead of requiring ".*". Instead of erroring when the old style
>     regular expressions are used, it should print a warning and convert
>     them.

When multipath used its old regex code, "*" worked to match everything.
This patch just exists to make sure that customers didn't need to change
their configs when the regex code changed. Since it's been there posting
warning messages for a while, I plan to eventually drop it entirely, and
let anyone who has been ignoring the warning messages for years finally
have their config error. I see no reason to add it back to the upstream
code now.
 
> 
> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0028-RH-reset-default-find_mutipaths-value-to-off.patch
> 
>    Subject: [PATCH] RH: reset default find_mutipaths value to off
> 
>     Upstream has changed to default find_multipaths to "strict". For now
>     Redhat will retain the previous default of "off".

This is simply to retain the previous default behavior, for much the
same reason as the above patch. I see no reason to change this upstream.

> 
> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0029-RH-Fix-nvme-compilation-warning.patch
> 
>    Subject: [PATCH] RH: Fix nvme compilation warning
>

I assume that other people aren't seeing these compilation warnings, and
this it due to different options that redhat uses when compiling.  I
really should push this patch upstream, but that upstream isn't
multipath-tools, its nvme-cli, where we copied this file from. Once it's
changed there, we can pull the updated files back to multipath-tools.
 
>
> - https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0030-RH-attempt-to-get-ANA-info-via-sysfs-first.patch
> 
>    Subject: [PATCH] RH: attempt to get ANA info via sysfs first
> 
>     When the ANA prioritizer is run, first see if the "ana_state" sysfs file
>     exists, and if it does, try to read the state from there. If that fails,
>     fallback to using an ioctl.
> 

This won't do anything upstream. This requires a redhat specific kernel
patch that wasn't accepted in the upstream nvme kernel code.  It really
doesn't make much of a difference. It just makes multipath try to grab
ANA state info from sysfs, before failing back to the same ioctl that
upstream uses.

- Ben

> Thank you.
