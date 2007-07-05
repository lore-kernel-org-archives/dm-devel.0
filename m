From: "Raayman, Sebastian" <sebastian.raayman@sap.com>
Subject: RE: RE: online disk resizing
Date: Thu, 5 Jul 2007 11:54:09 +0200
Message-ID: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
References: <mailman.0.1183628608.29322.dm-devel@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <mailman.0.1183628608.29322.dm-devel@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

this is also dependant on the HBA you are using. With a Qlogic adapter
you can simply send an:

echo scsi-qlascan=20

to your Qlogic adapter (for example under /proc/scsqi/qla2xxx). This
will make the adapter aware of for example new LUNs that have been
added.

You can then use the rescan-scsi-bus.sh command to rescan your bus and
make the changes known to the OS. After that just do a resize of the fs
on your disk or add them to the LVM or something similar.

Should work like a charm.

Cheers,
Bas

> I did the same with HP MSA in the past, but without dm involved.
>
> You can use "blockdev --rereadpt <blockdevice>" to make the the kernel
> recognise the new disk size (geometery). The nasty thing is that you
> have to stop all I/O to the blocdevice.=20
>
> Roland Mieslinger
>
> > -----Original Message-----
> > From: dm-devel-bounces redhat com=20
> > [mailto:dm-devel-bounces redhat com] On Behalf Of Alexander Benaguev
> > Sent: Mittwoch, 4. Juli 2007 19:17
> > To: dm-devel redhat com
> > Subject: [dm-devel] online disk resizing
> >=20
> > hi, list
> >=20
> > I have fc-based SAN which has ability to resizing logical=20
> > disks online (IBM DS4000). is this a method tell about=20
> > resizing to host system (centOS 5) without reboot or echo=20
> > "scsi remove(add)-single-device 0 1 2 3"? I use multipath if=20
> > this matters. will apprecate any help
> >=20
> > alexander
> >=20
> > --
> > dm-devel mailing list
> > dm-devel redhat com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
