From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: RH-patches for upstream ???
Date: Thu, 3 Oct 2019 20:28:06 +0200
Message-ID: <e2b955d0-69ea-2c2b-9f0f-ccf3b5f369d0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Benjamin,


Is there any relevant RH-patch for upstream in fedora repo:
https://src.fedoraproject.org/rpms/device-mapper-multipath/ ???

Maybe:

- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0022-RH-Remove-the-property-blacklist-exception-builtin.patch

    Subject: [PATCH] RH: Remove the property blacklist exception builtin

     Multipath set the default property blacklist exceptions to	
     (ID_SCSI_VPD|ID_WWN).  This has the effect of blacklisting some internal
     devices.  These devices may never have multiple paths, but it is nice
     to be able to set multipath up on them all the same.  This patch simply
     removes the default, and makes it so that if no property
     blacklist_exception is given, then devices aren't failed for not matching
     it.


- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0026-RH-add-wwids-from-kernel-cmdline-mpath.wwids-with-A.patch

    Subject: [PATCH] RH: add wwids from kernel cmdline mpath.wwids with -A

     This patch adds another option to multipath, "-A", which reads
     /proc/cmdline for mpath.wwid=<WWID> options, and adds any wwids it finds
     to /etc/multipath/wwids.  While this isn't usually important during
     normal operation, since these wwids should already be added, it can be
     helpful during installation, to make sure that multipath can claim
     devices as its own, before LVM or something else makes use of them.  The
     patch also execs "/sbin/multipath -A" before running multipathd in
     multipathd.service


- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0027-RH-warn-on-invalid-regex-instead-of-failing.patch

    Subject: [PATCH] RH: warn on invalid regex instead of failing

     multipath.conf used to allow "*" as a match everything regular expression,
     instead of requiring ".*". Instead of erroring when the old style
     regular expressions are used, it should print a warning and convert
     them.


- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0028-RH-reset-default-find_mutipaths-value-to-off.patch

    Subject: [PATCH] RH: reset default find_mutipaths value to off

     Upstream has changed to default find_multipaths to "strict". For now
     Redhat will retain the previous default of "off".


- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0029-RH-Fix-nvme-compilation-warning.patch

    Subject: [PATCH] RH: Fix nvme compilation warning


- https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0030-RH-attempt-to-get-ANA-info-via-sysfs-first.patch

    Subject: [PATCH] RH: attempt to get ANA info via sysfs first

     When the ANA prioritizer is run, first see if the "ana_state" sysfs file
     exists, and if it does, try to read the state from there. If that fails,
     fallback to using an ioctl.


Thank you.
