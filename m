From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date: Thu, 21 Jun 2018 05:13:39 +0300
Message-ID: <CAHp75Vei2_V7h4oKAU+uoCG2gUJH6uXtg9zVqQ_vnyr5KEmNYw@mail.gmail.com>
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

>> We can't as we end up including bitmap.h (by the way of cpumask.h)
>> form slab.h, so we gen circular dependency.
>

It's not just so easy. See below.

> That info should have been in the changelog, and probably a code
> comment.
>
>> Maybe if we removed memcg
>> stuff from slab.h so we do not need to include workqueue.h...
>
> Or move the basic slab API stuff out of slab.h into a new header.  Or
> create a new, standalone work_struct.h - that looks pretty simple.

I tried to move out work_struct, it didn't help. There are actually
several circular dependencies that ends in bitmap.h either way or
another.

First one is

slab.h -> gfp.h -> mmzone.h -> nodemask.h -> bitmap.h

And so on...

Splitting out kXalloc stuff to a separate header won't help, I think,
because of the above.
Splitting out struct work_struct is just a tip of an iceberg.
Splitting out memcg stuff won't help in the similar way.

I'm all ears for (a better) solution.

-- 
With Best Regards,
Andy Shevchenko
