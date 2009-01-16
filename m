From: "Daniel Keisling" <Daniel.Keisling@ppdi.com>
Subject: RE: RE: Temporarily squelching multipathd errors
Date: Fri, 16 Jan 2009 15:52:36 -0600
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C0744141F@AUSMAIL01.americas.ppdi.local>
References: <20081126174317.GA19425@mars.virtualiron.com>
	<65F9ACC78BD8304BAAEB817634C62D4C07441224@AUSMAIL01.americas.ppdi.local>
	<20090116212858.GA27665@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20090116212858.GA27665@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Konrad Rzeszutek [mailto:konrad@virtualiron.com]=20
> Sent: Friday, January 16, 2009 3:29 PM
> To: Daniel Keisling
> Cc: device-mapper development
> Subject: Re: [dm-devel] RE: Temporarily squelching multipathd errors
>=20
> On Fri, Jan 16, 2009 at 02:29:40PM -0600, Daniel Keisling wrote:
> > Right now I'm deleting the LUN, immediately creating a new LUN, and
>=20
> > presenting it back to the system with the same SCSI ID. =20
> Since it's a
>=20
> > snapshot, the LUN geometry is always the same.  I've tried=20
> unpresenting
>=20
> > the LUN, deleting the SCSI devices, recreating/presenting=20
> the LUN, and
>=20
> > then doing a SCSI rescan, but the multipath errors are=20
> always there. =20
>=20
> >=20
>=20
> > Here's the multipath listings.  I am only deleting/presenting the
>=20
> > "mpath33" map, but you can see the multipath errors and the=20
> other paths
>=20
>=20
> How are you 'deleting' the mpath33 map? Are you using=20
> 'dmsetup remove mpath33'
> ?


No, I am telling the storage unit to delete the LUN.  In this test, I:

A) Unmount the filesystem
B) Tell the storage system to delete the LUN (which unpresents it,
obviously)
C) Tell the storage system to make a new LUN using the same WWID and
SCSI ID as before
D) Present the LUN

Since all this takes around 20 seconds, I can immediately mount the LUN
again on the server.

>=20
> > having a fault:
>=20
> >=20
>=20
> > Unmounting /dev/mapper/mpath33p1...
>=20
> > Multipath listing before LUN is deleted...
>=20
> > cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
>=20
> > [size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
>=20
>=20
> ..snip ..
> >=20
>=20
> >=20
>=20
> > Multipath listing after LUN is deleted and before LUN is added...
>=20
>=20
> I am not seeing how you are deleting the SCSI device of the node.
> Are you doing 'echo 1 > /sys/block/sdab/device/delete' for all
> of those block-devices that match the 'deleted LUN'?
>=20


No, I am not.  I have before, but it didn't seem to help.



>=20
> .. snip ..
> >=20
>=20
> >=20
>=20
> > Multipath output after LUN is added...
>=20
>=20
> How are you doing a SCSI rescan?
>=20
>=20

I'm not in this test.  Since all this takes around 20 seconds, I can
immediately mount the LUN again on the server with any SCSI devices
permanently disappearing.

Would you like me to:

A) Umount the filesystem
B) Perform a 'dmsetup remove mpath33'
C) Delete all SCSI devices via /sys/block/$device/delete
D) Tell the storage unit to unpresent and delete the LUN
E) Optionally do a SCSI rescan to clear everything out
F) Tell the storage unit to create the LUN with the same WWID and SCSI
ID
G) Perform a SCSI rescan
H) Do a multipath -v3 to get the maps back (?)
I) Fsck and mount the filesystem?

I believe I get the same results as what I pasted, but will prove it if
need be.

BTW, I do a SCSI rescan with the HP Fibreutils package (hp_rescan -a),
which basically does a "echo "- - -" >
/sys/class/scsi_host/${INST}/scan" and removes devices with "echo "scsi
remove-single-device $INST 0 $j $k" > /proc/scsi/scsi"

Thanks,

Daniel

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
