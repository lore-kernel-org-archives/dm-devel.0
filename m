From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 7/9] dm snapshot: add shared exception store
Date: Wed, 29 Oct 2008 09:19:00 +0900
Message-ID: <20081029091724T.fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081027165538.GA27667@mars.virtualiron.com>
	<20081029085625U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081029085625U.fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Wed, 29 Oct 2008 08:57:00 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 27 Oct 2008 12:55:38 -0400
> Konrad Rzeszutek <konrad@virtualiron.com> wrote:
> 
> > On Mon, Oct 27, 2008 at 09:07:54PM +0900, FUJITA Tomonori wrote:
> > > This adds a new exception store implementation, shared exception
> > > store. The important design differences from the current two exception
> > > store implementations:
> > > 
> > > - It uses one exception store (cow disk) per origin device that is
> > >   shared by all snapshots.
> > > - It doesn't keep the complete exception tables in memory.
> > > 
> > > The shared exception store uses struct pstore, which the persistent
> > > exception store uses because there are many useful functions that
> > > struct pstore works with. The shared exception adds some variants to
> > > struct pstore, but not many.
> > 
> > Thank you for posting this. I've just two questions:
> 
> Thanks for the comments.
> 
> > ... 
> > > +static unsigned long shared_allocate_chunk(struct pstore *ps)
> > > +{
> > > +	unsigned long idx;
> > > +	unsigned long limit;
> > > +	unsigned long start_chunk;
> > > +	unsigned long nr = (ps->snap->chunk_size << SECTOR_SHIFT) * 8;
> > > +
> > > +	start_chunk = ps->cur_bitmap_chunk;
> > > +again:
> > > +	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks)
> > > +		limit = ps->nr_chunks - (nr * (ps->nr_bitmap_chunks - 1));
> > 
> > Is this correct? If the chunk size is 16 the nr_chunks would be the bit-shift
> > value (5). Hence you are subtracting 8192*(some positivie number)-1 from 5 -
> > is that what you intend to do?
> 
> nr_chunks is the total number of chunks. What I try to do here is to
> calculate the number of chunks that the last bitmap chunk holds.
> 
> I guess that it's better to do something simpler like this:
> 
> if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks)
>         limit = ps->nr_chunks % nr;
> else
> 	limit = nr;

Duh, should have been:

if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks && ps->nr_chunks % nr)
         limit = ps->nr_chunks % nr;
