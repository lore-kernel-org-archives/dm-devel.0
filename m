From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Thu, 10 May 2007 23:40:15 +0200
Message-ID: <20070510214014.GA4163@kernel.dk>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
	<20070509064923.GO4163@kernel.dk>
	<Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
	<20070510152957.5c1ddec9@the-village.bc.nu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070510152957.5c1ddec9@the-village.bc.nu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Heinz Mauelshagen <hjm@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, May 10 2007, Alan Cox wrote:
> On Thu, 10 May 2007 16:17:57 +0200 (MEST)
> Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
> > 
> > On May 9 2007 08:49, Jens Axboe wrote:
> > >On Tue, May 08 2007, Andrew Morton wrote:
> > >> > +#define bio_list_for_each(bio, bl) \
> > >> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> > >> > +	     bio = bio->bi_next)
> > >> > +
> > >
> > >Besides, manual prefetching is very rarely a win. I dabbled with some
> > >benchmarks a few weeks back (with the doubly linked lists), and in most
> > >cases it was actually a loss. So I'd vote for just removing the
> > >prefetch() above.
> > 
> > So is the prefetching in the basic ADTs (e.g. linux/list.h) a loss too?
> 
> Depends on the box it seems. On the newest systems the processor
> prefetching seems to be very much smarter. On a "classic" AMD Athlon the
> prefetching made the scheduler about 1.5% faster...

It very much depends on the box, indeed. The ones I tested on were
_slower_ with the prefetching, perhaps the dumber CPU's will benefit. In
the long run, I don't think the manual prefetching is a good idea.

-- 
Jens Axboe
