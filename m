From: "Nicholas C. Strugnell" <nstrug@redhat.com>
Subject: Re: [Consult-list] Re: dm-multipath has great
	throughput but we'd like more!
Date: Thu, 18 May 2006 11:42:36 +0200
Message-ID: <1147945356.3183.39.camel@nstrug.surrey.redhat.com>
References: <1147935929.27006.57.camel@baggage>
	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
	<1147938254.27006.65.camel@baggage>
	<1147939464.3183.15.camel@nstrug.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1999595454=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147939464.3183.15.camel@nstrug.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rgautier@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, consult-list@redhat.com
List-Id: dm-devel.ids


--===============1999595454==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-INTUpVe4C5NbijrupbF3"


--=-INTUpVe4C5NbijrupbF3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote:=20
> On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
> > On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
> > > The system bus isn't a limiting factor is it?  64-bit PCI-X will get=20
> > > 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
> > >=20
> > > Can your disks sustain that much bandwidth? 10 striped drives might g=
et=20
> > > better than 200MB/s if done right, I suppose.
> > >=20
>=20

> It might make sense to test raw writes to a device with dd and see if
> that gets comparable performance figures - I'll just try that myself
> actually.

write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
HBAs, 2GB RAM

testing 4GB files:

on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root

ext3: 129MB/s sd=3D0.43

ext2: 202MB/s sd=3D21.34

on raw: 216MB/s sd=3D3.93  (dd if=3D/dev/zero of=3D/dev/mpath/3600508b40010=
48ba0000b00001400000 bs=3D4k count=3D1048576)


NB I did not have exclusive access to the SAN or this particular storage
array - this is a big corp. SAN network under quite heavy load and disk
array under moderate load - not even sure if I had exclusive access to
the disks. All values averaged over 20 runs.=20

The very low deviation of write speed on ext3 vs. exr2 or raw is
interesting - not sure if it means anything.

In any case, we don't manage to get very close to the theoretical
throughput of the 2 HBAs, 512MB/s

Nick



--=20
M: +44 (0)7736 665171           Skype: nstrug
http://europe.redhat.com
GPG FPR: 9C6C 093C 756A 6C57 49A1  E211 BBBA F5F5 C440 5DE0


--=-INTUpVe4C5NbijrupbF3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEbEGMu7r19cRAXeARAkz8AJ4wik/dB7S/LQSk+gS4nOqHHVxNAACdHxB+
HbSZNNPzDyFrNpxNC4JEQ1Y=
=YZHQ
-----END PGP SIGNATURE-----

--=-INTUpVe4C5NbijrupbF3--


--===============1999595454==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1999595454==--
