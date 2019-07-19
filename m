From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Fri, 19 Jul 2019 07:29:26 +0000
Message-ID: <MN2PR20MB29734E80776A79B6BDDB38CACACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
	<MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
	<CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
	<MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4465943907565423121=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

--===============4465943907565423121==
Content-Language: en-US
Content-Type: multipart/signed;
	boundary="PGP_Universal_9F2CBC73_A406C752_781FDF97_4DB767FE";
	protocol="application/pgp-signature"; micalg="pgp-sha256"

--PGP_Universal_9F2CBC73_A406C752_781FDF97_4DB767FE
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

> -----Original Message-----
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Sent: Friday, July 19, 2019 7:35 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; Milan Broz <gmazyland@gmail=
.com>; Horia Geanta <horia.geanta@nxp.com>; linux-
> crypto@vger.kernel.org; dm-devel@redhat.com
> Subject: Re: xts fuzz testing and lack of ciphertext stealing support
 >=20
> I would argue that these cases are diametrically opposite: you
> proposed to remove support for zero length input vectors from the
> entire crypto API to prevent your driver from having to deal with
> inputs that the hardware cannot handle.
>=20
I did not propose any such thing - I just proposed to make zero length hash=
 support *optional*
(i.e. don't fail and disable the driver on it) as it's totally irrelevant f=
or 99.99999% of use cases.
(including *all* use cases I consider relevant for HW acceleration)

> I am proposing not to add support for cases that we have no need for.
>
While you are proposing to stick with an implementation that can only deal =
with 6.25% (1/16th) of=20
*legal* input data for XTS and fails on the remaining 93.75%. That's hardly=
 a corner case anymore.
=20
> XTS without CTS is indistinguishable from XTS with CTS if the inputs
> are always a multiple of the block size, and in 12 years, nobody has
> ever raised the issue that our support is limited to that. So what
> problem are we fixing by changing this? dm-crypt does not care,
> fscrypt does not care, userland does not care (given that it does not
> work today and we are only finding out now due to some fuzz test
> failing on CAAM)
>=20
If it's not supported, then it cannot be used. Most people would not start =
complaining about that,=20
they would just roll their own locally or they'd give up and/or use somethi=
ng else.=20
So the fact that it's currently not being used does not mean a whole lot. A=
lso, it does not mean=20
that there will not be a relevant use case tomorrow. (and I can assure you =
there *are* definitely
real-life use cases, so I have to assume these are currently handled outsid=
e of the base kernel)

In any case, if you try to use XTS you would *expect* it to work for any in=
put >=3D 16 bytes as that's
how the algorithm is *specified*. Without the CTS part it's simply not XTS.

> > I pretty much made the same argument about all these driver workarounds
> > slowing down my driver fast path but that was considered a non-issue.
> >
> > In this particular case, it should not need to be more than:
> >
> > if (unlikely(size & 15)) {
> >   xts_with_partial_last_block();
> > } else {
> >   xts_with_only_full_blocks();
> > }
> >
>=20
> Of course. But why add this at all if it is known to be dead code?
>
But that's just an assumption and assumptions are the root of all evil ;-)


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

--PGP_Universal_9F2CBC73_A406C752_781FDF97_4DB767FE
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 10.4.2 (Build 502)

iQEVAwUBXTFxVPLgekqIHlBwAQgQrAgAlYt/Sl+TabwjZKrHBAc9zJhrcgLknXDp
mU0ClfSXmepsV1TdBw+/pGB+pgIElN6CzYHwhTvIf6jAyV2Pl32ari7rvC+axm3D
oIvUTlt4tJKE9wFAFz5DHb00ngr0rAdjeOm7vWOQ6ca11JIQu8J6fGoVBzJO4giy
oJUi/nSfT2x2+ape5nGs3ky8mzErFGjCb1iV3q+8hn1zp5C6FXQk4/aL6oHpdYc/
7MrzMtxSaIrE05XnyNdrhw5BOoMxFQ8aFN6SOMDTmhGB/en0p2esRbTn0ljBdfsK
Ngl2gGjomXQRs0qeYru6vUbjiVoNAfpX/n0aotSFmpjpCJtI9MSUsQ==
=dmG9
-----END PGP SIGNATURE-----

--PGP_Universal_9F2CBC73_A406C752_781FDF97_4DB767FE--


--===============4465943907565423121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4465943907565423121==--
