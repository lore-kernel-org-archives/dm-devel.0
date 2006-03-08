From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] hostraid dmraid plugin should check for hostraid
	controller
Date: Tue, 07 Mar 2006 16:18:30 -0800
Message-ID: <1141777110.24849.49.camel@localhost.localdomain>
References: <1141772430.24849.41.camel@localhost.localdomain>
	<1141775681.3293.8.camel@vroomfondel.internal.datastacks.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	"ATARAID (eg,  Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0767761219=="
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <1141775681.3293.8.camel@vroomfondel.internal.datastacks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: Peter Jones <pjones@redhat.com>
Cc: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, dm-devel <dm-devel@redhat.com>, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


--===============0767761219==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-eisOwdUmZxqmzYrMvxFR"


--=-eisOwdUmZxqmzYrMvxFR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Yay for PCI config space oddities.  You make a good point about recovery
too. Well, scratch this patch then.  As far as distinguishing the "new
unexpected raidset" vs the "known raidset" case, perhaps we could have a
dmraidtab that would list all the array names that we know about, and
some option that says "mount the raidsets listed in dmraidtab", sort of
like what mount -a does?

--D

On Tue, 2006-03-07 at 18:54 -0500, Peter Jones wrote:
> On Tue, 2006-03-07 at 15:00 -0800, Darrick J. Wong wrote:
> > Hi all (and Heinz in particular),
> >=20
> > The attached patch against dmraid v1.0.0rc10 removes an unneeded
> > comment, supplements an existing one, and most importantly, and causes
> > is_asr to reject a disk if it can prove that the PCI controller attache=
d
> > to the disk is not a categorized as a RAID controller (this
> > characteristic of the PCI class code is true for all the hostraid
> > adapters in my lab).
>=20
> It's not true for all of the ones on my desk... some show themselves as
> IDE, some as SCSI, and some as SATA.
>
> > This part of the patch helps us to avoid the situation where you can
> > take a disk out of a HostRAID array, plug it in to a different system,
> > and have dmraid -ay go all haywire when it can't find the rest of the
> > disks.  It is my intent, however, that if is_asr will not reject a disk
> > if it can't make this positive identification; this patch therefore
> > should not affect Heinz's dm-based fakefakeraid testing rig. :)
>=20
> It also screws up the recovery case -- moving a set of disks from one
> machine to another just to read them.
>=20
> We need to be treating "discovery of new, unexpected raidsets"
> differently from "discovery and assembly of raidsets we know about", but
> really that's at a higher level than what the "dmraid" utility is doing.
> It just scans; it doesn't care why.  For this sort of elimination, you
> care about why.
>=20

--=-eisOwdUmZxqmzYrMvxFR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEDiLWa6vRYYgWQuURAoBTAKCkUjy8lIQwryHtlGWKTqiJYpf6fwCgiaGr
u8ExNx3SfPgkmTlSiXuNncE=
=B5uQ
-----END PGP SIGNATURE-----

--=-eisOwdUmZxqmzYrMvxFR--


--===============0767761219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ataraid-list mailing list
Ataraid-list@redhat.com
https://www.redhat.com/mailman/listinfo/ataraid-list
--===============0767761219==--
