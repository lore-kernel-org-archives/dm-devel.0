From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Fri, 20 Jul 2018 13:32:46 +0100
Message-ID: <20180720123246.GE10784@sirena.org.uk>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
 <CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com>
 <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com>
 <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
 <20180719155026.GF27938@sirena.org.uk>
 <CAKv+Gu_mb26HRi==5oeQyZ7ZOgifg7RUNt2c2V=tTqvFrMYq5g@mail.gmail.com>
 <20180720114509.GA10784@sirena.org.uk>
 <CAKv+Gu8=M-EE11dZwcAzy1ZrnEoz=nF++v9bneY2SUq+e217Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8=M-EE11dZwcAzy1ZrnEoz=nF++v9bneY2SUq+e217Rg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2018 at 09:23:15PM +0900, Ard Biesheuvel wrote:
> On 20 July 2018 at 20:45, Mark Brown <broonie@kernel.org> wrote:

> > I have to confess I didn't look at their in tree driver, looking briefly
> > now it looks awfully like the hardware should be able to chain IV
> > generation together with encryption without bothering the CPU which
> > would be good enough.

> Indeed interesting. But afaict, that would still mean that the IV
> generation transform and the payload transform would be expressed as a
> single crypto algorithm, e.g., 'dm(essiv-foo(aes),gcm(aes)), or the DM
> layer would still need to be involved in sequencing one operation
> after the other, and I don't think any of that support is in the
> current series. But I'm just a drive by reviewer here, so please
> correct me if I am wrong.

Yeah, I'm also a bit of a drive by here and not seeing how the two are
joined up at present, but it may be a case of needing to get this and/or
other drivers fixed rather than the hardware lacking the capability.

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltR1m0ACgkQJNaLcl1U
h9Ddagf+L3Ie/NQmFGA4skJRx+gcZZmaz+pVxtlZZIW0wKDG6zBvZb5KOBH7ew6k
eWoAkhOVbYLQMthitWB94veldP3pAd35BcriA5yM/LEN/qFNtms/Gdqte6DWPt1m
5qnXpK8vekpQz3nI4Y2C7X/sx0XHls6FCrR5vAZ/fb5/Rth4TVCt7EAnsXYWW/Lm
oBqhugqTDFe9c3RusH/g1U006/VKFCdQ8tn/aKS/sdoEgQtaav2si8pSiM1IvOf1
pfWAFqdNs9pMX3rXVxcP7Nl5Bn9dCR5kD8+vmA9bJ9dzThKrxOY+RKiYQx/3aRhq
AGkgAnMOIWf2mDkITYWkRRv0XiWAwg==
=FeZe
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
