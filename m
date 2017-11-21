From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] new patchset to eliminate DM's use of BIOSET_NEED_RESCUER [was: Re: [PATCH 00/13] block: assorted cleanup for bio splitting and cloning.]
Date: Wed, 22 Nov 2017 10:03:15 +1100
Message-ID: <87ine31bgs.fsf@notabene.neil.brown.name>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name> <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
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
>> On Tue, Nov 21 2017 at  7:43am -0500,
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>=20=20
>> > Decided it a better use of my time to review and then hopefully use the
>> > block-core's bio splitting infrastructure in DM.  Been meaning to do
>> > that for quite a while anyway.  This mail from you just made it all the
>> > more clear that needs doing:
>> > https://www.redhat.com/archives/dm-devel/2017-September/msg00098.html
>> >=20
>> > So I will start here on this patch you proposed:
>> > https://www.redhat.com/archives/dm-devel/2017-September/msg00091.html
>> > (of note, this patch slipped through the cracks because I was recoveri=
ng
>> > from injury when it originally came through).
>> >=20
>> > Once DM is using q->bio_split I'll come back to this patch (aka
>> > "[1]") as a starting point for the follow-on work to remove DM's use of
>> > BIOSET_NEED_RESCUER:
>> > https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html
>>=20
>> Hey Neil,
>>=20
>> Good news!  All your code works ;)
>>=20
>> (well after 1 fixup due to a cut-n-paste bug.. the code you added to
>> dm_wq_work() to process the md->rescued bio_list was operating on
>> the md->deferred bio_list due to cut-n-paste from code you copied from
>> just below it)
>>=20
>> I split your code out some to make it more reviewable.  I also tweaked
>> headers accordingly.
>>=20
>> Please see this branch (which _will_ get rebased between now and the
>> 4.16 merge window):
>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.g=
it/log/?h=3Ddm-4.16
>>=20
>> I successfully tested these changes using Mikulas' test program that
>> reproduces the snapshot deadlock:
>> https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html
>>=20
>> I'll throw various other DM testsuites at it to verify they all look
>> good (e.g. thinp, cache, multipath).
>>=20
>> I'm open to all suggestions about changes you'd like to see (either to
>> these patches or anything you'd like to layer ontop of them).
>>=20
>> Thanks for all your work, much appreciated!
>> Mike
>
> This is not correct:

Thanks for your review!

>
>    2206 static void dm_wq_work(struct work_struct *work)
>    2207 {
>    2208         struct mapped_device *md =3D container_of(work, struct ma=
pped_device, work);
>    2209         struct bio *bio;
>    2210         int srcu_idx;
>    2211         struct dm_table *map;
>    2212
>    2213         if (!bio_list_empty(&md->rescued)) {
>    2214                 struct bio_list list;
>    2215                 spin_lock_irq(&md->deferred_lock);
>    2216                 list =3D md->rescued;
>    2217                 bio_list_init(&md->rescued);
>    2218                 spin_unlock_irq(&md->deferred_lock);
>    2219                 while ((bio =3D bio_list_pop(&list)))
>    2220                         generic_make_request(bio);
>    2221         }
>    2222
>    2223         map =3D dm_get_live_table(md, &srcu_idx);
>    2224
>    2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
>    2226                 spin_lock_irq(&md->deferred_lock);
>    2227                 bio =3D bio_list_pop(&md->deferred);
>    2228                 spin_unlock_irq(&md->deferred_lock);
>    2229
>    2230                 if (!bio)
>    2231                         break;
>    2232
>    2233                 if (dm_request_based(md))
>    2234                         generic_make_request(bio);
>    2235                 else
>    2236                         __split_and_process_bio(md, map, bio);
>    2237         }
>    2238
>    2239         dm_put_live_table(md, srcu_idx);
>    2240 }
>
> You can see that if we are in dm_wq_work in __split_and_process_bio, we=20
> will not process md->rescued list.

Correct, but md->rescued will be empty, or irrelevant.
The first section of dm_wq_work ensures ->rescued is empty.
When __split_and_process_bio() calls generic_make_request() (indirectly
through one or more targets) they will not be recursive calls,
so nothing will be added to current->bio_list[0] and nothing
will be moved to md->rescued.  Each generic_make_request() will
completely submit the request in the lower level devel.

Some other thread could call generic_make_request on this dm device and
result in bios appeared on md->rescued.  These bios could only be a
problem if something that __split_and_process_bio calls might wait for
them.  I don't think that happens (at least I don't think it should...).


>
> The processing of md->rescued is also wrong - bios for different devices=
=20
> must be offloaded to different helper threads, so that processing a bio=20
> for a lower device doesn't depend on processing a bio for a higher device=
.=20
> If you offload all the bios on current->bio_list to the same thread, the=
=20
> bios still depend on each other and the deadlock will still happen.

bios on current->bio_list[0] are not allowed to depend on each other
except that later bios can depend on earlier bios.  They are all for a
lower-level device and should be largely independent.
The sorting that generic_make_request now does ensure that a bio for a
higher level device is never processed when a bio for a lower level
device, that it might depend on, is stuck on current->bio_list.

So I don't think there is a problem here.
Do you find this argument at all convincing?

Thanks,
NeilBrown

>
> Mikulas
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAloUsLUACgkQOeye3VZi
gbkNbRAAj67mOL5PFasqhiCSpviYHWmuIbqMbSrlpeclwnQqw79LWQrE1+CIyDZ7
skntnkCqCyQGLJ+75f3aLx3BbgOqa0qFiMsCpVj3xrcaCm96tqTb9HOTQEG0u54E
xLYx920p5uZfxVans7kcvzc3Bhd6fwmm+xOm+NaJMN3ImfU1xbT2pz5EOPD5MDPU
Z7ghEz6TWV+l3sG6xpimB6a43lds8PCb2MLwuLgh99H6PWfJ6QwYtUjZgS+aIH0i
Aqazs+gtnkC+fBpE9xYZxk4cJlgp0OEhFIJIKXZ8pNcZqdRjtSvzekirFavfalv3
qLmRlUQ+QpjC8l/J3wYIWBz4jKcYNNC2vTYrs+nnGK0UHJwtKgYEtUxRDJ9NNblG
QPbjRilXuzfL/hkDtngA5zsBRHSw5y5bIbOeb8cYIiFTjtND3dCIrTcu7Q3SzlRV
oyFhNzVR66sMEsa7RZu7teOujkQV3+AO+wG2ByEt3gNeFOBhujHhOhhfycMcqiAZ
GDpRfJ96xMtPAe/Dc+jHnIEP3oYx7qP/Cgxj9WipGvJ4ab1Hah6eo4Sci5C7Wf+B
qJ3SglaWuRPldsq/sLgXOLufkjNU+PUbb/Qi1cx0LTAsE93/81Mj7pwKqXBB4vWZ
BR9yPNlVHqPi+y/dRqOmkx+Wmc4upY+eUYstPZLr5bJfcsvtcTo=
=mPek
-----END PGP SIGNATURE-----
--=-=-=--
