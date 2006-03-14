From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Unable to get INQUIRY vpd 1 page 0x0
Date: Tue, 14 Mar 2006 09:09:16 -0800
Message-ID: <20060314170916.GA6505@us.ibm.com>
References: <20060313172300.GA13879@us.ibm.com>
	<20060314050311.38998.qmail@web33309.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060314050311.38998.qmail@web33309.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 13, 2006 at 09:03:11PM -0800, li nux wrote:
> --- Patrick Mansfield <patmans@us.ibm.com> wrote:
> 
> > On Mon, Mar 13, 2006 at 03:00:46AM -0800, li nux
> > wrote:
> > > On doing a '/etc/init.d/boot.udev start' or
> > 'multipath
> > > -v2 -d' i get following error for all the devices:
> > > 
> > > creating device nodes 0:0:0:0: sg_io failed status
> > 0x0
> > > 0x1 0x0 0x0
> > > 0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
> > > 0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0
> > > 
> > > Can somebody have an idea, what i need to correct.
> > 
> > You can run scsi_id manually like:
> > 
> > 	scsi_id -g -s /block/sda
> > 	scsi_id -g -s /block/sdb
> > 
> > Or for whatever devices are at 0:0:0:0 and 0:0:0:1
> > 
> 
> This also gives the same error
> 0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0
> 0:0:0:1: Unable to get INQUIRY vpd 1 page 0x0.
> error calling out /sbin/scsi_id -g -u -s /block/sda

Where did the "error calling out" come from if you are running scsi_id
from the command line?

> Why it is enquiring page 0x0, vpd enquires from page
> 0x80 or 0x83, right ?

No. See the SCSI SPC spec, vital product data parameters, or look at
scsi_id source code. Page 0 gives a list of the supported vpd pages.

You can override scsi_id to skip page 0, and use vpd page 0x80 or 0x83.

> > Also try normal read/write to the devices.
> > 
> 
> This works
> 
> > And you should have posted the full dmesg output
> > (that includes all
> > SCSI and perhaps PCI messages).

It might help if you supply more information ... also your configuration
and distro.

> > The devices are getting a host status of 1, that is
> > a DID_NO_CONNECT and
> > generally means the initiator could not talk to the
> > target (the linux
> > driver or hardware can't communicate with the disk),
> > it is also used by
> > linux scsi core when it kills IO (like when a device
> > is hot-unplugged
> > while IO is in progress).
> 
> You are right, The devices were hot-unplugged and then
> new devices were hot-plugged. But udev should take
> care of these events and should refresh its
> device-name mappings accordingly ?

Yes.

> After a rebooted, new disks under /proc/partitions
> looks like cciss/c0d0p1 etc.
> how should i run scsi_id on these ?

I thought that was what you did above ...  I don't know about cciss, and
have never used it.

If this is a problem with the cciss devices, you have to figure it out or
find someone that knows more about them.

I guess they don't support VPD page 0x0, but are failing in a very weird
way.

-- Patrick Mansfield
