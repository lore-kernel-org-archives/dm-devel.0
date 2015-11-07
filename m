From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/4] dm verity: add support for error
 correction
Date: Sat, 7 Nov 2015 10:29:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511071021100.18330@file01.intranet.prod.int.rdu2.redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com> <563B066C.6050202@redhat.com> <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com> <20151106190634.GA2813@google.com> <563CFD6F.4040009@redhat.com>
 <20151106202750.GA11849@google.com> <563D1614.5010501@redhat.com> <20151106212338.GA19557@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151106212338.GA19557@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids



On Fri, 6 Nov 2015, Sami Tolvanen wrote:

> On Fri, Nov 06, 2015 at 10:05:24PM +0100, Zdenek Kabelac wrote:
> > So how do you want to correctly 'restore'  missing full sectors
> > with just 0.8% data overhead ??
> 
> We use interleaving. Each byte in a 4k block is part of a different
> Reed-Solomon block, which means an entire lost 4k data block looks like a
> single error. When we also spread the bytes that form a single Reed-Solomon
> block across the partition, we end up being able to correct several
> megabytes of consecutive corrupted blocks with very small space overhead.
> 
> Sami

But the patch doesn't do any correction in case of I/O error - it just 
returns the bio with I/O error.

BTW. the function verity_fec_alloc_buffers does vzalloc and GFP_KERNEL 
kmalloc inside I/O handling code - that shouldn't be done - you should 
preallocate the data structures when the device is loaded.

Mikulas
