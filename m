From: Yehuda Sadeh <yehuda-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 04/14] block: Add bio_clone_kmalloc()
Date: Thu, 24 May 2012 14:41:24 -0700
Message-ID: <CAC-hyiHNFSiqPAoe9ynokUg1xTS=V32JDYiVHh_qH7ow=0C1fw@mail.gmail.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-5-git-send-email-koverstreet@google.com>
	<20120524185919.GE27550@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120524185919.GE27550-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, Alex Elder <elder-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 11:59 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, May 23, 2012 at 05:02:41PM -0700, Kent Overstreet wrote:
>
> [..]
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 013c7a5..5a953c6 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **=
old, struct bio **next,
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 while (old_chain && (total < len)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D bio_kmalloc(gfpmask, old_chain->bi=
_max_vecs);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D bio_clone_kmalloc(old_chain, gfpma=
sk);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!tmp)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>>
>> @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio *=
*old, struct bio **next,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bp)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err=
_out;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __bio_clone(tmp, &bp->bio1=
);
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *next =3D &bp->bio2;
>
> Is this code correct. Now original code might clone bio after split a=
nd
> new code will clone the original bio itself and not the split one?
>

Yeah, that's wrong.

Yehuda
