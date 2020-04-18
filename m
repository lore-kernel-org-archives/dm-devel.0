From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] x86: introduce memcpy_flushcache_clflushopt
Date: Sat, 18 Apr 2020 13:27:53 +0000
Message-ID: <69c2e011c5814255926f309dd50e6d67@AcuMS.aculab.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com>
 <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
 <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gpe8u=zNrRhvd9ioVNGbOJfRUXzFZuV--be6Hbj0xXtQ@mail.gmail.com>
 <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Mikulas Patocka' <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka
> Sent: 17 April 2020 13:47
...
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-17 14:06:35.139999000 +0200
> +++ linux-2.6/drivers/md/dm-writecache.c	2020-04-17 14:06:35.129999000 +0200
> @@ -1166,7 +1166,10 @@ static void bio_copy_block(struct dm_wri
>  			}
>  		} else {
>  			flush_dcache_page(bio_page(bio));
> -			memcpy_flushcache(data, buf, size);
> +			if (likely(size > 512))
> +				memcpy_flushcache_clflushopt(data, buf, size);
> +			else
> +				memcpy_flushcache(data, buf, size);

Hmmm... have you looked at how long clflush actually takes?
It isn't too bad if you just do a small number, but using it
to flush large buffers can be very slow.

I've an Ivy bridge system where the X-server process requests the
frame buffer be flushed out every 10 seconds (no idea why).
With my 2560x1440 monitor this takes over 3ms.

This really needs a cond_resched() every few clflush instructions.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
