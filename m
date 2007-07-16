From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: zSeries zipl on a blacklisted multipath path.
Date: Mon, 16 Jul 2007 08:53:00 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336012DC89D@EXCNYSM0A1AN.nysemail.nyenet>
References: <OF46794A52.87C406F5-ONC125731A.00310229-C125731A.0032686E@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
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
Thank you for the response.   I currently do as you suggest: we use a 50M=
B single-partition boot LUN for /boot.  I'm interested in an alternative =
to reduce administrative hassle of using 2 LUNs when 1 LUN that includes =
root and boot partition would normally be enough.

If IBM could be persuaded to enhance zipl to handle multipath SCSI my pro=
blem would be solved; I could then have multipath root and multipath boot=
 on same LUN. Now I have multipath root and multipath boot, but on separa=
te LUNs because of the zipl disk geometry limitation.

Regards,
John


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com on behalf of Stefan Bader
Sent: Mon 7/16/2007 5:12 AM
To: device-mapper development
Subject: Re: [dm-devel] zSeries zipl on a blacklisted multipath path.
=20
Hi,

first it would be hard to guarantee nothing else tries to touch the=20
remaining partitions. But the main issue is that multipath targets are=20
created from the complete device and then, on top of the multipath volume=
,=20
the tools create linear targets that represent the partitions. So you=20
can't just use parts of a device through a multipath volume and other=20
parts directly.
Why not simply create a small SCSI disk that only has one partition with=20
/boot on it? This one you can safely blacklist and use as a boot device.

Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 13.07.2007 18:40:55:

> Hi List,
> I run SLES9 on IBM zSeries and I'm trying to hack a way to have my boot
> partition on a multipath LUN and yet still be able to run IBM's zipl to
> update the boot loader on that LUN.
> The SLES9 has kernel 2.6.5-7.276-s390x, device-mapper-1.01.01-1.6,
> multipath-tools-0.4.5-0.20.
>=20
> zipl won't update a multipath boot partition, zipl can't get the
> geometry of a device-mapper device and quits with message
> "Error: Could not get disk geometry"; this is a device-mapper
> limitation, not zipl's fault.
>=20
> Since zipl needs a plain /dev/sdx boot device to update,
> my hack idea is to put the boot partition on the multipath LUN and in
> multipath.conf blacklist one of the LUN's paths (lets say /dev/sda) so
> zipl can use /dev/sda to update the boot loader. I would unmount the
> multipath boot partition device from /boot, mount /dev/sda at /boot and
> then run zipl.
>=20
> Any ideas how risky this would be: I/O to the LUN's non-boot partitions
> via multipaths and zipl I/O to the LUN's boot partition via the
> blacklisted path?
> --------------------------------------------------------
> This e-mail, including any attachments, may be confidential,=20
> privileged or otherwise legally protected. It is intended only for=20
> the addressee. If you received this e-mail in error or from someone=20
> who was not authorized to send it to you, do not disseminate, copy=20
> or otherwise use this e-mail or its attachments.  Please notify the=20
> sender immediately by reply e-mail and delete the e-mail from your=20
system.
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
