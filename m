From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] new patchset to eliminate DM's use of   BIOSET_NEED_RESCUER
Date: Wed, 22 Nov 2017 15:00:51 +1100
Message-ID: <87bmjv0xos.fsf@notabene.neil.brown.name>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name> <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com> <20171121225119.GA19630@redhat.com> <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21 2017, Mikulas Patocka wrote:

> On Tue, 21 Nov 2017, Mike Snitzer wrote:
>
>> On Tue, Nov 21 2017 at  4:23pm -0500,
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>=20
>> > This is not correct:
>> >=20
>> >    2206 static void dm_wq_work(struct work_struct *work)
>> >    2207 {
>> >    2208         struct mapped_device *md =3D container_of(work, struct=
 mapped_device, work);
>> >    2209         struct bio *bio;
>> >    2210         int srcu_idx;
>> >    2211         struct dm_table *map;
>> >    2212
>> >    2213         if (!bio_list_empty(&md->rescued)) {
>> >    2214                 struct bio_list list;
>> >    2215                 spin_lock_irq(&md->deferred_lock);
>> >    2216                 list =3D md->rescued;
>> >    2217                 bio_list_init(&md->rescued);
>> >    2218                 spin_unlock_irq(&md->deferred_lock);
>> >    2219                 while ((bio =3D bio_list_pop(&list)))
>> >    2220                         generic_make_request(bio);
>> >    2221         }
>> >    2222
>> >    2223         map =3D dm_get_live_table(md, &srcu_idx);
>> >    2224
>> >    2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)=
) {
>> >    2226                 spin_lock_irq(&md->deferred_lock);
>> >    2227                 bio =3D bio_list_pop(&md->deferred);
>> >    2228                 spin_unlock_irq(&md->deferred_lock);
>> >    2229
>> >    2230                 if (!bio)
>> >    2231                         break;
>> >    2232
>> >    2233                 if (dm_request_based(md))
>> >    2234                         generic_make_request(bio);
>> >    2235                 else
>> >    2236                         __split_and_process_bio(md, map, bio);
>> >    2237         }
>> >    2238
>> >    2239         dm_put_live_table(md, srcu_idx);
>> >    2240 }
>> >=20
>> > You can see that if we are in dm_wq_work in __split_and_process_bio, w=
e=20
>> > will not process md->rescued list.
>>=20
>> Can you elaborate further?  We cannot be "in dm_wq_work in
>> __split_and_process_bio" simultaneously.  Do you mean as a side-effect
>> of scheduling away from __split_and_process_bio?
>>=20
>> The more detail you can share the better.
>
> Suppose this scenario:
>
> * dm_wq_work calls __split_and_process_bio
> * __split_and_process_bio eventually reaches the function snapshot_map
> * snapshot_map attempts to take the snapshot lock
>
> * the snapshot lock could be released only if some bios submitted by the=
=20
> snapshot driver to the underlying device complete
> * the bios submitted to the underlying device were already offloaded by=20
> some other task and they are waiting on the list md->rescued
> * the bios waiting on md->rescued are not processed, because dm_wq_work i=
s=20
> blocked in snapshot_map (called from __split_and_process_bio)

Yes, I think you are right.=20

I think the solution is to get rid of the dm_offload() infrastructure
and make it not necessary.
i.e. discard my patches
    dm: prepare to discontinue use of BIOSET_NEED_RESCUER
and
    dm: revise 'rescue' strategy for bio-based bioset allocations

And build on "dm: ensure bio submission follows a depth-first tree walk"
which was written after those and already makes dm_offload() less
important.

Since that "depth-first" patch, every request to the dm device, after
the initial splitting, allocates just one dm_target_io structure, and
makes just one __map_bio() call, and so will behave exactly the way
generic_make_request() expects and copes with - thus avoiding awkward
dependencies and deadlocks.  Except....

a/ If any target defines ->num_write_bios() to return >1,
   __clone_and_map_data_bio() will make multiple calls to alloc_tio()
   and __map_bio(), which might need rescuing.
   But no target defines num_write_bios, and none have since it was
   removed from dm-cache 4.5 years ago.
   Can we discard num_write_bios??

b/ If any target sets any of num_{flush,discard,write_same,write_zeroes}_bi=
os
   to a value > 1, then __send_duplicate_bios() will also make multiple
   calls to alloc_tio() and __map_bio().
   Some do.
     dm-cache-target:  flush=3D2
     dm-snap: flush=3D2
     dm-stripe: discard, write_same, write_zeroes all set to 'stripes'.

