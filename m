From: William Lovaton <williama_lovaton@coomeva.com.co>
Subject: Re: Fibre Channel related crash
Date: Thu, 23 Jun 2005 09:24:18 -0500
Message-ID: <1119536659.31100.16.camel@nalwalovaton>
References: <1119361784.24150.47.camel@nalwalovaton>
	<20050622172832.GA11128@us.ibm.com>
	<20050623135227.GK9070@vienna.egenera.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050623135227.GK9070@vienna.egenera.com>
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

Hi,

Thanx to all of you for the responses.  To be honest I don't know much
about all of this of fibre channel and device mapper thing.  How are
they related? I'm not even sure if they are the same or not.

I'm dealing with this because we have installed an Oracle database for a
mission critical web app here in my company and we have always been
using Linux and Fedora in particular, but this is the first time I have
to deal with this kind of hardware.

Could you point me to some place where I can learn about all this stuff
for someone with good experience with linux but zero experience with
this subject.

I have been reading the archives of this mailing list but the knowledge
needed to understand some of the threads is not of my level.

Thanx again for your help,


-William


El jue, 23-06-2005 a las 09:52 -0400, Philip R Auld escribi=C3=B3:
> Hi,
>=20
> Rumor has it that on Wed, Jun 22, 2005 at 10:28:32AM -0700 Patrick Mans=
field said:
> > You should really run with a stock kernel before reporting problems t=
o
> > these lists.
> >=20
> > cc-ing linux-scsi, maybe someone there will give you more info about =
the
> > HSV110.
>=20
> The HSV110 is and active/passive array. You're probably accessing a LU=20
> that is not on the controller your talking to. Sending it a start would
> work, but, of course, then you can't access it through the other
> controller...
>=20
> I think the multipath tools and device mapper will know how to handle
> this device.
>=20
> Cheers,
>=20
> Phil
> >=20
> > On Tue, Jun 21, 2005 at 08:49:44AM -0500, William Alberto Lovaton Tov=
ar wrote:
> >=20
> > > Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 =
(C)COMPAQ  Rev: 2001
> > > Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access           =
           ANSI SCSI revision: 02
> > > Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:1:2=
): Enabled tagged queuing, queue depth 32.
> > > Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byt=
e hdwr sectors (85899 MB)
> > > Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> > > Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write t=
hrough
> > > Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byt=
e hdwr sectors (85899 MB)
> > > Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> > > Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write t=
hrough
> > > Jun 20 13:35:01 dnccor50 kernel:  sdb:<6>Device sdb not ready.
> > > Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, s=
ector 0
> >=20
> > It isn't a fibre channel crash.
> >=20
> > The device is (obviously) not ready. Usually, sd during probe spins u=
p the
> > device, but the HSV110 is special cased, so we don't spin it up (send=
 a
> > START STOP command), and it just keeps telling us it is still not rea=
dy.
> >=20
> > Since it's a disk array, I don't know what a START / spinup means for=
 it,
> > or why it is not ready. I would guess it has some sort of failure and=
 is
> > waiting for you to fix it :)
> >=20
> > You should check the device: verify its settings, check for failures,
> > and/or reset it; or maybe send it a START UNIT to the device.
> >=20
> > You can try to dynamically modify the scsi_devinfo/bflags so it sends=
 the
> > START STOP during probe:=20
> >=20
> > change the devinfo list (won't be reset to the original until you rel=
oad
> > scsi_mod), I don't know if I have this exactly right:
> >=20
> > 	echo "COMPAQ   :HSV110 (C)COMPAQ:0x0" > /proc/scsi/device_info
> >=20
> > remove and re-scan for the device
> >=20
> > 	echo 1 > /sys/block/sd/device/delete
> > 	echo "0 1 2" > /sys/class/scsi_host/host0/scan
> >=20
> > And see what happens ... you should see some "spinning up disk ..."
> > messages.
> >=20
> > -- Patrick Mansfield
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
