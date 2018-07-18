From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Wed, 18 Jul 2018 17:46:25 +0100
Message-ID: <20180718164625.GA20360@sirena.org.uk>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2018 at 10:16:05AM +0200, Milan Broz wrote:

> So we are here again and moving INTERNAL dm-crypt functionality into
> cryptoapi.

> The TCW,LMK  IVs generator make sense only for dm-crypt=20
> for compatible old disk encryption mappings.

> I strongly disagree to move this outside of dm-crypt.

> Sorry, the last discussion was that it remains inside dm-crypt
> and it will be only registered through crypto API.

Sorry, I'm partly to blame for this in that I asked Xiongfeng to pick up
Binoy Jayan's old patch set.  I seem to have missed that particular part
of the discussion and so haven't forwarded it on to him - do you have a
link, I can't seem to see it in my local archives of the prior
discussions but they might not be complete?

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltPbuAACgkQJNaLcl1U
h9BELQf/ZVNZaHHO4wZB1eQXBBRGH3LDh1M1jHFuxM9lbL5fZmO6i9Pm0ANrcKSF
rH0flmXeHkqCM5PNKkN4DH3PCPihEw/ZSt6zW09RhwqS65R12vQnCQbVMNz2lW0u
WNhJmJcxUoZSwRMzC4mt17417CufbYXm9/rfXwDgfSDQlp71/L6yjEoHzLsVTaw4
kJMvNzmM0uHqFU+r4ssPY68hvsd40mqcXcFRtf+TdDOf35EUvh2hZ8vF2NujlXxP
xGpRYbyKEWzQREpgRkf0mdj2eTbUjkTPHvNYOOZM7J0mfQdxGBVn63ZmJlhVuPUK
9CA5VXOfVnVs9Cs1DypKjj+mJFECMQ==
=GqVU
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
