From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource
	exhaustion
Date: Wed, 04 Jan 2017 16:12:54 +1100
Message-ID: <878tqrmmqx.fsf@notabene.neil.brown.name>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
	<1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
	<20160711141042.GY13335@soda.linbit>
	<76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
	<20161223114553.GP4138@soda.linbit>
	<CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2944397195331466932=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, R
List-Id: dm-devel.ids

--===============2944397195331466932==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03 2017, Jack Wang wrote:

> 2016-12-23 12:45 GMT+01:00 Lars Ellenberg <lars.ellenberg@linbit.com>:
>> On Fri, Dec 23, 2016 at 09:49:53AM +0100, Michael Wang wrote:
>>> Dear Maintainers
>>>
>>> I'd like to ask for the status of this patch since we hit the
>>> issue too during our testing on md raid1.
>>>
>>> Split remainder bio_A was queued ahead, following by bio_B for
>>> lower device, at this moment raid start freezing, the loop take
>>> out bio_A firstly and deliver it, which will hung since raid is
>>> freezing, while the freezing never end since it waiting for
>>> bio_B to finish, and bio_B is still on the queue, waiting for
>>> bio_A to finish...
>>>
>>> We're looking for a good solution and we found this patch
>>> already progressed a lot, but we can't find it on linux-next,
>>> so we'd like to ask are we still planning to have this fix
>>> in upstream?
>>
>> I don't see why not, I'd even like to have it in older kernels,
>> but did not have the time and energy to push it.
>>
>> Thanks for the bump.
>>
>>         Lars
>>
> Hi folks,
>
> As Michael mentioned, we hit a bug this patch is trying to fix.
> Neil suggested another way to fix it.  I attached below.
> I personal prefer Neil's version as it's less code change, and straight f=
orward.
>
> Could you share your comments, we can get one fix into mainline.
>
> Thanks,
> Jinpu
> From 69a4829a55503e496ce9c730d2c8e3dd8a08874a Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.com>
> Date: Wed, 14 Dec 2016 16:55:52 +0100
> Subject: [PATCH] block: fix deadlock between freeze_array() and wait_barr=
ier()
>
> When we call wait_barrier, we might have some bios waiting
> in current->bio_list, which prevents the array_freeze call to
> complete. Those can only be internal READs, which have already
> passed the wait_barrier call (thus incrementing nr_pending), but
> still were not submitted to the lower level, due to generic_make_request
> logic to avoid recursive calls. In such case, we have a deadlock:
> - array_frozen is already set to 1, so wait_barrier unconditionally waits=
, so
> - internal READ bios will not be submitted, thus freeze_array will
> never completes.
>
> To fix this, modify generic_make_request to always sort bio_list_on_stack
> first with lowest level, then higher, until same level.
>
> Sent to linux-raid mail list:
> https://marc.info/?l=3Dlinux-raid&m=3D148232453107685&w=3D2
>

This should probably also have

  Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>

or something that, as I was building on Lars' ideas when I wrote this.

It would also be worth noting in the description that this addresses
issues with dm and drbd as well as md.

In fact, I think that with this patch in place, much of the need for the
rescue_workqueue won't exist any more.  I cannot promise it can be
removed completely, but it should be to hard to make it optional and
only enabled for those few block devices that will still need it.
The rescuer should only be needed for a bioset which can be allocated
From=20twice in the one call the ->make_request_fn.  This would include
raid0 for example, though raid0_make_reqest could be re-written to not
use a loop and to just call generic_make_request(bio) if bio !=3D split.

Thanks,
NeilBrown


> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  block/blk-core.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9e3ac56..47ef373 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio *bio)
>  		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
>=20=20
>  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) =3D=3D 0)) {
> +			struct bio_list lower, same, hold;
> +
> +			/* Create a fresh bio_list for all subordinate requests */
> +			bio_list_init(&hold);
> +			bio_list_merge(&hold, &bio_list_on_stack);
> +			bio_list_init(&bio_list_on_stack);
>=20=20
>  			ret =3D q->make_request_fn(q, bio);
>=20=20
>  			blk_queue_exit(q);
> +			/* sort new bios into those for a lower level
> +			 * and those for the same level
> +			 */
> +			bio_list_init(&lower);
> +			bio_list_init(&same);
> +			while ((bio =3D bio_list_pop(&bio_list_on_stack)) !=3D NULL)
> +				if (q =3D=3D bdev_get_queue(bio->bi_bdev))
> +					bio_list_add(&same, bio);
> +				else
> +					bio_list_add(&lower, bio);
> +			/* now assemble so we handle the lowest level first */
> +			bio_list_merge(&bio_list_on_stack, &lower);
> +			bio_list_merge(&bio_list_on_stack, &same);
> +			bio_list_merge(&bio_list_on_stack, &hold);
>=20=20
>  			bio =3D bio_list_pop(current->bio_list);
>  		} else {
> --=20
> 2.7.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhshFYACgkQOeye3VZi
gblqUg/7Bws8GmwZUdBHNk3xCTBNEMVYJEDp2ybObY/6wX8T4mPQzeyEjcRRWFsq
2k1BYf042lDz37arcOuBa2iYmmV8Wb7ePgoa4wKbZ5L2imuyvCllEz/tMCwl8Qdd
068zLJ5LlmRanfVKv4yPL5qg+tRBg4WVo6Qx1pBdqf/5uffK/pHUUPAtx6Ae4aLT
FJisLZ1GDGH9eZwC4Nzy6cABl6J7fbfMevUieCE5TprJqlArhaWpBxrPTlZDNlkO
8EqM1SkO8YecFYc7cC+ryUM4UQhZlJGFTOVcchI2oME7C257ebjOSj7SVS62wail
zyEyaKMJ126eqW/9SfewSfkkaXggWhsHOioupoGpjgx8XnzqUSUBYowHURawuTdg
tO7syR8QiGJfz5H1D4tM2s3B8DZxW4/LSkSBmNEYjJREmlVuFZ7zGAoH54GiM72M
Z6RZ3u9+GQw8XmLd6U6D5gqsLUMNNmNzZ2U2iQ7cuIAYSJAr+iT0RNCiDmKnrPj0
gTZGyuLGsiQmJswnhDHAGOMXUOGPAaRP4kMqDkA3N9EoixC6xUQUciGA87bZruzz
5pN4GKtfbBjmDLqXRIsJMQS2uAKQB0Op1XNHGSpktdhinaFDiet/+XkTwqd3u2cZ
vg35xPvQF5khosSkpOei19LMoGZjfL7Xnt7kK5unxvz5F/PaoM8=
=xcLU
-----END PGP SIGNATURE-----
--=-=-=--


--===============2944397195331466932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2944397195331466932==--
