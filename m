From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] x86: introduce memcpy_flushcache_clflushopt
Date: Sun, 19 Apr 2020 21:49:05 -0700
Message-ID: <CAPcyv4gP4gt7EF8q0hxSvENLATrK8ZEt3uQiUNh8zRNoJ_Ut6A@mail.gmail.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com>
 <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
 <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gpe8u=zNrRhvd9ioVNGbOJfRUXzFZuV--be6Hbj0xXtQ@mail.gmail.com>
 <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com>
 <69c2e011c5814255926f309dd50e6d67@AcuMS.aculab.com> <alpine.LRH.2.02.2004181110160.30139@file01.intranet.prod.int.rdu2.redhat.com>
 <8452b36a07b1440a8da6d4a1623858c1@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8452b36a07b1440a8da6d4a1623858c1@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Apr 19, 2020 at 10:49 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Mikulas Patocka
> > Sent: 18 April 2020 16:21
> >
> > On Sat, 18 Apr 2020, David Laight wrote:
> >
> > > From: Mikulas Patocka
> > > > Sent: 17 April 2020 13:47
> > > ...
> > > > Index: linux-2.6/drivers/md/dm-writecache.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/md/dm-writecache.c     2020-04-17 14:06:35.139999000 +0200
> > > > +++ linux-2.6/drivers/md/dm-writecache.c  2020-04-17 14:06:35.129999000 +0200
> > > > @@ -1166,7 +1166,10 @@ static void bio_copy_block(struct dm_wri
> > > >                   }
> > > >           } else {
> > > >                   flush_dcache_page(bio_page(bio));
> > > > -                 memcpy_flushcache(data, buf, size);
> > > > +                 if (likely(size > 512))
> > > > +                         memcpy_flushcache_clflushopt(data, buf, size);
> > > > +                 else
> > > > +                         memcpy_flushcache(data, buf, size);
> > >
> > > Hmmm... have you looked at how long clflush actually takes?
> > > It isn't too bad if you just do a small number, but using it
> > > to flush large buffers can be very slow.
> >
> > Yes, I have. It's here:
> > http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem.txt
> >
> > sequential write 8 + clflush  - 0.3 GB/s on nvdimm
> > sequential write 8 + clflushopt - 1.6 GB/s on nvdimm
> > sequential write-nt 8 bytes   - 1.3 GB/s on nvdimm
>
> That table doesn't give enough information to be useful.
> The cpu speed, memory speed and transfer lengths are all relevant.
>
> > > I've an Ivy bridge system where the X-server process requests the
> > > frame buffer be flushed out every 10 seconds (no idea why).
> > > With my 2560x1440 monitor this takes over 3ms.
> > >
> > > This really needs a cond_resched() every few clflush instructions.
> > >
> > >     David
> >
> > AFAIK Ivy Bridge doesn't have clflushopt, it only has clflush. clflush
> > only allows one outstanding cacle line flush, so it's very slow.
> > clflushopt and clwb relaxed this restriction and there can be multiple
> > cache-invalidation requests in flight until the user serializes it with
> > the sfence instruction.
>
> It isn't that simple.
> While clflush on Ivybridge is slower than clflushopt on newer processors
> both instructions are (relatively) fast for something like 16 or 32
> iterations. After that they get much slower.
> I can't remember where I found the relevant figures, even the ones I
> found didn't show how large the transfers needed to be before the bytes/sec
> became constant.
>
> > The patch checks for clflushopt with
> > "static_cpu_has(X86_FEATURE_CLFLUSHOPT)" and if it is not present, it
> > falls back to non-temporal stores.
>
> Ok, I was expecting you'd be falling back to clflush first.

clflush is a serializing instruction, clflushopt and non-temporal
stores are not.
