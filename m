From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Unable to get INQUIRY vpd 1 page 0x0
Date: Mon, 13 Mar 2006 09:23:00 -0800
Message-ID: <20060313172300.GA13879@us.ibm.com>
References: <20060313110046.91886.qmail@web33302.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060313110046.91886.qmail@web33302.mail.mud.yahoo.com>
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

On Mon, Mar 13, 2006 at 03:00:46AM -0800, li nux wrote:
> On doing a '/etc/init.d/boot.udev start' or 'multipath
> -v2 -d' i get following error for all the devices:
> 
> creating device nodes 0:0:0:0: sg_io failed status 0x0
> 0x1 0x0 0x0
> 0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
> 0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0
> 
> Can somebody have an idea, what i need to correct.

You can run scsi_id manually like:

	scsi_id -g -s /block/sda
	scsi_id -g -s /block/sdb

Or for whatever devices are at 0:0:0:0 and 0:0:0:1

Also try normal read/write to the devices.

And you should have posted the full dmesg output (that includes all
SCSI and perhaps PCI messages).

The devices are getting a host status of 1, that is a DID_NO_CONNECT and
generally means the initiator could not talk to the target (the linux
driver or hardware can't communicate with the disk), it is also used by
linux scsi core when it kills IO (like when a device is hot-unplugged
while IO is in progress).

If you get this error all the time, you won't be able to send any commands
to the device. Since the device actually showed up (and linux scsi core
device discovery sent at least an INQUIRY to it OK), something else is now
causing it to fail, you need to figure that out.

Depending on results, discussion should probably be moved to
linux-scsi@vger.kernel.org 

-- Patrick Mansfield
