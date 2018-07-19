From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Thu, 19 Jul 2018 16:50:26 +0100
Message-ID: <20180719155026.GF27938@sirena.org.uk>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
 <CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com>
 <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com>
 <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 19, 2018 at 11:08:52PM +0900, Ard Biesheuvel wrote:

> But this will only be the case if the accelerator is capable of doing
> the IV generation and en/decryption of multiple contiguous sectors in
> a single call. Otherwise, you are just shifting work from one layer to
> the next.

> So at this point, it would be useful to clarify what exactly these
> accelerators are doing and how.

Existing hardware can definitely do the IV generation and I believe that
it can chain multiple sectors together though I'd need to confirm this,
as mentioned elsewhere in the thread the ccree driver is for one of
the relevant devices.  I've poked some relevant people.

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltQs0EACgkQJNaLcl1U
h9B4vQf/YQkCshhwsHWovL39lwKZHpo1OAVwFfEhHS0hainP8pDsnrikXQKO++hn
XVhUHjaRxdb0Zx/lHAuTVU2dd1K00VoR7udX7u++YaCBJjviVSWvZzPoxIpo+vd4
1zfjLv3YeLD+Yy7fvLkJiVf114bBWfz/Y4sSiNUhVAxL3AgcRgs36ZA1HS+TghJX
bs98y1sGwT96emHDT55S7t2jP8fYdD6mJBKvxcS+MT046HDOSEv4+ZtylOI3Nl8w
Uz7udiikFKRtKwlaPX8YGEnUEqJyi8uoquNC/QVo8yYCxsVx+J/Go6z//EjtAlRD
+djfP5QXtifKs3spBqRcKZm4gPpyWg==
=ZoTL
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
