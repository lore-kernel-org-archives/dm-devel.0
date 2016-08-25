From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Thu, 25 Aug 2016 14:34:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608251426590.26645@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net>
	<alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com>
	<20160814000740.GA5317@redhat.com>
	<alpine.LRH.2.02.1608151245120.13026@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.11.1608181742260.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1608181742260.10662@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, johnstonj.public@codenest.com
List-Id: dm-devel.ids



On Thu, 18 Aug 2016, Eric Wheeler wrote:

> > On Wed, Jun 01 2016 at  9:44am -0400, Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > > > be dm-crypt.c.  Maybe you've identified some indirect use of
> > > > > BIO_MAX_SIZE?
> > > >
> > > > I mean the recently introduced BIO_MAX_SIZE in -next tree:
> > > >
> > > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/md/dm-crypt.c?id=4ed89c97b0706477b822ea2182827640c0cec486
> > >
> > > The crazy bcache bios striking back once again.  I really think it's
> > > harmful having a _MAX value and then having a minor driver
> > > reinterpreting it and sending larger ones.  Until we can lift the
> > > maximum limit in general nad have common code exercise it we really need
> > > to stop bcache from sending these instead of littering the tree with
> > > workarounds.
> > 
> > The bio_kmalloc function allocates bios with up to 1024 vector entries (as 
> > opposed to bio_alloc and bio_alloc_bioset that has a limit of 256 vector 
> > entries).
> > 
> > Device mapper is using bio_alloc_bioset with a bio set, so it is limited 
> > to 256 vector entries, but other kernel users may use bio_kmalloc and 
> > create larger bios.
> > 
> > So, if you don't want bios with more than 256 vector entries to exist, you 
> > should impose this limit in bio_kmalloc (and fix all the callers that use 
> > it).
> 
> FYI, Kent Overstreet notes this about bcache from the other thread here:
> 	https://lkml.org/lkml/2016/8/15/620
> 
> [paste]
> >> bcache originally had workaround code to split too-large bios when it 
> >> first went upstream - that was dropped only after the patches to make 
> >> generic_make_request() handle arbitrary size bios went in. So to do what 
> >> you're suggesting would mean reverting that bcache patch and bringing that 
> >> code back, which from my perspective would be a step in the wrong 
> >> direction. I just want to get this over and done with.
> >> 
> >> re: interactions with other drivers - bio_clone() has already been changed 
> >> to only clone biovecs that are live for current bi_iter, so there 
> >> shouldn't be any safety issues. A driver would have to be intentionally 
> >> doing its own open coded bio cloning that clones all of bi_io_vec, not 
> >> just the active ones - but if they're doing that, they're already broken 
> >> because a driver isn't allowed to look at bi_vcnt if it isn't a bio that 
> >> it owns - bi_vcnt is 0 on bios that don't own their biovec (i.e. that were 
> >> created by bio_clone_fast).
> >> 
> >> And the cloning and bi_vcnt usage stuff I audited very thoroughly back 
> >> when I was working on immutable biovecs and such back in the day, and I 
> >> had to do a fair amount of cleanup/refactoring before that stuff could go 
> >> in. 
> [/paste]
> 
> They are making progress in the patch-v3 thread, so perhaps this can be 
> fixed for now in generic_make_request().
> 
> --
> Eric Wheeler

Device mapper can't split the bio in generic_make_request - it frees the 
md->queue->bio_split bioset, to save one kernel thread per device. Device 
mapper uses its own splitting mechanism.

So what is the final decision? - should device mapper split the big bio or 
should bcache not submit big bios?

I think splitting big bios in the device mapper is better - simply because 
it is much less code than reworking bcache to split bios internally.

BTW. In the device mapper, we have a layer dm-io, that was created to work 
around bio size limitations - it accepts unlimited I/O request and splits 
it to several bios. When bio size limitations are gone, we could simplify 
dm-io too.

Mikulas
