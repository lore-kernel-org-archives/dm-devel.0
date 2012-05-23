From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Date: Tue, 22 May 2012 18:44:50 -0700
Message-ID: <CAH+dOx+=XuLzrDqyigAghCT=c6O1HJdd-SMHUw-XpK0NeY8PnA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
	<20120522224255.GM14339@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120522224255.GM14339-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

I'm gonna grovel through the code history, but that looks to me like de=
ad code.

On Tue, May 22, 2012 at 3:42 PM, Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
>> +int submit_bbio_split(struct bio *bio, struct cache_set *c,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bkey *k, unsigned ptr)
>> +{
>> + =A0 =A0 struct closure *cl =3D bio->bi_private;
>> + =A0 =A0 struct bbio *b;
>> + =A0 =A0 struct bio *n;
>> + =A0 =A0 unsigned sectors_done =3D 0;
>> +
>> + =A0 =A0 closure_get(cl);
>> +
>> + =A0 =A0 bio->bi_sector =A0=3D PTR_OFFSET(k, ptr);
>> + =A0 =A0 bio->bi_bdev =A0 =A0=3D PTR_CACHE(c, k, ptr)->bdev;
>> +
>> + =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 n =3D bio_split_get(bio, bio_max_sectors(b=
io), c);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!n) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 closure_put(cl);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 b =3D container_of(n, struct bbio, bio);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 bkey_copy_single_ptr(&b->key, k, ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 SET_KEY_SIZE(&b->key, KEY_SIZE(k) - sector=
s_done);
>> + =A0 =A0 =A0 =A0 =A0 =A0 SET_PTR_OFFSET(&b->key, 0, PTR_OFFSET(k, p=
tr) + sectors_done);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 b->submit_time_us =3D local_clock_us();
>> + =A0 =A0 =A0 =A0 =A0 =A0 generic_make_request(n);
>> + =A0 =A0 } while (n !=3D bio);
>> +
>> + =A0 =A0 return 0;
>> +}
>
> Hmmm... where is @sectors_done updated?
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
