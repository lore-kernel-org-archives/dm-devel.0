From: "Daniel Keisling" <daniel.keisling@austin.ppdi.com>
Subject: RE: Temporarily squelching multipathd errors
Date: Thu, 30 Oct 2008 10:48:54 -0500
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C06C1C4D1@AUSMAIL01.americas.ppdi.local>
References: <1216456070.7364.4.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1216456070.7364.4.camel@plop>
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

When adding or removing LUNs, I always get multiple multipath messages
reporting that a path is down, sometimes even to devices that I have not
removed.  I've tried removing all the SCSI devices (via "echo 1
>/sys/bus/devices/$DEVICE/delete"), flushing the multipath maps,
removing the mpath in question (via "multipathd -k"dep map $mpath"),
prior to unpresenting the LUN or doing a SCSI rescan when presenting a
LUN, all to no avail.

What is proper procedure to completely remove all SCSI devices and
multipath maps so that multipathd will not generate error messages when
the LUN is unpresented from the system?

TIA,

Daniel


> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Saturday, July 19, 2008 3:28 AM
> To: Daniel Keisling
> Cc: device-mapper development
> Subject: Re: Temporarily squelching multipathd errors
>=20
>=20
> > Greetings,
> > =20
> > I perform SAN-based snapshots on OCFS2 and ext3 filesystems under
> > dm-multipath.  Before I snapshot the filesystem, I unmount=20
> and delete
> > the previous night's snapshot LUNs.  Doing so causes (correctly)
> > multipathd to output the following errors:
> > =20
> > <snip>
> > ...
> > Jul 14 03:16:02 ausracdbd01 multipathd: mpath19: remaining=20
> active paths:
> > 7
> > Jul 14 03:16:02 ausracdbd01 multipathd: sdci: tur checker=20
> reports path
> > is down
> > Jul 14 03:16:02 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 69:80.
> > Jul 14 03:16:02 ausracdbd01 multipathd: sdco: tur checker=20
> reports path
> > is down
> > ....
> > </snip>
> > =20
> > During this snapshot time, I would like to temporarily turn off the
> > verbosity of multipathd.  Is this possible?  It's mostly an=20
> annoyance
> > factor for me because our nightly centralized syslog scan=20
> picks up words
> > like 'fail' and generates a report to the system=20
> administrators (which
> > we then have to ignore for these messages).
> >=20
> Why not just remove the multipath from the multipathd=20
> topology before deleting the snapvol ?
>=20
> multipathd -k"del map mpath19"
>=20
> Regards,
> cvaroqui
>=20
>=20
>=20

______________________________________________________________________
This email transmission and any documents, files or previous email
messages attached to it may contain information that is confidential or
legally privileged. If you are not the intended recipient or a person
responsible for delivering this transmission to the intended recipient,
you are hereby notified that you must not read this transmission and
that any disclosure, copying, printing, distribution or use of this
transmission is strictly prohibited. If you have received this transmissi=
on
in error, please immediately notify the sender by telephone or return ema=
il
and delete the original transmission and its attachments without reading
or saving in any manner.
