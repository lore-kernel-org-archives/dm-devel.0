From: "Nicholas C. Strugnell" <nstrug@redhat.com>
Subject: Re: [Consult-list] Re: dm-multipath has great
	throughput but we'd like more!
Date: Thu, 18 May 2006 10:04:24 +0200
Message-ID: <1147939464.3183.15.camel@nstrug.surrey.redhat.com>
References: <1147935929.27006.57.camel@baggage>
	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
	<1147938254.27006.65.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1094444399=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147938254.27006.65.camel@baggage>
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


--===============1094444399==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-18dcfjdRakHvchzq+tNL"


--=-18dcfjdRakHvchzq+tNL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
> On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
> > The system bus isn't a limiting factor is it?  64-bit PCI-X will get=20
> > 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
> >=20
> > Can your disks sustain that much bandwidth? 10 striped drives might get=
=20
> > better than 200MB/s if done right, I suppose.
> >=20

This is an HDS Lightning - 64GB of mirrored write cache - I doubt if any
of the writes even see disk :-)

> > Don't the switches run at 2 Gbits/s?  2 Gbits/s / 10 (throw in 2 bits=20
> > for protocol) ~=3D 200MB/s.
> >=20
>=20
> Thanks for the fast responses:
>=20
> The card is a 64-bit PCI-X, so I don't think the bus is the bottleneck,
> and anyway the vendor specifies a maximum throughput of 200Mbyte/s per
> card.
>=20
> The disk array does not appear to be the bottleneck because we get
> 200Mbyte/s when we use *two* HBAs in load-balanced mode.
>=20
> The question is really about why we only see O(100Mbyte/s) with one HBA
> when we can achieve O(200MByte/s) with two cards, given that one card
> should be able to achieve that throughput.
>=20

We've just done _exactly_ the same test against an EVA 8000 with 8
active paths - theoretically we should be able to get 4Gb/s via two HBAs
but in fact we saw max 200MB/s with ext2, dropping to 160MB/s with ext3
- this was to a fairly slow RAID5 but that is irrelevant as we have a
16GB write cache and we were only writing 4GB files with bonnie++

I'm not sure where the overhead is. The fact that we see a 20%
performance drop when we switch journalling on suggests that the
overhead might be in the filesystem perhaps?

It might make sense to test raw writes to a device with dd and see if
that gets comparable performance figures - I'll just try that myself
actually.

Nick=20

--=20
M: +44 (0)7736 665171           Skype: nstrug
http://europe.redhat.com
GPG FPR: 9C6C 093C 756A 6C57 49A1  E211 BBBA F5F5 C440 5DE0


--=-18dcfjdRakHvchzq+tNL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEbCqIu7r19cRAXeARAvsFAKDH0IBEnaKP4F7n7m8uI7pRZUYV9ACgyrH5
4KyFXGrNXA+LnwyrjImhTLM=
=5Y/O
-----END PGP SIGNATURE-----

--=-18dcfjdRakHvchzq+tNL--


--===============1094444399==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1094444399==--
