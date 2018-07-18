From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Wed, 18 Jul 2018 18:47:45 +0100
Message-ID: <20180718174745.GC20360@sirena.org.uk>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
 <20180718164625.GA20360@sirena.org.uk>
 <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: dm-devel.ids


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2018 at 07:17:45PM +0200, Milan Broz wrote:

> I think the last iteration was this patch
> https://lore.kernel.org/lkml/1498106510-19793-2-git-send-email-binoy.jayan@linaro.org/

Thanks!  I'd got v5 but v6 went AWOL for some reason :(

> 2) If the reason is performance, please provide numbers with the patch.
> What I see now is that the performance is almost the same. So why you are doing it?
> Any real hw that benefits from it?

The main focus was performance with accelerators, currently we can't use
ESSIV acceleration which is implemented by some hardware.  Xiongfeng, we
probably need to discuss offline before sharing any actual numbers for
the hardware accelerated case since people can be sensitive about how
those are shared.  Software only benchmarks are only really relevant in
showing that this won't harm existing users.

Some of the relevant systems are somewhat CPU constrained so even if the
I/O performance remains fairly consistent with the accelerators in play
it can still be a win if it frees up a useful amount of CPU for other
purposes.  That'd mean CPU usage is probably interesting to benchmark
also though I don't know that the systems Xiongfeng has access to are
particularly good models there.

> I added 4k sector support in dmcrypt and IMO this helps much more than
> some hw IV accelerations (AFAIK is is already used in some mainframe
> accelerators this way because of performance).

Right, that does help too (and an out of tree variation of this was one
of the original sources of this work).

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltPfUAACgkQJNaLcl1U
h9B8qgf+LfQM8Qe1bjGgClEG98e6vLvtPzUtMpCCpORZ79FiFTdVXzv+Bw0lhg2F
OrNDPjeY0tFbjUqr4LcwVFMFgt/wdfiiwqDB9Kho5SinTHSjS+fagqEA5hgFCLOF
7gKLxNbfK029N9sjcxq991bE58pLbXsV1GZrhO/KE3laja5uvY+lyb9EoNCU3/L0
d2L1GdJ9dm3Kue8uFNuAfnWEekBrUa2oyxV1JCFAD9AhDADXeXkpxtWH3RZMru8P
mU+hHoYtOZ/AZOfWMn1sM2N6mjuGfWJWBNuWpc21PxAj7IyJJ7hEEeoXEshhC/OE
hFdYPmNkjcsBO8tcM7IS1Yr788xbXg==
=z8lU
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
