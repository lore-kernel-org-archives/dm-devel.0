From: Mikulas Patocka <mpatocka@redhat.com>
Subject: RE: [PATCH] x86: introduce memcpy_flushcache_clflushopt
Date: Sat, 18 Apr 2020 11:21:27 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004181110160.30139@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com> <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com> <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com> <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gpe8u=zNrRhvd9ioVNGbOJfRUXzFZuV--be6Hbj0xXtQ@mail.gmail.com> <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com> <69c2e011c5814255926f309dd50e6d67@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69c2e011c5814255926f309dd50e6d67@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Sat, 18 Apr 2020, David Laight wrote:

> From: Mikulas Patocka
> > Sent: 17 April 2020 13:47
> ...
> > Index: linux-2.6/drivers/md/dm-writecache.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-17 14:06:35.139999000 +0200
> > +++ linux-2.6/drivers/md/dm-writecache.c	2020-04-17 14:06:35.129999000 +0200
> > @@ -1166,7 +1166,10 @@ static void bio_copy_block(struct dm_wri
> >  			}
> >  		} else {
> >  			flush_dcache_page(bio_page(bio));
> > -			memcpy_flushcache(data, buf, size);
> > +			if (likely(size > 512))
> > +				memcpy_flushcache_clflushopt(data, buf, size);
> > +			else
> > +				memcpy_flushcache(data, buf, size);
> 
> Hmmm... have you looked at how long clflush actually takes?
> It isn't too bad if you just do a small number, but using it
> to flush large buffers can be very slow.

Yes, I have. It's here: 
http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem.txt

sequential write 8 + clflush	- 0.3 GB/s on nvdimm
sequential write 8 + clflushopt - 1.6 GB/s on nvdimm
sequential write-nt 8 bytes	- 1.3 GB/s on nvdimm

> I've an Ivy bridge system where the X-server process requests the
> frame buffer be flushed out every 10 seconds (no idea why).
> With my 2560x1440 monitor this takes over 3ms.
> 
> This really needs a cond_resched() every few clflush instructions.
> 
> 	David

AFAIK Ivy Bridge doesn't have clflushopt, it only has clflush. clflush 
only allows one outstanding cacle line flush, so it's very slow. 
clflushopt and clwb relaxed this restriction and there can be multiple 
cache-invalidation requests in flight until the user serializes it with 
the sfence instruction.

The patch checks for clflushopt with 
"static_cpu_has(X86_FEATURE_CLFLUSHOPT)" and if it is not present, it 
falls back to non-temporal stores.

Mikulas
