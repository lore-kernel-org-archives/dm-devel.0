From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [PATCH v3] block: trace completion of all bios.
Date: Tue, 28 Mar 2017 10:42:12 +1100
Message-ID: <87tw6e70dn.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name> <20170322125149.GA29606@infradead.org> <87shm4a4lt.fsf@notabene.neil.brown.name> <20170323104331.GA16903@ming.t460p> <87fui3a65o.fsf@notabene.neil.brown.name> <20170327090308.GA11757@infradead.org> <87zig76oca.fsf@notabene.neil.brown.name> <20170327171421.GA464@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170327171421.GA464@infradead.org>
Sender: linux-block-owner@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27 2017, Christoph Hellwig wrote:

> On Mon, Mar 27, 2017 at 08:49:57PM +1100, NeilBrown wrote:
>> On Mon, Mar 27 2017, Christoph Hellwig wrote:
>>=20
>> > I don't really like the flag at all.  I'd much prefer a __bio_endio
>> > with a 'bool trace' flag.  Also please remove the manual tracing in
>> > dm.=C4=8B.  Once that is done I suspect we can also remove the
>> > block_bio_complete export.
>>=20
>> Can you say why you don't like it?
>
> It uses up a precious bit in the bio for something that should be state
> that can be determined in the caller at compile time.

I've already demonstrated that the bit is not "precious" at all.  I have
shown how I could easily give you 20 unused flag bits without increasing
the size of struct bio.
Yes, the state could be determined in the caller at compiler time.  That
would require developers to make the correct choice between two very
similar interfaces, where the consequences of an correct choice are not
immediately obvious.
I think that spending one bit (out of 20) to relieve developers of the
burden of choice (and to spare as all of the consequences of wrong
choice) is a price worth paying.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljZo1QACgkQOeye3VZi
gbl2Vg//YZxdU8m1uADBo4gu29oxcCeVPfVUV6p1yIGFaE/9IPe6tpdh9+UqLQZR
yfO/CQN3g15sXP1Ca+aLy465ArgpLJPDcDGG54NLa6cm3qv2m11ur1bT0xozfSnE
mJMVv5EpCKUbPGuP2uJVuRwsAGzgpIlT4VwsCTJKonYa5zin2rRjtM5g9J5gFOz+
XtFIu016mcLkBXLCyu07XVx1V9VecKZbk4Oo8irb+6Uzk/xt5fNEFLcFDUOsb3ll
hoXyAbEUSR/a1Ao9uxMH5OQirPc5aTgyCjJ6eHY7gXHPgCFLoBZ6SIJ/mvQRVRH4
639bMabPusYMDUnh4sSZ1i24FJ21i36QpTMOY2t7gAWJoL5cdQirASGsR3UjFMqM
tB/7p/Uj7yTv7p4tg6HyahBjYdB2n420viqBaSIVTSUKD1aOf4b9wxp2chUgjKk4
o4sEPjoG5B0ol5s8tvJ2tMnc+VYK7DkerEsTeog9Ex5u/HIgc/q3dC6fJkFYsHOG
0KfrCmBruFhzdFE0mLpSNx/zgKJMGqIfYFpMBrBtngjzCCrlljXeDyC7USuVBFnM
QzxVFc5XnDRRVPPuyt/s6uYn17UAgOOYP33i1/zPB9pzdzs9q4GTIHgtkpxfKJYZ
mCfUHt8tKT9QMa0LS6XUA+8UVH6kwFS6rAaRa+1Hf2phVY7WA40=
=xkDo
-----END PGP SIGNATURE-----
--=-=-=--
