From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] new patchset to eliminate DM's use of BIOSET_NEED_RESCUER
Date: Thu, 23 Nov 2017 16:12:46 +1100
Message-ID: <87o9ntzigh.fsf@notabene.neil.brown.name>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name> <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com> <20171121225119.GA19630@redhat.com> <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com> <87bmjv0xos.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 22 2017, Mikulas Patocka wrote:

> On Wed, 22 Nov 2017, NeilBrown wrote:
>
>> On Tue, Nov 21 2017, Mikulas Patocka wrote:
>>=20
>> > On Tue, 21 Nov 2017, Mike Snitzer wrote:
>> >
>> >> On Tue, Nov 21 2017 at  4:23pm -0500,
>> >> Mikulas Patocka <mpatocka@redhat.com> wrote:
>> >>=20
>> >> > This is not correct:
>> >> >=20
>> >> >    2206 static void dm_wq_work(struct work_struct *work)
>> >> >    2207 {
>> >> >    2208         struct mapped_device *md =3D container_of(work, str=
uct mapped_device, work);
>> >> >    2209         struct bio *bio;
>> >> >    2210         int srcu_idx;
>> >> >    2211         struct dm_table *map;
>> >> >    2212
>> >> >    2213         if (!bio_list_empty(&md->rescued)) {
>> >> >    2214                 struct bio_list list;
>> >> >    2215                 spin_lock_irq(&md->deferred_lock);
>> >> >    2216                 list =3D md->rescued;
>> >> >    2217                 bio_list_init(&md->rescued);
>> >> >    2218                 spin_unlock_irq(&md->deferred_lock);
>> >> >    2219                 while ((bio =3D bio_list_pop(&list)))
>> >> >    2220                         generic_make_request(bio);
>> >> >    2221         }
>> >> >    2222
>> >> >    2223         map =3D dm_get_live_table(md, &srcu_idx);
>> >> >    2224
>> >> >    2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->fla=
gs)) {
>> >> >    2226                 spin_lock_irq(&md->deferred_lock);
>> >> >    2227                 bio =3D bio_list_pop(&md->deferred);
>> >> >    2228                 spin_unlock_irq(&md->deferred_lock);
>> >> >    2229
>> >> >    2230                 if (!bio)
>> >> >    2231                         break;
>> >> >    2232
>> >> >    2233                 if (dm_request_based(md))
>> >> >    2234                         generic_make_request(bio);
>> >> >    2235                 else
>> >> >    2236                         __split_and_process_bio(md, map, bi=
o);
>> >> >    2237         }
>> >> >    2238
>> >> >    2239         dm_put_live_table(md, srcu_idx);
>> >> >    2240 }
>> >> >=20
>> >> > You can see that if we are in dm_wq_work in __split_and_process_bio=
, we=20
>> >> > will not process md->rescued list.
>> >>=20
>> >> Can you elaborate further?  We cannot be "in dm_wq_work in
>> >> __split_and_process_bio" simultaneously.  Do you mean as a side-effect
>> >> of scheduling away from __split_and_process_bio?
>> >>=20
>> >> The more detail you can share the better.
>> >
>> > Suppose this scenario:
>> >
>> > * dm_wq_work calls __split_and_process_bio
>> > * __split_and_process_bio eventually reaches the function snapshot_map
>> > * snapshot_map attempts to take the snapshot lock
>> >
>> > * the snapshot lock could be released only if some bios submitted by t=
he=20
>> > snapshot driver to the underlying device complete
>> > * the bios submitted to the underlying device were already offloaded b=
y=20
>> > some other task and they are waiting on the list md->rescued
>> > * the bios waiting on md->rescued are not processed, because dm_wq_wor=
k is=20
>> > blocked in snapshot_map (called from __split_and_process_bio)
>>=20
>> Yes, I think you are right.=20
>>=20
>> I think the solution is to get rid of the dm_offload() infrastructure
>> and make it not necessary.
>> i.e. discard my patches
>>     dm: prepare to discontinue use of BIOSET_NEED_RESCUER
>> and
>>     dm: revise 'rescue' strategy for bio-based bioset allocations
>>=20
>> And build on "dm: ensure bio submission follows a depth-first tree walk"
>> which was written after those and already makes dm_offload() less
>> important.
>>=20
>> Since that "depth-first" patch, every request to the dm device, after
>> the initial splitting, allocates just one dm_target_io structure, and
>> makes just one __map_bio() call, and so will behave exactly the way
>> generic_make_request() expects and copes with - thus avoiding awkward
>> dependencies and deadlocks.  Except....
>>=20
>> a/ If any target defines ->num_write_bios() to return >1,
>>    __clone_and_map_data_bio() will make multiple calls to alloc_tio()
>>    and __map_bio(), which might need rescuing.
>>    But no target defines num_write_bios, and none have since it was
>>    removed from dm-cache 4.5 years ago.
>>    Can we discard num_write_bios??
>>=20
>> b/ If any target sets any of num_{flush,discard,write_same,write_zeroes}=
_bios
>>    to a value > 1, then __send_duplicate_bios() will also make multiple
>>    calls to alloc_tio() and __map_bio().
>>    Some do.
>>      dm-cache-target:  flush=3D2
>>      dm-snap: flush=3D2
>>      dm-stripe: discard, write_same, write_zeroes all set to 'stripes'.
>>=20
>> These will only be a problem if the second (or subsequent) alloc_tio()
>> blocks waiting for an earlier allocation to complete.  This will only
>> be a problem if multiple threads are each trying to allocate multiple
>> dm_target_io from the same bioset at the same time.
>> This is rare and should be easier to address than the current
>> dm_offload() approach.=20
>> One possibility would be to copy the approach taken by
>> crypt_alloc_buffer() which needs to allocate multiple entries from a
>> mempool.
>> It first tries the with GFP_NOWAIT.  If that fails it take a mutex and
>> tries with GFP_NOIO.  This mean only one thread will try to allocate
>> multiple bios at once, so there can be no deadlock.
>>=20
>> Below are two RFC patches.  The first removes num_write_bios.
>> The second is incomplete and makes a stab are allocating multiple bios
>> at once safely.
>> A third would be needed to remove dm_offload() etc... but I cannot quite
>> fit that in today - must be off.
>>=20
>> Thanks,
>> NeilBrown
>
> Another problem is this:
>
> struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO, md->queue->bio_split);
> bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
> bio_chain(b, bio);
>
> What if it blocks because the bioset is exhausted?
>
> The code basically builds a chain of bios of unlimited length (suppose fo=
r=20
> example a case when we are splitting on every sector boundary, so there=20
> will be one bio for every sector in the original bio), it could exhaust=20
> the bioset easily.
>
> It would be better to use mechanism from md-raid that chains all the=20
> sub-bios to the same master bio and doesn't create long chains of bios:
>
>         if (max_sectors < bio_sectors(bio)) {
>                 struct bio *split =3D bio_split(bio, max_sectors,
>                                               gfp, conf->bio_split);
>                 bio_chain(split, bio);
>                 generic_make_request(bio);
>                 bio =3D split;
>                 r1_bio->master_bio =3D bio;
>                 r1_bio->sectors =3D max_sectors;
>         }
>
> Mikulas

