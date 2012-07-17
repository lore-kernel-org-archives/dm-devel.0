From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 12:29:14 +1000
Message-ID: <20120717122914.4d6d160f@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712162205.GA13485@www5.open-std.org>
	<331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
	<20120713011505.GA3099@www5.open-std.org>
	<20120713112717.3b15647c@notabene.brown>
	<20120713082923.GA19771@www5.open-std.org>
	<20120716161431.42749a15@notabene.brown>
	<20120716082843.GA30247@www5.open-std.org>
	<B5AB774E-C433-4DDC-B878-F1A50AD03AB2@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XbBFeV6YlD3WWTsBvgGvyc/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B5AB774E-C433-4DDC-B878-F1A50AD03AB2@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: keld@keldix.com, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/XbBFeV6YlD3WWTsBvgGvyc/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 17:53:53 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 16, 2012, at 3:28 AM, keld@keldix.com wrote:
>=20
> >>=20
> >> Maybe you are suggesting that dmraid should not support raid10-far or
> >> raid10-offset until the "new" approach is implemented.
> >=20
> > I don't know. It may take a while to get it implemented as long as no s=
easoned=20
> > kernel hackers are working on it. As it is implemented now by Barrow, w=
hy not then go
> > forward as planned.=20
> >=20
> > For the offset layout I don't have a good idea on how to improve the re=
dundancy.
> > Maybe you or others have good ideas. Or is the offset layout an impleme=
ntation
> > of a standard layout? Then there is not much ado. Except if we could fi=
nd a layout that has
> > the same advantages but with better redundancy.
>=20
> Excuse me, s/Barrow/Brassow/ - my parents insist.
>=20
> I've got a "simple" idea for improving the redundancy of the "far" algori=
thms.  Right now, when calculating the device on which the far copy will go=
, we perform:
> 	d +=3D geo->near_copies;
> 	d %=3D geo->raid_disks;
> This effectively "shifts" the copy rows over by 'near_copies' (1 in the s=
imple case), as follows:
> 	disk1	disk2	or	disk1	disk2	disk3
> 	=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D		=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D	=3D=3D=
=3D=3D=3D
> 	 A1	 A2		 A1	 A2	 A3
> 	 ..	 ..		 ..	 ..	 ..
> 	 A2	 A1		 A3	 A1	 A2
> For all odd numbers of 'far' copies, this is what we should do.  However,=
 for an even number of far copies, we should shift "near_copies + 1" - unle=
ss (far_copies =3D=3D (raid_disks / near_copies)), in which case it should =
be simply "near_copies".  This should provide maximum redundancy for all ca=
ses, I think.  I will call the number of devices the copy is shifted the "d=
evice stride", or dev_stride.  Here are a couple examples:
> 	2-devices, near=3D1, far=3D2, offset=3D0/1: dev_stride =3D nc (SAME AS C=
URRENT ALGORITHM)
>=20
> 	3-devices, near=3D1, far=3D2, offset=3D0/1: dev_stride =3D nc + 1.  Layo=
ut changes as follows:
> 	disk1	disk2	disk3
> 	=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D
> 	 A1	 A2	 A3
> 	 ..	 ..	 ..
> 	 A2	 A3	 A1
>=20
> 	4-devices, near=3D1, far=3D2, offset=3D0/1: dev_stride =3D nc + 1.  Layo=
ut changes as follows:
> 	disk1	disk2	disk3	disk4
> 	=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D
> 	 A1	 A2	 A3	 A4
> 	 ..	 ..	 ..	 ..
> 	 A3	 A4	 A1	 A2

Hi Jon,
 This looks good for 4 devices, but I think it breaks down for e.g. 6 devic=
es.

I think a useful measure is how many different pairs of devices exist such
that when both fail we lose data (thinking of far=3D2 layouts only).  We wa=
nt to
keep this number low.  Call it the number of vulnerable pairs.

