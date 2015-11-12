From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 15:02:38 +0000
Message-ID: <20151112150238.GO12392@sirena.org.uk>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151112122400.GB27454@quack.suse.cz>
 <CAMz4kuLmGfyae=PXb8keuCpkEFDdXZzvuBtUiJHRAz0P55mxXg@mail.gmail.com>
 <4436790.rotQ3a7v5c@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fjEAjMKpll6GDq3U"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4436790.rotQ3a7v5c@wuerfel>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linaro.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids


--fjEAjMKpll6GDq3U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2015 at 01:57:27PM +0100, Arnd Bergmann wrote:
> On Thursday 12 November 2015 20:51:10 Baolin Wang wrote:

> > But it maybe not enough for HW engine which can handle maybe 10M/20M
> > at one time.

> Given that you have already done measurements, can you find out how much
> you lose in overall performance with your existing patch if you artificially
> limit the maximum size to sizes like 256kb, 1MB, 4MB, ...?

It's probably also worth looking at the impact on CPU utilisation as
well as throughput in your benchmarking since the system will often not
be idle when it's doing a lot of I/O - I know you've done some
measurements in that area before, including them when looking at block
sizes might be interesting.

--fjEAjMKpll6GDq3U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWRKoNAAoJECTWi3JdVIfQkDUH/1ejU/OKvam0bizZOlfRzzUj
sUyIiR+fv0kNMvIc38Us12nb4XwI1mz3TPIGJhJ1iozHU8xI7YaZaKmq0+uyCDwS
FB8baE5gNASI+nTJ+K7g0YzEA3HkSoZi9JbRohO/IzBL7m/X+WhJoDFSunX9FKx8
2k65EGXkA5Ggpz6DqlamMpuYjS8zTr6uYhTVvhasb6m07Yxi0HYQKjHz7USR/7K7
EQMRVk/6Htc2OiH9Y87jo1n3Y3YNIF3UFr8dw5XCFIdDXuNJ1Pb6R7d5LN+AR+LG
9T0ppoj08J8zmJWC3n0BJu3RDUFPj7qqPp34uhKMur+OFpWAh0oXAgJmXRWc4iQ=
=Uc/H
-----END PGP SIGNATURE-----

--fjEAjMKpll6GDq3U--
