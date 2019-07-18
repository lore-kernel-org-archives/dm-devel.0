From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 10:40:56 +0000
Message-ID: <MN2PR20MB2973D8B6E898E3212D6A4A12CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5368009546455856632=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
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
To: Milan Broz <gmazyland@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>
List-Id: dm-devel.ids

--===============5368009546455856632==
Content-Language: en-US
Content-Type: multipart/signed;
	boundary="PGP_Universal_DE47C979_136D8CF4_95D90198_F11F13E0";
	protocol="application/pgp-signature"; micalg="pgp-sha256"

--PGP_Universal_DE47C979_136D8CF4_95D90198_F11F13E0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Milan Broz
> Sent: Thursday, July 18, 2019 9:40 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>; Ard Biesheuvel <ard.biesheu=
vel@linaro.org>
> Cc: Horia Geanta <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org; dm=
-devel@redhat.com
> Subject: Re: xts fuzz testing and lack of ciphertext stealing support
>=20
> On 18/07/2019 09:21, Herbert Xu wrote:
> > On Thu, Jul 18, 2019 at 09:15:39AM +0200, Ard Biesheuvel wrote:
> >>
> >> Not just the generic implementation: there are numerous synchronous
> >> and asynchronous implementations of xts(aes) in the kernel that would
> >> have to be fixed, while there are no in-kernel users that actually
> >> rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
> >> another template, i.e., cts(cbc(aes)).
> >>
> >> So retroactively redefining what xts(...) means seems like a bad idea
> >> to me. If we want to support XTS ciphertext stealing for the benefit
> >> of userland, let's do so via the existing cts template, and add
> >> support for wrapping XTS to it.
> >
> > XTS without stealing should be renamed as XEX.  Sure you can then
> > wrap it inside cts to form xts but the end result needs to be called
> > xts.
>=20
> While I fully agree here from the technical point of view,
> academically XEX, XEX* is a different mode.
> It would create even more confusion.
>=20
> Couldn't resist, but this is a nice example of what happens when academic,
> standardization, and reality meets in one place :)
>=20
> XTS is already implemented in gcrypt and OpenSSL.
> IMO all the implementation should be exactly the same.
>=20
> I agree with Herbert that the proper way is to implement ciphertext steal=
ing.
> Otherwise, it is just incomplete implementation, not a redefining XTS mod=
e!
>=20
> See the reference in generic code - the 3rd line - link to the IEEE stand=
ard.
> We do not implement it properly - for more than 12 years!
>=20

Full XTS is XEX-TCB-CTS so the proper terminology for "XTS without CTS" wou=
ld be XEX-TCB.
But the problem there is that TCB and CTS are generic terms that do not imp=
ly a specific=20
implementation for generating the tweak -or- performing the ciphertext stea=
ling.
Only the *full* XTS operation is standardized (as IEEE Std P1619).

In fact, using the current cts template around the current xts template act=
ually does NOT
implement standards compliant XTS at all, as the CTS *implementation* for X=
TS is=20
different from the one for CBC as implemented by the current CTS template.
The actual implementation of the ciphertext stealing has (or may have) a se=
curity impact,
so the *combined* operation must be cryptanalyzed and adding some random CT=
S scheme
to some random block cipher mode would be a case of "roll your own crypto" =
(i.e. bad).

=46rom that perspective - to prevent people from doing cryptographically st=
upid things -
IMHO it would be better to just pull the CTS into the XTS implementation i.=
e. make
xts natively support blocks that are not a multiple of (but >=3D) the ciphe=
r blocksize ...

> Reality check - nobody in block layer needs ciphertext stealing, we are a=
lways
> aligned to block. AF_ALG is a different story, though.

So you don't support odd sector sizes like 520 , 528, 4112, 4160 or 4224 by=
tes?
>=20
> Milan

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

--PGP_Universal_DE47C979_136D8CF4_95D90198_F11F13E0
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 10.4.2 (Build 502)

iQEVAwUBXTBMs/LgekqIHlBwAQitCwgAnm2qB2g7snxyxiWVMGyU9L6jJPFRGztj
Gmm9pjSPBUMzBwDkSPBy0So7r0wpOglScWXNBKZct90iSfeiuUJDNG5vcxTvTmE4
HSo3e4NsQIxypo7YyKTXmgx+gNAT0iagzJPHGlgxOnPbfWhG2co45+P7OKbpNWHu
Qqia2g11E4xxQt1NQUo/OYcOUY2qLqpfk3lCC25css0cO/W5EvgOKYYejl589fi6
Ibh22Z8XKZYqMxGgHg9B3G6qhg8al73upXOJoHYxvW6LggpTOHdyjbGppUQLAJ3Y
XzXB/pOqmHnkU3jaw1Ho3CViuzcrzubYFLyeAfs3nS7Boqe61FKvpQ==
=/fs+
-----END PGP SIGNATURE-----

--PGP_Universal_DE47C979_136D8CF4_95D90198_F11F13E0--


--===============5368009546455856632==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5368009546455856632==--
