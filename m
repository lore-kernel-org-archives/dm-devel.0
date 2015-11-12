From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 10:04:22 +0000
Message-ID: <20151112100422.GM12392@sirena.org.uk>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111181813.GD12236@redhat.com>
 <CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2015 at 04:20:41PM +0800, Baolin Wang wrote:

> 3. perforamence data
> It is just a simple dd test result, and will provide the formal report
> in future. But from the simple test, we can see the improvement.

It's probably also worth pointing out that Qualcomm have been shipping
an out of tree implementation of this as a separate module in their BSP
(originally written by Danesh Garg who's on this thread):

   https://android.googlesource.com/kernel/msm/+/android-msm-dory-3.10-kitkat-wear/drivers/md/dm-req-crypt.c

Android now wants to encrypt phones and tablets by default and have been
seeing substantial performance hits as a result, we can try to get
people to share performance data from productionish systems but it might
be difficult.

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWRGQlAAoJECTWi3JdVIfQ7ZoH/i6/2JElYTetwRMdire3tBjM
7O0w4z0tAp6MYlwhwam8u8KZV3b9VBkxaG5e4EqSqz04KbbKsfcMSQyMGB1Gig9W
fpCdMr8qJdlFi3g98jTFzuJkXncD1SKD3Pm58faDHF5z5GFFh2ySH8NxN6Oki+Ih
43AvuAYhiFI6kSJ/kqHBtiVy39bm/TUW0UR/+F4g4YgGfM/LIN6s88rvOcn+JRva
KcFKDKiK8s5l14fdn1iKl6owLs3gUfdjgXhYCa+dWEG5KB82SkBN/Z3kf53GU8YR
CGx7+LtzTmehB5NRhFUAD6gx6cZxiRuuPgTIVJkQ8x7A2yFGUlKvZaksh8TiXh4=
=EaTi
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
