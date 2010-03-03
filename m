From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Date: Wed, 3 Mar 2010 13:20:23 -0500
Message-ID: <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	 <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874okyf4iw.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 2, 2010 at 10:49 PM, Dmitry Monakhov <dmonakhov@openvz.org>=
 wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
>
>> On Sat, Feb 27 2010, Dmitry Monakhov wrote:
>>> merge_bvec_fn() returns bvec->bv_len on success. So we have to chec=
k
>>> against this value. But in case of fs_optimization merge we compare
>>> with wrong value. This patch must be included in
>>> =A0b428cd6da7e6559aca69aa2e3a526037d3f20403
>>> But accidentally i've forgot to add this in the initial patch.
>>> To make things straight let's replace all such checks.
>>> In fact this makes code easy to understand.
>>
>> Agree, applied.
> Ohh.. as you already know this patch break dm-layer. Sorry.
> This is because dm->merge may return more than requested. So correct
> check must test against less what requested. Correct patch attached.

Yes, it is quite common for dm_merge_bvec() to return greater than the
requested length.

But dm_merge_bvec() returning a maximum length, rather than requested,
isn't special.  All the other blk_queue_merge_bvec() callers' merge
functions appear to return "maximum amount of bytes we can accept at
this offset" too.

__bio_add_page() only needs to care about whether the
'q->merge_bvec_fn' return is _less than_ the requested length.

> From 145fb49bf2251f445ca29c5218333367448932d6 Mon Sep 17 00:00:00 200=
1
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Wed, 3 Mar 2010 06:28:06 +0300
> Subject: [PATCH] blkdev: fix merge_bvec_fn return value checks v2
>
> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
> against this value. But in case of fs_optimization merge we compare
> with wrong value. This patch must be included in
> =A0b428cd6da7e6559aca69aa2e3a526037d3f20403
> But accidentally i've forgot to add this in the initial patch.
> To make things straight let's replace all such checks.
> In fact this makes code easy to understand.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> =A0fs/bio.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/bio.c b/fs/bio.c
> index 88094af..975657a 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -557,7 +557,7 @@ static int __bio_add_page(struct request_queue *q=
, struct bio *bio, struct page
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0.bi_rw =3D bio->bi_rw,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0};
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (q->=
merge_bvec_fn(q, &bvm, prev) < len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (q->=
merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0prev->bv_len -=3D len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *q=
, struct bio *bio, struct page
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * merge_bvec_fn() returns number of b=
ytes it can accept
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * at this offset
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (q->merge_bvec_fn(q, &bvm, bvec) < l=
en) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (q->merge_bvec_fn(q, &bvm, bvec) < b=
vec->bv_len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bvec->bv_page =3D NULL=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bvec->bv_len =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bvec->bv_offset =3D 0;

NOTE this 2nd hunk doesn't change anything at all because: bvec->bv_len=
 =3D len;

Mike
