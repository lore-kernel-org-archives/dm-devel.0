From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Thu, 19 Jul 2018 14:30:04 +0100
Message-ID: <20180719133004.GB27938@sirena.org.uk>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
 <20180718164625.GA20360@sirena.org.uk>
 <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
 <cda1d3de-3f21-2dfc-0423-c1cf456838b4@huawei.com>
 <CAK8P3a2oubqRKg1tnoG6CsmUs-U5Ab6q5rwpfg08PRNJLhEjEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2oubqRKg1tnoG6CsmUs-U5Ab6q5rwpfg08PRNJLhEjEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 19, 2018 at 10:50:12AM +0200, Arnd Bergmann wrote:

> There seems to be some support for at least essiv(aes) in
> drivers/crypto/ccree/cc_cipher.c, is that compatible with your essiv(*)
> template, or is that something else?

Yes, that is in fact a driver for one of the pieces of hardware that
was one of the prompts to do this work.

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltQklsACgkQJNaLcl1U
h9DKogf9FafVKu2CEVULfjn/Tjw2Po/LC5FSUNn2BywvQ6HZ/i9qFnVLLXQqxZgd
3FwGgBKTWr7wQt3SyB4PifBGVUdHWaCVEPxaITgdmfKaUihuXfDrTt7BOSn3K0xQ
2RDPZW7+3M4/S/brNpAd9MuxT7BzXD8YSMal5RyuCvJwcSXhvBhe+RApKDew21sm
L7pKZ9Tf/qFujYDq6RLMu8bSbxftuT65hABDp5/lS8p8dJCWo1OrVmhwqtjjf1BA
o5Bxig7tCwdQBtqiOtpJa04UadA51uUvsxbyDFx9e/Otd3ndsO3V63ZqYoFnVd1x
lvBYFv+FptHA6bpX7j6AGAUFgvz9aQ==
=rdnV
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
