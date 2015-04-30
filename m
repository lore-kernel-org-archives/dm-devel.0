From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is
 unregistered.
Date: Thu, 30 Apr 2015 10:06:31 +1000
Message-ID: <20150430100631.25dfefe5@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150427141222.5dac22f1@notabene.brown>
	<CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
	<20150429072530.39d38b00@notabene.brown>
	<20150429133512.GA4436@lst.de>
	<20150429160258.GK17717@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AuoirUB0FjIyO29ieaMiDxl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429160258.GK17717@twins.programming.kicks-ass.net>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/AuoirUB0FjIyO29ieaMiDxl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2015 18:02:58 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Wed, Apr 29, 2015 at 03:35:12PM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 29, 2015 at 07:25:30AM +1000, NeilBrown wrote:
> > > As bdi_set_min_ratio doesn't touch bdi->dev, there seems to be no nee=
d for
> > > the test, or the warning.
> > >=20
> > > I wonder if it would make sense to move the bdi_set_min_ratio() call =
to
> > > bdi_destroy, and discard bdi_unregister??
> > > There is a comment which suggests bdi_unregister might be of use late=
r, but
> > > it might be best to have a clean slate in which to add whatever might=
 be
> > > needed??
> >=20
> > This seems fine to me from the block dev point of view.  I don't really
> > understand the bdi_min_ratio logic, but Peter might have a better idea.
>=20
> Ah, that was a bit of digging, I've not looked at that in ages :-)
>=20
> So if you look at bdi_dirty_limit()'s comment:
>=20
>  * The bdi's share of dirty limit will be adapting to its throughput and
>  * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
>=20
> So the min_ratio is a minimum guaranteed fraction of the total
> throughput.
>=20
> Now the problem before commit ccb6108f5b0b ("mm/backing-dev.c: reset bdi
> min_ratio in bdi_unregister()") was that since bdi_set_min_ratio()
> keeps a global sum of bdi->min_ratio, you need to subtract from said
> global sum when taking the BDI away. Otherwise we loose/leak a fraction
> of the total throughput available (to the other BDIs).
>=20
> Which is what that bdi_set_min_ratio(bdi, 0) in unregister does. It
> resets the min_ratio for the bdi being taken out and frees up the min
> allocated bandwidth for the others.
>=20
> So I think moving that do destroy would be fine; assuming the delay
> between unregister and destroy is typically 'short'. Because without
> that you can 'leak' this min ratio for extended periods which means the
> bandwidth is unavailable for other BDIs.
>=20
> Does that make sense?

Your assessment is almost exactly what I had come up with, so it definitely
makes sense :-)
'destroy' does come very shortly after 'unregister' (and immediately before
'blk_put_queue' which actually frees the struct).  However the driving force
for this patch was a desire to move blk_cleanup_queue(), which calls
'destroy', earlier.  So the net result is that bdi_set_min_ratio will be
called slightly sooner.

Thanks,
NeilBrown

--Sig_/AuoirUB0FjIyO29ieaMiDxl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUFyCDnsnt1WYoG5AQJ0Lw//ZxUnM4HoQsw9GQO10dRfzMSHTIGXSsMp
0kjDNJxNBp2UDtKQybQ36hYqFWRS8jYmxhJwz8F528WRXkk7OoUBn6W9+TRQFyT9
01fkbHEX96yXhuNVpRvAmjbfomAyuutrtbXBLC+TVxJ+bo/ipLgj8nP7q4pTmt1k
wfu9xstZCdECHSQpEMgLmx2oTUDRglqKX9wu1jO2RJTT3xB1KNSx3vDoOSc7hCsU
lYQ8fKXCX+PrmQ+kvA77tRBPnvzG28zzUXwY+A5SnUKmWcE2frevu6vzY482LWSF
E9pt9wBlRdiC1f/sJv0ctrU6V2C7O1sO8eADFYD5cQ3tdr2W3d1UWbCNwDeZ/oKI
T21tBufavN+9mw3V7OTylqMrdNZwq+SE3Sfc44c8/kpEwDtQZVOU502hX8O9Wr5d
9gN23f86iGOGT8dc0/FUYPa9g1AYeLJk5I7KmqvdcJs7qWl40BtZRDHrYkiTkqQX
agilvIoGkVauUjZwomUXVndaOSbG76AHUXBZpuGW33+xdts59mDk5ThPTWnRPqgZ
glcogXis56wBeWKczCEdp/7CTxzuoVl94v/BzEdcQZGwZ3HiMqR8IayAu9nObgmU
agOm4bLickinQ8hu8ugwmbY8xHS0fEaBh21FSQR9cktqq/ZFyOGbxo1wPuUbDbuB
3hTqYFE5J98=
=u3qF
-----END PGP SIGNATURE-----

--Sig_/AuoirUB0FjIyO29ieaMiDxl--
