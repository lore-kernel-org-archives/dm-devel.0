From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Thu, 10 May 2007 15:29:57 +0100
Message-ID: <20070510152957.5c1ddec9@the-village.bc.nu>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
	<20070509064923.GO4163@kernel.dk>
	<Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 10 May 2007 16:17:57 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On May 9 2007 08:49, Jens Axboe wrote:
> >On Tue, May 08 2007, Andrew Morton wrote:
> >> > +#define bio_list_for_each(bio, bl) \
> >> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> >> > +	     bio = bio->bi_next)
> >> > +
> >
> >Besides, manual prefetching is very rarely a win. I dabbled with some
> >benchmarks a few weeks back (with the doubly linked lists), and in most
> >cases it was actually a loss. So I'd vote for just removing the
> >prefetch() above.
> 
> So is the prefetching in the basic ADTs (e.g. linux/list.h) a loss too?

Depends on the box it seems. On the newest systems the processor
prefetching seems to be very much smarter. On a "classic" AMD Athlon the
prefetching made the scheduler about 1.5% faster...

Alan