Yes, you are right something like that would be better.
Also send_changing_extent_only allocates bios in a loop which can cause
problems.
I think we need to get __split_and_process_non_flush(), in all its
branches, to check if len is too large for a single request, and if it
is, create a clone for the prefix, attached that to the ci and map it,
advance the original bio, and call generic_make_request on it.
That shouldn't be too hard, but it is a change that would touch a few
places.

I'll see if I can write something.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAloWWM4ACgkQOeye3VZi
gblQNhAAg2/8vR6ShfYstyPuctY9sz/4fdkbJfpLJ7qRjifvV42rseStJftUbn2K
tM0wiyZS3rhGapOJAXyVdstaFitFIFSynz53LQnW92Am3fVnuyTAoS/JTjB8hXkV
nqRwZFfGM29sPi7RlON6xfDNMiBY79AczstneaSQvPXYhqblRJ3eRwPWwSHTON+w
KYWd3ZcsSWAVjVLBDV423fIUCv206A1Khpke3sjq31fB14NL6p/5hcn6Qp4oXG+2
3T8CQ5c7ERpCl0UFftj9jD+8YooK81YZxfeFN9lPcMKocMI8nBMA6IOuxHLffDsf
7l+ZlN6FWEZfhdOCa9RqecoxDOJSp1+kCCjted3rFQOXHiienaJRVv5CI4jIcAk2
SKwHehgH1OUmd05lKGzDQ9WS0Y1NEo/8Am+tS/a3BgzX1R7YKeWJZiLMGbzwDYwy
zqMcN67N5Rapd/isaF+yCJUle+FSQ09yCWngOmhBjrJzjblOHWOQUN567Vxvme5Z
yOuR2N451rlXDX3xYVK26umsCQUQUB8Z/YujUVAOJRaOjcJqYag6IMulvId5jmzW
3rcxS56D88qNimPqoecAd7pXVy0YKjdatNA1wCC22uiVrcehhF4swNQoGAoqI4Aq
Vz8RWUNHID4DDL6pZce+F7ZqahwD/YonHwA4vPXCcpEmWB5HwXA=
=yyAX
-----END PGP SIGNATURE-----
--=-=-=--