With the current layout with N devices, there are N pairs that are vulnerab=
le.
(x and x+1 for each x).  If N=3D=3D2, the two pairs are 0,1 and 1,0.  These
pairs are identical so there is only one vulnerable pair.

With your layout there are still N pairs (x and x+2) except when there are 4
devices (N=3D2), we get 0,2 1,3 2,0 3,1 in which case 2 sets of pairs are
identical (1,3 =3D=3D 3,1 and 2,4=3D=3D4,2).
With N=3D6 the 6 pairs are=20
0,2 1,3 2,4 3,5 4,0 5,1
and no two pairs are identical.  So there is no gain.

The layout with data stored on device 'x' is mirrored on device 'x^1' has
N/2 pairs which are vulnerable.=20
An alternate way to gain this low level of vulnerability would be to mirror
data on X onto 'X+N/2'  This is the same as your arrangement for N=3D=3D4.
For N=3D=3D6 it would be:

A  B  C  D  E  F
G  H  I  J  K  L
....
D  E  F  A  B  C
J  K  L  G  H  I
...

so the vulnerable pairs are 0,3 1,4 2,5
This might be slightly easier to implement (as you suggest: have a
dev_stride, only set it to raid_disks/fc*nc).

>=20
> This should require a new bit in 'layout' (bit 17) to signify a different=
 calculation in the way the copy device selection happens.  We then need to=
 replace 'd +=3D geo->near_copies' with 'd +=3D geo->dev_stride' and set de=
v_stride in 'setup_geo'.  I'm not certain how much work it is beyond that, =
but I don't *think* it looks that bad and I'd be happy to do it.

I'm tempted to set bit 31 to mean "bits 0xFF are number of copies and bits
0xFF00 define the layout of those copies".. but just adding a bit17 probably
makes more sense.

If you create and test a patch using the calculation I suggested, I'll be
happy to review it.

>=20
> So, should I allow the current "far" and "offset" in dm-raid, or should I=
 simply allow "near" for now?

That's up to you.  However it might be sensible not to rush into supporting
the current far and offset layouts until this conversation has run its cour=
se.

Thanks,
NeilBrown


--Sig_/XbBFeV6YlD3WWTsBvgGvyc/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATN+jnsnt1WYoG5AQLq4Q/9EUCwd8dGXxunJc9MA3FDBcBTIwoyhCIn
/fzoxyTKoLRTIfW/qf/dpQi9a2X9/4/E2xgnT2p46x3meQe7ePHLcl30nhfY2Kyo
jAWqAmJuvUax5a+SxmIUuxeLKruL3hzvmSAr0P8SQ57nXSA3hoWTEU45Fzh2H9yc
aDow70uuW10jYWJdp92Fuyzlb29WnLwR+D0/BDfJk9Z9BRzHh0wUmcmSfcKxpxGx
ti83BgOBv+DSl+EchUzonAga065I93gMVNC2Ruf3liLhWeoVeOyxkd6iGBAT4jTE
z6i7HmeHYEFQxQp7Fa1JjOV837W6RFl1xD7AuDcb5wbEbfdSjD1/5RGYeRQg6O96
9vOUQBwz7wKsHrYJSLwosNOM5qXzZ4v/NoDvf1NAwAB8xAUh63mTX8J56raBjh2R
f09fxaHGpXR42kvUr48hjtpnHrb7ZIajsb/cdY2usOb9slGbhaApCrXKVVjgbF+h
/Xy2Pt9dEGLH7hyjvYrrIOr+uduIiHvAhN7B7e1G8li88NyA7N2oV9Tlt30mZoev
i9N/PZUZBqk4Ouyy5GimmvzMz7M3PYx3sRHkxuiimumqvqLW9FrlS653qleGApvC
LkV8wf30o52vnfjiBegT08vMaufNeg4zLHwIr3LFTIzF/8KIyCH0YAbASNlX2mgI
AhPb9xwBshY=
=w9O5
-----END PGP SIGNATURE-----

--Sig_/XbBFeV6YlD3WWTsBvgGvyc/--
