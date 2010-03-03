From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Date: Wed, 03 Mar 2010 21:45:05 +0300
Message-ID: <87wrxtkzwu.fsf@openvz.org>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	(Mike Snitzer's message of "Wed, 3 Mar 2010 13:20:23 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> On Tue, Mar 2, 2010 at 10:49 PM, Dmitry Monakhov <dmonakhov@openvz.or=
g> wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>>
>>> On Sat, Feb 27 2010, Dmitry Monakhov wrote:
>>>> merge_bvec_fn() returns bvec->bv_len on success. So we have to che=
ck
>>>> against this value. But in case of fs_optimization merge we compar=
e
>>>> with wrong value. This patch must be included in
>>>> =C2=A0b428cd6da7e6559aca69aa2e3a526037d3f20403
>>>> But accidentally i've forgot to add this in the initial patch.
>>>> To make things straight let's replace all such checks.
>>>> In fact this makes code easy to understand.
>>>
>>> Agree, applied.
>> Ohh.. as you already know this patch break dm-layer. Sorry.
>> This is because dm->merge may return more than requested. So correct
>> check must test against less what requested. Correct patch attached.
>
> Yes, it is quite common for dm_merge_bvec() to return greater than th=
e
> requested length.
>
> But dm_merge_bvec() returning a maximum length, rather than requested=
,
> isn't special.  All the other blk_queue_merge_bvec() callers' merge
> functions appear to return "maximum amount of bytes we can accept at
> this offset" too.
What for? Does it allow us to make some optimization?
=46or example like follows:
bio_add_pageS(bio, **pages) {
   /* call merge_fn only one untill all space exhausted */             =
  =20
   ret =3D merge_fn()  (this returns huge value (1024*1024))
   while (ret) {=20
          bio->bi_io_vec[bio->bi_vcnt - 1].bv_page =3D page;
          ...
          ret -=3D PAGE_SIZE;
          bio->bi_vcnt++;
   }
}
IMHO the answer is *NO*, this code will unlikely to work.
>
> __bio_add_page() only needs to care about whether the
> 'q->merge_bvec_fn' return is _less than_ the requested length.
>
>> From 145fb49bf2251f445ca29c5218333367448932d6 Mon Sep 17 00:00:00 20=
01
>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>> Date: Wed, 3 Mar 2010 06:28:06 +0300
>> Subject: [PATCH] blkdev: fix merge_bvec_fn return value checks v2
>>
>> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
>> against this value. But in case of fs_optimization merge we compare
>> with wrong value. This patch must be included in
>> =C2=A0b428cd6da7e6559aca69aa2e3a526037d3f20403
>> But accidentally i've forgot to add this in the initial patch.
>> To make things straight let's replace all such checks.
>> In fact this makes code easy to understand.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>> =C2=A0fs/bio.c | =C2=A0 =C2=A04 ++--
>> =C2=A01 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index 88094af..975657a 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -557,7 +557,7 @@ static int __bio_add_page(struct request_queue *=
q, struct bio *bio, struct page
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.=
bi_rw =3D bio->bi_rw,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0};
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (q->merge_bvec_fn(q, &bvm, pr=
ev) < len) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (q->merge_bvec_fn(q, &bvm, pr=
ev) < prev->bv_len) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=
rev->bv_len -=3D len;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r=
eturn 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> @@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *=
q, struct bio *bio, struct page
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * merge_bvec=
_fn() returns number of bytes it can accept
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * at this of=
fset
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (q->merge_bvec=
_fn(q, &bvm, bvec) < len) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (q->merge_bvec=
_fn(q, &bvm, bvec) < bvec->bv_len) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bvec->bv_page =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bvec->bv_len =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bvec->bv_offset =3D 0;
>
> NOTE this 2nd hunk doesn't change anything at all because: bvec->bv_l=
en =3D len;
Yess. IMHO this makes code more readable.
>
> Mike
