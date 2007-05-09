From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Wed, 9 May 2007 08:49:23 +0200
Message-ID: <20070509064923.GO4163@kernel.dk>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, Heinz Mauelshagen <hjm@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 08 2007, Andrew Morton wrote:
> >  static inline void bio_list_init(struct bio_list *bl)
> >  {
> >  	bl->head = bl->tail = NULL;
> >  }
> >  
> > +#define bio_list_for_each(bio, bl) \
> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> > +	     bio = bio->bi_next)
> > +
> 
> I have this vague memory from a long time ago that one particular CPU type
> wants to go oops when prefetching from an invalid address.
> 
> Maybe that went away for some reason - we'd have hit it again if it was
> real.

Besides, manual prefetching is very rarely a win. I dabbled with some
benchmarks a few weeks back (with the doubly linked lists), and in most
cases it was actually a loss. So I'd vote for just removing the
prefetch() above.

-- 
Jens Axboe
