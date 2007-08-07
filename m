From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 22:28:17 +0100
Message-ID: <20070807212817.GB2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B254E4.60700@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 02, 2007 at 06:04:20PM -0400, Phillip Susi wrote:
> I'd rather not see it that tightly coupled to dm.  I was thinking 
> perhaps of something involving udev attributes so that udev would know 
> not to run pvscan on that device.  Though it looks like pvscan also 
> needs reworked so it plays nice with udev, being called to scan a given 
> device as detected rather than looking for all well known physical 
> device names in /dev.

It's been fairly clear how this should all work from the lvm2 side for
some time now, but it will still take a while to implement.

As I've said many times before, in my view the current problems stem
from some system components unilaterally switching to an event-driven
model while others (including lvm2 and initscripts) haven't - and
combining two incompatible models on a system was "brave".

If lvm2 is run in an event-driven environment, the idea is for it to
give up all its device scanning and filtering.  It will hand over
control of what devices to use to an external module shared by
everything that needs to know about devices - including mdadm,
initscripts, mount, hal, udev etc.  [What owns this module is irrelevant
but udev is an obvious candidate.]

When udev sees a new device, it will inform each subsystem of the
device.

lvm2 will provide an interface that is given a device and, if a PV is
present on it, lvm2 will pass information about it (including its UUID)
to the external module for storage.

The external module will have an interface capable of being told
by lvm2 (at any time) 'Devices with UUIDs X, Y and Z form a volume
group called VGn'.

Triggers can be defined so that when all the PV UUIDs are present
for a volume group with name VGn, an lvm2 command (like 'vgchange -ay
VGn') gets invoked.
 
You can see how md, mount etc. can work in a similar event-driven
fashion.

Alasdair
-- 
agk@redhat.com
