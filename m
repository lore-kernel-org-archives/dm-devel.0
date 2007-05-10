From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Thu, 10 May 2007 16:17:57 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
References: <20070508194845.GC24114@agk.fab.redhat.com>
 <20070508174159.7d78a275.akpm@linux-foundation.org> <20070509064923.GO4163@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761556AbXEJOWe@vger.kernel.org>
In-Reply-To: <20070509064923.GO4163@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


On May 9 2007 08:49, Jens Axboe wrote:
>On Tue, May 08 2007, Andrew Morton wrote:
>> > +#define bio_list_for_each(bio, bl) \
>> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
>> > +	     bio = bio->bi_next)
>> > +
>
>Besides, manual prefetching is very rarely a win. I dabbled with some
>benchmarks a few weeks back (with the doubly linked lists), and in most
>cases it was actually a loss. So I'd vote for just removing the
>prefetch() above.

So is the prefetching in the basic ADTs (e.g. linux/list.h) a loss too?



	Jan
-- 