These will only be a problem if the second (or subsequent) alloc_tio()
blocks waiting for an earlier allocation to complete.  This will only
be a problem if multiple threads are each trying to allocate multiple
dm_target_io from the same bioset at the same time.
This is rare and should be easier to address than the current
dm_offload() approach.=20
One possibility would be to copy the approach taken by
crypt_alloc_buffer() which needs to allocate multiple entries from a
mempool.
It first tries the with GFP_NOWAIT.  If that fails it take a mutex and
tries with GFP_NOIO.  This mean only one thread will try to allocate
multiple bios at once, so there can be no deadlock.

Below are two RFC patches.  The first removes num_write_bios.
The second is incomplete and makes a stab are allocating multiple bios
at once safely.
A third would be needed to remove dm_offload() etc... but I cannot quite
fit that in today - must be off.

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Wed, 22 Nov 2017 14:25:18 +1100
Subject: [PATCH] DM: remove num_write_bios target interface.

No target provides num_write_bios and none has done
since 2013.
Having the possibility of num_write_bios > 1 complicates
bio allocation.
So remove the interface and assume there is only one bio
needed.
If a target ever needs more, it must provide a suitable
bioset and allocate itself based on its particular needs.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm.c               | 22 ++++------------------
 include/linux/device-mapper.h | 15 ---------------
 2 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b20febd6cbc7..8c1a05609eea 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1323,27 +1323,13 @@ static int __clone_and_map_data_bio(struct clone_in=
fo *ci, struct dm_target *ti,
 {
 	struct bio *bio =3D ci->bio;
 	struct dm_target_io *tio;
=2D	unsigned target_bio_nr;
=2D	unsigned num_target_bios =3D 1;
 	int r =3D 0;
=20
=2D	/*
=2D	 * Does the target want to receive duplicate copies of the bio?
=2D	 */
=2D	if (bio_data_dir(bio) =3D=3D WRITE && ti->num_write_bios)
=2D		num_target_bios =3D ti->num_write_bios(ti, bio);
=2D
=2D	for (target_bio_nr =3D 0; target_bio_nr < num_target_bios; target_bio_n=
r++) {
=2D		tio =3D alloc_tio(ci, ti, target_bio_nr);
=2D		tio->len_ptr =3D len;
=2D		r =3D clone_bio(tio, bio, sector, *len);
=2D		if (r < 0) {
=2D			free_tio(tio);
=2D			break;
=2D		}
+	tio =3D alloc_tio(ci, ti, 0);
+	tio->len_ptr =3D len;
+	r =3D clone_bio(tio, bio, sector, *len);
+	if (r >=3D 0)
 		__map_bio(tio);
=2D	}
=2D
 	return r;
 }
=20
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a5538433c927..5a68b366e664 100644
=2D-- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -220,14 +220,6 @@ struct target_type {
 #define DM_TARGET_WILDCARD		0x00000008
 #define dm_target_is_wildcard(type)	((type)->features & DM_TARGET_WILDCARD)
=20
=2D/*
=2D * Some targets need to be sent the same WRITE bio severals times so
=2D * that they can send copies of it to different devices.  This function
=2D * examines any supplied bio and returns the number of copies of it the
=2D * target requires.
=2D */
=2Dtypedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct b=
io *bio);
=2D
 /*
  * A target implements own bio data integrity.
  */
@@ -291,13 +283,6 @@ struct dm_target {
 	 */
 	unsigned per_io_data_size;
=20
=2D	/*
=2D	 * If defined, this function is called to find out how many
=2D	 * duplicate bios should be sent to the target when writing
=2D	 * data.
=2D	 */
=2D	dm_num_write_bios_fn num_write_bios;
=2D
 	/* target specific data */
 	void *private;
=20
=2D-=20
2.14.0.rc0.dirty


=2D----------------------------------
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8c1a05609eea..8762661df2ef 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1265,8 +1265,7 @@ static int clone_bio(struct dm_target_io *tio, struct=
 bio *bio,
 }
=20
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
=2D				      struct dm_target *ti,
=2D				      unsigned target_bio_nr)
+				      struct dm_target *ti)
 {
 	struct dm_target_io *tio;
 	struct bio *clone;
@@ -1276,34 +1275,66 @@ static struct dm_target_io *alloc_tio(struct clone_=
info *ci,
=20
 	tio->io =3D ci->io;
 	tio->ti =3D ti;
=2D	tio->target_bio_nr =3D target_bio_nr;
+	tio->target_bio_nr =3D 0;
=20
 	return tio;
 }
=20
=2Dstatic void __clone_and_map_simple_bio(struct clone_info *ci,
=2D				       struct dm_target *ti,
=2D				       unsigned target_bio_nr, unsigned *len)
+static void alloc_multiple_bios(struct bio_list *blist, struct clone_info =
*ci,
+				struct dm_target *ti, unsigned num_bios)
 {
=2D	struct dm_target_io *tio =3D alloc_tio(ci, ti, target_bio_nr);
=2D	struct bio *clone =3D &tio->clone;
+	int try;
=20
=2D	tio->len_ptr =3D len;
+	for (try =3D 0; try < 2; try++) {
+		int bio_nr;
+		struct bio *bio;
+
+		if (try)
+			mutex_lock(&ci->md->table_devices_lock);
+		for (bio_nr =3D 0; bio_nr < num_bios; bio_nr++) {
+			bio =3D bio_alloc_bioset(try ? GFP_NOIO : GFP_NOWAIT,
+					       0, ci->md->bs);
+			if (bio) {
+				struct dm_target_io *tio;
+				bio_list_add(blist, bio);
+				tio =3D container_of(bio, struct dm_target_io, clone);
=20
=2D	__bio_clone_fast(clone, ci->bio);
=2D	if (len)
=2D		bio_setup_sector(clone, ci->sector, *len);
+				tio->io =3D ci->io;
+				tio->ti =3D ti;
+				tio->target_bio_nr =3D bio_nr;
+			} else
+				break;
+		}
+		if (try)
+			mutex_unlock(&ci->md->table_devices_lock);
+		if (bio_nr =3D=3D num_bios)
+			return;
=20
=2D	__map_bio(tio);
+		while ((bio =3D bio_list_pop(blist)) !=3D NULL)
+			bio_put(bio);
+	}
 }
=20
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target =
*ti,
 				  unsigned num_bios, unsigned *len)
 {
=2D	unsigned target_bio_nr;
+	struct bio_list blist =3D BIO_EMPTY_LIST;
+	struct bio *bio;
=20
=2D	for (target_bio_nr =3D 0; target_bio_nr < num_bios; target_bio_nr++)
=2D		__clone_and_map_simple_bio(ci, ti, target_bio_nr, len);
+	if (num_bios =3D=3D 1)
+		bio_list_add(&blist, &alloc_tio(ci, ti)->clone);
+	else
+		alloc_multiple_bios(&blist, ci, ti, num_bios);
+
+	while ((bio =3D bio_list_pop(&blist)) !=3D NULL) {
+		struct dm_target_io *tio =3D container_of(
+			bio, struct dm_target_io, clone);
+		tio->len_ptr =3D len;
+		__bio_clone_fast(bio, ci->bio);
+		if (len)
+			bio_setup_sector(bio, ci->sector, *len);
+		__map_bio(tio);
+	}
 }
