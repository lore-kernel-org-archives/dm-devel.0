From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date: Tue, 19 Jun 2018 01:52:13 +0300
Message-ID: <CAHp75VdoL=qTBKMp+FB=RdNRqbZgv9=hJ=kYAAAYFTUpxFAr6g@mail.gmail.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
 <20180618131003.88110-4-andriy.shevchenko@linux.intel.com>
 <20180618141404.68124daab97bd0f3a3051544@linux-foundation.org> <CAKdAkRTHOORds7aEauv4rp3_=PnGi=Nv-VS3-nAb9MztJPKG=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKdAkRTHOORds7aEauv4rp3_=PnGi=Nv-VS3-nAb9MztJPKG=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, shli@kernel.org, linux-raid@vger.kernel.org, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, Yury Norov <ynorov@caviumnetworks.com>, lkml <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Tue, Jun 19, 2018 at 1:01 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Jun 18, 2018 at 2:14 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Mon, 18 Jun 2018 16:10:01 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>>
>> > A lot of code become ugly because of open coding allocations for bitmaps.
>> >
>> > Introduce three helpers to allow users be more clear of intention
>> > and keep their code neat.
>> >
>> > ...
>> >
>> > +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
>> > +{
>> > +     return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
>> > +}
>> > +EXPORT_SYMBOL(bitmap_alloc);
>> > +
>> > +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
>> > +{
>> > +     return bitmap_alloc(nbits, flags | __GFP_ZERO);
>> > +}
>> > +EXPORT_SYMBOL(bitmap_zalloc);
>> > +
>> > +void bitmap_free(const unsigned long *bitmap)
>> > +{
>> > +     kfree(bitmap);
>> > +}
>> > +EXPORT_SYMBOL(bitmap_free);
>> > +
>>
>> I suggest these functions are small and simple enough to justify
>> inlining them.
>>
>
> We can't as we end up including bitmap.h (by the way of cpumask.h)
> form slab.h, so we gen circular dependency. Maybe if we removed memcg
> stuff from slab.h so we do not need to include workqueue.h...

I will look at it. It might be doable.
Though I dunno what MM people would say about this. Anyone's name
comes to your mind to ask?

-- 
With Best Regards,
Andy Shevchenko
