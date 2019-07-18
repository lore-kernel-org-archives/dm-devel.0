From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 15:43:29 +0000
Message-ID: <MN2PR20MB2973CC2EFE19B6CBDBBDEA0DCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6517000384276546426=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
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

--===============6517000384276546426==
Content-Language: en-US
Content-Type: multipart/signed;
	boundary="PGP_Universal_161D153D_397DC866_75855059_4C7F9127";
	protocol="application/pgp-signature"; micalg="pgp-sha256"

--PGP_Universal_161D153D_397DC866_75855059_4C7F9127
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

> > In fact, using the current cts template around the current xts template=
 actually does NOT
> > implement standards compliant XTS at all, as the CTS *implementation* f=
or XTS is
> > different from the one for CBC as implemented by the current CTS templa=
te.
>=20
> The template is just a name.  The implementation can do whatever it
> wants for each instance.  So obviously we would employ a different
> implementation for xts compared to cbc.
>
Hmmm ... so the generic CTS template would have to figure out whether it is=
 wrapped=20
around ECB, CBC, XTS or whatever and then adjust to that?

For ECB and CBC I suppose that's techically possible. But then what do I ge=
t when I
try to wrap CTS around some block cipher mode it doesn't recognise? Tricky =
...

For XTS, you have this additional curve ball being thrown in called the "tw=
eak".
For encryption, the underlying "xts" would need to be able to chain the twe=
ak,
=66rom what I've seen of the source the implementation cannot do that.

For decryption, you actually first need to decrypt the last block with the =
last
tweak before you can decrypt the 2nd last block with the 2nd last tweak.

Not sure how you intend to handle that with some generic wrapper around "xt=
s".

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

--PGP_Universal_161D153D_397DC866_75855059_4C7F9127
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 10.4.2 (Build 502)

iQEVAwUBXTCTnvLgekqIHlBwAQgtwQf/Thh49Kl16U2uP/J15s2QZDc74g2waZTz
HNbH7qW4kNrKXk9WOH2S8en8rjGQpGZvyzeHUtn2oOvrYVau3y+415sULuQ0lTxr
ON8nCWOebBA54r5eWUTGNNG/MifezbgmatL1iKmqm0cNwmhqO4+/1q2qTJTitCb2
TqMyFLaevrF7lw4VOjqzJB77MWf6+EV6v0uAZaL74p7USbD2VslZX7rZAbwP3XEQ
GxtmxgObNGJ4bZ/eD0+qu04n+Hz3iNZ+hM4csdqQLeSxku0Nyw1Ls72J54naes/Q
g+BUy8frihzuwwfIFxaXhPEuJ9KV0/DgXw+km11q1JE1zWpSKtRC3w==
=rz3v
-----END PGP SIGNATURE-----

--PGP_Universal_161D153D_397DC866_75855059_4C7F9127--


--===============6517000384276546426==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6517000384276546426==--
