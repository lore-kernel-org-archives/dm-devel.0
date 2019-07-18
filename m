From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 17:03:27 +0000
Message-ID: <MN2PR20MB2973A72AB15D73FCF10AD3C4CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
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
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1628117909731038173=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Horia Geanta <horia.geanta@nxp.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

--===============1628117909731038173==
Content-Language: en-US
Content-Type: multipart/signed;
	boundary="PGP_Universal_8364B94B_54EE25AE_8988CEE2_DCCEC36B";
	protocol="application/pgp-signature"; micalg="pgp-sha256"

--PGP_Universal_8364B94B_54EE25AE_8988CEE2_DCCEC36B
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

> > > For XTS, you have this additional curve ball being thrown in called t=
he "tweak".
> > > For encryption, the underlying "xts" would need to be able to chain t=
he tweak,
> > > from what I've seen of the source the implementation cannot do that.
> >
> > You simply use the underlying xts for the first n - 2 blocks and
> > do the last two by hand.
> >
>=20
> OK, so it appears the XTS ciphertext stealing algorithm does not
> include the peculiar reordering of the 2 final blocks, which means
> that the kernel's implementation of XTS already conforms to the spec
> for inputs that are a multiple of the block size.
>=20
Yes, for XTS you effectively don't do CTS if it's a 16 byte multiple ...

> The reason I am not a fan of making any changes here is that there are
> no in-kernel users that require ciphertext stealing for XTS, nor is
> anyone aware of any reason why we should be adding it to the userland
> interface. So we are basically adding dead code so that we are
> theoretically compliant in a way that we will never exercise in
> practice.
>=20
You know, having worked on all kinds of workarounds for silly irrelevant
(IMHO) corner cases in  the inside-secure hardware driver over the past
months just to keep testmgr happy, this is kind of ironic ...

Cipher text stealing happens to be a *major* part of the XTS specification
(it's not actually XTS without the CTS part!), yet you are suggesting not=20
to implement it because *you* don't have or know a use case for it.
That seems like a pretty bad argument to me. It's not some minor corner=20
case that's not supported.The implementation is just *incomplete*
without it.

> Note that for software algorithms such as the bit sliced NEON
> implementation of AES, which can only operate on 8 AES blocks at a
> time, doing the final 2 blocks sequentially is going to seriously
> impact performance. This means whatever wrapper we invent around xex()
> (or whatever we call it) should go out of its way to ensure that the
> common, non-CTS case does not regress in performance, and the special
> handling is only invoked when necessary (which will be never).
>
I pretty much made the same argument about all these driver workarounds
slowing down my driver fast path but that was considered a non-issue.

In this particular case, it should not need to be more than:

if (unlikely(size & 15)) {
  xts_with_partial_last_block();
} else {
  xts_with_only_full_blocks();
}

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com


--PGP_Universal_8364B94B_54EE25AE_8988CEE2_DCCEC36B
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 10.4.2 (Build 502)

iQEVAwUBXTCmXPLgekqIHlBwAQhFyggAjXmI6K2Wfg800PAeeqOf21Sb2L+dYlpb
gQ2TWhTzoGBP5uY6/deTdGIYZYb8pRe63p3RijlEjKvkaNANL1TlEAwFAApiV2oA
MBcGW5veY/UMx6obWi68uWMrGNdQOjDbFolumQWTWKuaMVHCF4pdQznvhtyRSDvS
I8HUKBC48jaBTmingwWbbHPRdVqqdBoYfmWW0O/huMtwju7/FvoZFE01+ngG8aun
0kx7lHq9qAbHs+YbfrmkxcbBBzVSfotIUCu4swuQD7ncznJMSl/5Or2yNg9MYGAI
WGeAE8HLx1T1FUOmCm2IVWNWON20/IG9h2xlfmFaW7Xgs0RjmQHigQ==
=uTd+
-----END PGP SIGNATURE-----

--PGP_Universal_8364B94B_54EE25AE_8988CEE2_DCCEC36B--


--===============1628117909731038173==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1628117909731038173==--
