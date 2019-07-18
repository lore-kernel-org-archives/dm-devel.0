From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 16:35:27 +0000
Message-ID: <MN2PR20MB29733744D766C971A5DCEA6BCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
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
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4418973392471968214=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Horia Geanta <horia.geanta@nxp.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: dm-devel.ids

--===============4418973392471968214==
Content-Language: en-US
Content-Type: multipart/signed;
	boundary="PGP_Universal_982A0EC9_DCDF9C0E_0454DD6E_4E39E009";
	protocol="application/pgp-signature"; micalg="pgp-sha256"

--PGP_Universal_982A0EC9_DCDF9C0E_0454DD6E_4E39E009
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

> >
> > Hmmm ... so the generic CTS template would have to figure out whether i=
t is wrapped
> > around ECB, CBC, XTS or whatever and then adjust to that?
>=20
> That's not hard to do.  Right now cts only supports cbc.  IOW
> if you pass it anything else it will refuse to instantiate.
>=20

Ah, I see it now:

if (strncmp(alg->base.cra_name, "cbc(", 4))
		goto err_drop_spawn;

So you cannot even do cts(xts) at the moment.

> > For XTS, you have this additional curve ball being thrown in called the=
 "tweak".
> > For encryption, the underlying "xts" would need to be able to chain the=
 tweak,
> > from what I've seen of the source the implementation cannot do that.
>=20
> You simply use the underlying xts for the first n - 2 blocks and
> do the last two by hand.
>=20

Possible, but then you're basically pulling a generic XTS implementation in=
to cts.c,
since XTS is nothing more than the repeated application of just that.
Same thing would apply to any other mode you eventually need cts for.

But I suppose it would save you the trouble of having to add cts to all ind=
ividual
optimized software implementations of xts-which-is-not-really-xts, so I can=
 see=20
WHY you would want to do it that way ...

Tthen there's still the issue of advancing that last tweak. From what I've =
seen,
the xts implementation does not output the last tweak so you would have to=
=20
recompute it locally in cts.c as block_cipher_enc(iv) * alpha^j. Which is w=
asteful.
Of course this could be solved by redefining xts to output the last tweak
like CBC/CTR output their last IV ... Which would probably give us HW guys
trouble again because our HW cannot do *that* ... (While the HW very likely=
=20
*does* implement the cipher text stealing properly, just to be able to boast
about IEEE P1619 compliance ...)

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

--PGP_Universal_982A0EC9_DCDF9C0E_0454DD6E_4E39E009
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 10.4.2 (Build 502)

iQEVAwUBXTCfzfLgekqIHlBwAQivyAf/fMuSyLNEr1dR0JRZ6vXs3CWRlRQPc4sc
juzLDGaxWfpwSegf3StWDHyyNW1ue3ibpzAHzb++oNvll2USoo4o7hvsa/8ycPUf
AXlrnjkxy2qcpomgDdPLZDKPgm5fqCHUY/B5b0DxbgC8A0T5ZtjoL5YMp/NO+8WE
GRSFR5boeNn3I88qt0cJ5pjPhA0lSQ6YphnSYfpTow2ulXmr00lH4Wn/mB1oZgyx
r/IAsyiR81vOn7fVz+xGADCjNTjTXUsUHJteljZC06+aoGRGxQm53ZAnmpkC1f2a
+Lb0PaKen4BMkioGxzAeo1qmPeLnQl/CRNKsP1Z+umbU5Nj83DVlBA==
=UzKy
-----END PGP SIGNATURE-----

--PGP_Universal_982A0EC9_DCDF9C0E_0454DD6E_4E39E009--


--===============4418973392471968214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4418973392471968214==--
