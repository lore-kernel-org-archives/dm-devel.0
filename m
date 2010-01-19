From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: Online disk size change and Linux
Date: Tue, 19 Jan 2010 17:17:12 +0100
Message-ID: <20100119161712.GD14594@soda.linbit>
References: <2c46f67e1001190742l13ebdc1fs95aa6d545332bcc1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2c46f67e1001190742l13ebdc1fs95aa6d545332bcc1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 19, 2010 at 01:42:37PM -0200, Daniel Olops wrote:
> Sorry if this is off-topic... but if anyone could help, it'd be good.
> =

> Is Linux (more specifically Red Hat EL 5.4) able to recognize _disk_ size
> changes online? We have some HP servers with QLogic HBAs connected to an =
EVA
> 4000 Storage, with multipathing properly set up. These disks can be resiz=
ed
> online, but only after a reboot that RHEL recognizes the change. I've been
> trying to find any information about it, but to no avail.

If your multipathing is set up properly, as you say,
you should have two "scsi" devices presented, right?

You should be able to avoid the reboot just fine.

We did this some time back on a bunch of virtualization hosts,
using a DRBD+iSCSI cluster as storage backend.

IIRC, we had some problems with (certain firmware versions of)
the QLA properly recognizing deleted luns, or re-added luns after first
deleting some others.  I'm sure firmware and driver have improved since,
so that should all be fixed.

But resizing existing luns was not much trouble,
and has been scripted roughly like this, iirc:

You could try removing one path from dm,
so the scsi dev becomes unused,
echo 1 > /sys/block/sdX/device/rescan
and see what happens in dmesg,
and to the values in /proc/partitions.

you could also delete (echo 1 > .../delete,
or the old echo scsi remove-single-device thing),
then rescan the bus to re-detect the device.

You may even need to remove it from the qlogic hba,
then re-add it again there, possibly depending on
the firmware version.

question is: can you then re-add differing (in size)
"views" (paths) of the "same" device together with dm
multipath, without first taking that dm target down?

Regarding that, my memory is somewhat fuzzy.
So this approach may not be completely "online",
you may have to umount and down the respective dm targets,
then do the scsi (delete and ?) rescan.
Or maybe you need to suspend the dm targets,
then rescan the scsi devices,
then re-attach the multipath targets later.

Something along that way. Sorry that I'm not more specific,
but it has been a while...

-- =

: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.
