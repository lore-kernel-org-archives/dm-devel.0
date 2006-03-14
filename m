From: li nux <lnxluv@yahoo.com>
Subject: Re: Unable to get INQUIRY vpd 1 page 0x0
Date: Mon, 13 Mar 2006 21:03:11 -0800 (PST)
Message-ID: <20060314050311.38998.qmail@web33309.mail.mud.yahoo.com>
References: <20060313172300.GA13879@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060313172300.GA13879@us.ibm.com>
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
Cc: patmans@us.ibm.com
List-Id: dm-devel.ids

--- Patrick Mansfield <patmans@us.ibm.com> wrote:

> On Mon, Mar 13, 2006 at 03:00:46AM -0800, li nux
> wrote:
> > On doing a '/etc/init.d/boot.udev start' or
> 'multipath
> > -v2 -d' i get following error for all the devices:
> >=20
> > creating device nodes 0:0:0:0: sg_io failed status
> 0x0
> > 0x1 0x0 0x0
> > 0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
> > 0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0
> >=20
> > Can somebody have an idea, what i need to correct.
>=20
> You can run scsi_id manually like:
>=20
> 	scsi_id -g -s /block/sda
> 	scsi_id -g -s /block/sdb
>=20
> Or for whatever devices are at 0:0:0:0 and 0:0:0:1
>=20

This also gives the same error
0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0
0:0:0:1: Unable to get INQUIRY vpd 1 page 0x0.
error calling out /sbin/scsi_id -g -u -s /block/sda

Why it is enquiring page 0x0, vpd enquires from page
0x80 or 0x83, right ?

> Also try normal read/write to the devices.
>=20

This works

> And you should have posted the full dmesg output
> (that includes all
> SCSI and perhaps PCI messages).
>=20
> The devices are getting a host status of 1, that is
> a DID_NO_CONNECT and
> generally means the initiator could not talk to the
> target (the linux
> driver or hardware can't communicate with the disk),
> it is also used by
> linux scsi core when it kills IO (like when a device
> is hot-unplugged
> while IO is in progress).

You are right, The devices were hot-unplugged and then
new devices were hot-plugged. But udev should take
care of these events and should refresh its
device-name mappings accordingly ?

After a rebooted, new disks under /proc/partitions
looks like cciss/c0d0p1 etc.
how should i run scsi_id on these ?

>=20
> If you get this error all the time, you won't be
> able to send any commands
> to the device. Since the device actually showed up
> (and linux scsi core
> device discovery sent at least an INQUIRY to it OK),
> something else is now
> causing it to fail, you need to figure that out.
>=20
> Depending on results, discussion should probably be
> moved to
> linux-scsi@vger.kernel.org=20
>=20
> -- Patrick Mansfield


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
