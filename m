From: Pavel Machek <pavel@ucw.cz>
Subject: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads on
 cellphone
Date: Mon, 6 Feb 2017 13:53:09 +0100
Message-ID: <20170206125309.GA29395@amd>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160220200432.GB22120@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, kent.overstreet@gmail.com, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com
List-Id: dm-devel.ids


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2016-02-20 21:04:32, Pavel Machek wrote:
> Hi!
>=20
> > > > > > I know it is normal to spawn 8 threads for every single functio=
n,
> > > > > ...
> > > > > > but 28 threads?
> > > > > >=20
> > > > > > root       974  0.0  0.0      0     0 ?        S<   Dec08   0:0=
0 [bioset]
> > > > > ...
> > > > >=20
> > > > > How many physical block devices do you have?
> > > > >=20
> > > > > DM is doing its part to not contribute to this:
> > > > > dbba42d8a ("dm: eliminate unused "bioset" process for each bio-ba=
sed DM device")
> > > > >=20
> > > > > (but yeah, all these extra 'bioset' threads aren't ideal)
> > > >=20
> > > > Still there in 4.4-final.
> > >=20
> > > ...and still there in 4.5-rc4 :-(.
> >=20
> > You're directing this concern to the wrong person.
> >=20
> > I already told you DM is _not_ contributing any extra "bioset" threads
> > (ever since commit dbba42d8a).
>=20
> Well, sorry about that. Note that l-k is on the cc list, so hopefully
> the right person sees it too.
>=20
> Ok, let me check... it seems that=20
> 54efd50bfd873e2dbf784e0b21a8027ba4299a3e is responsible, thus Kent
> Overstreet <kent.overstreet@gmail.com> is to blame.
>=20
> Um, and you acked the patch, so you are partly responsible.

Still there on v4.9, 36 threads on nokia n900 cellphone.

So.. what needs to be done there?
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliYcbUACgkQMOfwapXb+vJwVgCguRNJ5tyIftM9ne05sbdD5BGv
TLEAn2C2ituNTiIUdb2zBLQwbSzMsY96
=fpE9
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
