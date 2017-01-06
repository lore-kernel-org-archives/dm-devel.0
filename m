From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Sat, 07 Jan 2017 10:01:07 +1100
Message-ID: <877f67lrnw.fsf@notabene.neil.brown.name>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com> <20161223114553.GP4138@soda.linbit> <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com> <878tqrmmqx.fsf@notabene.neil.brown.name> <20170104185046.GA982@redhat.com> <alpine.LRH.2.02.1701061139160.13944@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1701061151010.13944@file01.intranet.prod.int.rdu2.redhat.com> <20170106195216.GA15583@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170106195216.GA15583@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmai>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 07 2017, Mike Snitzer wrote:

> On Fri, Jan 06 2017 at 12:34pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>>=20
>>=20
>> On Fri, 6 Jan 2017, Mikulas Patocka wrote:
>>=20
>> >=20
>> >=20
>> > On Wed, 4 Jan 2017, Mike Snitzer wrote:
>> >=20
>> > > On Wed, Jan 04 2017 at 12:12am -0500,
>> > > NeilBrown <neilb@suse.com> wrote:
>> > >=20
>> > > > > Suggested-by: NeilBrown <neilb@suse.com>
>> > > > > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
>> > > > > ---
>> > > > >  block/blk-core.c | 20 ++++++++++++++++++++
>> > > > >  1 file changed, 20 insertions(+)
>> > > > >
>> > > > > diff --git a/block/blk-core.c b/block/blk-core.c
>> > > > > index 9e3ac56..47ef373 100644
>> > > > > --- a/block/blk-core.c
>> > > > > +++ b/block/blk-core.c
>> > > > > @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio=
 *bio)
>> > > > >  		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
>> > > > >=20=20
>> > > > >  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) =3D=3D 0)=
) {
>> > > > > +			struct bio_list lower, same, hold;
>> > > > > +
>> > > > > +			/* Create a fresh bio_list for all subordinate requests */
>> > > > > +			bio_list_init(&hold);
>> > > > > +			bio_list_merge(&hold, &bio_list_on_stack);
>> > > > > +			bio_list_init(&bio_list_on_stack);
>> > > > >=20=20
>> > > > >  			ret =3D q->make_request_fn(q, bio);
>> > > > >=20=20
>> > > > >  			blk_queue_exit(q);
>> > > > > +			/* sort new bios into those for a lower level
>> > > > > +			 * and those for the same level
>> > > > > +			 */
>> > > > > +			bio_list_init(&lower);
>> > > > > +			bio_list_init(&same);
>> > > > > +			while ((bio =3D bio_list_pop(&bio_list_on_stack)) !=3D NULL)
>> > > > > +				if (q =3D=3D bdev_get_queue(bio->bi_bdev))
>> > > > > +					bio_list_add(&same, bio);
>> > > > > +				else
>> > > > > +					bio_list_add(&lower, bio);
>> > > > > +			/* now assemble so we handle the lowest level first */
>> > > > > +			bio_list_merge(&bio_list_on_stack, &lower);
>> > > > > +			bio_list_merge(&bio_list_on_stack, &same);
>> > > > > +			bio_list_merge(&bio_list_on_stack, &hold);
>> > > > >=20=20
>> > > > >  			bio =3D bio_list_pop(current->bio_list);
>> > > > >  		} else {
>> > > > > --=20
>> > > > > 2.7.4
>> > >=20
>> > > Mikulas, would you be willing to try the below patch with the
>> > > dm-snapshot deadlock scenario and report back on whether it fixes th=
at?
>> > >=20
>> > > Patch below looks to be the same as here:
>> > > https://marc.info/?l=3Dlinux-raid&m=3D148232453107685&q=3Dp3
>> > >=20
>> > > Neil and/or others if that isn't the patch that should be tested ple=
ase
>> > > provide a pointer to the latest.
>> > >=20
>> > > Thanks,
>> > > Mike
>> >=20
>> > The bad news is that this doesn't fix the snapshot deadlock.
>> >=20
>> > I created a test program for the snapshot deadlock bug (it was origina=
lly=20
>> > created years ago to test for a different bug, so it contains some cru=
ft).=20
>> > You also need to insert "if (ci->sector_count) msleep(100);" to the en=
d of=20
>> > __split_and_process_non_flush to make the kernel sleep when splitting =
the=20
>> > bio.
>> >=20
>> > And with the above above patch, the snapshot deadlock bug still happen=
s.
>
> That is really unfortunate.  Would be useful to dig in and understand
> why.  Because ordering of the IO in generic_make_request() really should
> take care of it.

I *think* you might be able to resolve this by changing
__split_and_process_bio() to only ever perform a single split.  No
looping.
i.e. if the bio is too big to handle directly, then split off the front
to a new bio, which you bio_chain to the original.  The original then
has bio_advance() called to stop over the front, then
generic_make_request() so it is queued.
Then the code proceeds to __clone_and_map_data_bio() on the front that
got split off.
When that completes it *doesn't* loop round, but returns into
generic_make_request() which does the looping and makes sure to handle
the lowest-level bio next.

something vaguely like this:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5664f3..06ee0960e415 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1216,6 +1216,14 @@ static int __split_and_process_non_flush(struct clon=
e_info *ci)
=20
 	len =3D min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
=20
+	if (len < ci->sector_count) {
+		struct bio *split =3D bio_split(bio, len, GFP_NOIO, fs_bio_set);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio =3D split;
+		ci->sector_count =3D len;
+	}
+
 	r =3D __clone_and_map_data_bio(ci, ti, ci->sector, &len);
 	if (r < 0)
 		return r;

though I haven't tested, and the change (if it works) should probably be
more fully integrated into surrounding code.

You probably don't want to use "fs_bio_set" either - a target-local
pool would be best.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhwIbMACgkQOeye3VZi
gbmoCg/9EQZW3c9c88uwsTb5Hrs3VyqvnIVBaqMR4SnkT+ZNPz5W1P68n9bbw+NV
ehRDFgCh9zPGPbwDMEW2ioii/YByObOSOMqDL+r/mRyu2e2MNlQCHw/KEHZN+CX/
4xpq280p1ilSHV+z+9p5yjk1JHpScUc7QYc43WcXhxxewO271aHxFBxOnYbLDCuF
PT5mgdzjA2NXzEtENz6/BMXf98p+mV3I73bShRY1F4Mj+h5MPPFDjMbdTU+AALsY
LD4IXJZnaNrjo7V8jlXQSDzHleIdfeQc//By6yT82sbAqzqeUoL1JZ58Yv/HAakd
wOJvSvQqLpf+sxIQwqN5jj8VaT6VYNbevXULlM255phia+J6i8XIB7sOKqztZC2s
YPBw0qvTpiygGBc3QKRkDZfvXRrukvYIMDrjpa9uUtZFgosgCjngyMdohAvWRjmF
VYEfe8kvh6wYzOAl2a5MrLp0qP+BnLaOZuZR6+wJcChDcDPhQ9ueQLm4cxa4/Zip
VkLxKD+FbHgJm7g8U+evrloaAL9D9E6addKdm6wQNj2MnOLZWWXoWc/JLJxWygFQ
8N0ss7RrOC94O7XPyOYh3jL7U+IZ9Gf1IIWhBBVIFjSv4xQwS+luo0vrsNcR1TaQ
51+Qtv0Y0ePPrIJDgy1/jUmfxPByZyPNAVrr/mAAmQ5VJJurT0Y=
=U5i2
-----END PGP SIGNATURE-----
--=-=-=--
