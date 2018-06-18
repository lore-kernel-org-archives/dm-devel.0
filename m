From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date: Tue, 19 Jun 2018 02:18:48 +0300
Message-ID: <CAHp75VcQWO36SVmYOJQyVo8uCoA2Wec_CWw2sjRyCd73TfCpTQ@mail.gmail.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
 <20180618131003.88110-4-andriy.shevchenko@linux.intel.com>
 <20180618141404.68124daab97bd0f3a3051544@linux-foundation.org>
 <CAKdAkRTHOORds7aEauv4rp3_=PnGi=Nv-VS3-nAb9MztJPKG=Q@mail.gmail.com> <20180618161056.e52efd0e8bd36211e60705a2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618161056.e52efd0e8bd36211e60705a2@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, shli@kernel.org, linux-raid@vger.kernel.org, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, Yury Norov <ynorov@caviumnetworks.com>, lkml <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Tue, Jun 19, 2018 at 2:10 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 18 Jun 2018 15:01:43 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>
>> > > +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
>> > > +{
>> > > +     return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
>> > > +}
>> > > +EXPORT_SYMBOL(bitmap_alloc);
>> > > +
>> > > +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
>> > > +{
>> > > +     return bitmap_alloc(nbits, flags | __GFP_ZERO);
>> > > +}
>> > > +EXPORT_SYMBOL(bitmap_zalloc);
>> > > +
>> > > +void bitmap_free(const unsigned long *bitmap)
>> > > +{
>> > > +     kfree(bitmap);
>> > > +}
>> > > +EXPORT_SYMBOL(bitmap_free);
>> > > +
>> >
>> > I suggest these functions are small and simple enough to justify
>> > inlining them.
>> >
>>
>> We can't as we end up including bitmap.h (by the way of cpumask.h)
>> form slab.h, so we gen circular dependency.
>
> That info should have been in the changelog,

I put it in cover letter, though it perhaps better to have in commit
message itself.

> and probably a code
> comment.

This is done in header file. You meant C-file?


>> Maybe if we removed memcg
>> stuff from slab.h so we do not need to include workqueue.h...
>
> Or move the basic slab API stuff out of slab.h into a new header.  Or
> create a new, standalone work_struct.h - that looks pretty simple.

Latter one seems requires least effort without potentially breaking things.
I take it as your suggestion, though I would still give a glance if it
is possible to split exactly memcg part out of slab.

-- 
With Best Regards,
Andy Shevchenko