=20
 static int __send_empty_flush(struct clone_info *ci)
@@ -1325,7 +1356,7 @@ static int __clone_and_map_data_bio(struct clone_info=
 *ci, struct dm_target *ti,
 	struct dm_target_io *tio;
 	int r =3D 0;
=20
=2D	tio =3D alloc_tio(ci, ti, 0);
+	tio =3D alloc_tio(ci, ti);
 	tio->len_ptr =3D len;
 	r =3D clone_bio(tio, bio, sector, *len);
 	if (r >=3D 0)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAloU9nQACgkQOeye3VZi
gbnSdBAAgWDMhM3VSmYJPtAd0HVEbEoBaQfcp5MbkkbD7tLrl2SNNogRNvumspor
c/8PHZbBnQqDCAenE9qUXhaYCA6ZHsH1C7e6Ad2saI6VbHC2xEaDs4R1VrBlh+qo
mXaUsHUUqNyxwEUEywKHA9yKXI2fQXBQgL6JGFR+hBCDuvzwZpyWKNIJboBOY0eR
uS9YHY+G2GOWoDGYzo4Up9eiB9Vcsf8NHOUiF3+otjLh7AnHZs96QxjWVAGKu3Lb
FTWO6R7h4HJRVQ1sgqQe/DHASYpw18q4XTWxmeNV3VwCMwUr4ZDrVkYeELTF9Lrb
pAt4tIGK+RV4EBX6uQN1SdJMiM5ISPCxJOoByKQQzknh+RjJvCblmbQuSieycVDL
Z7h7fukm9fW1r2XJ11IdtOuEmr6pYnUFFwnokCyUJz4b5Tu5UZjJtRv4kxxA3sTa
/LEuXPHp3oHpt9JHchkf9qTOlBWA0oI04fczkJF9V55aQtZ+WUxENSX6MiBEgdiS
QvHHuO9u8akie/z18t6zBx/D8lWipt4sBKeTgcGaNeFnUTB90YjtYP+cCpCC6sGO
4HK1FW0OEU5We+hZvWz+yjhqXPCRUQSeJimgOVSdpTMTMrb4NkeYOllFjb09byqH
qKtSr1YXYZKRmE7kPQJ1STjguO115FQbhq+29jHfsAjOF/ZEVm0=
=RUCX
-----END PGP SIGNATURE-----
--=-=-=--
