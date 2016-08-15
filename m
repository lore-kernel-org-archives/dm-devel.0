From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Mon, 15 Aug 2016 13:03:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608151245120.13026@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net>
	<alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com>
	<20160814000740.GA5317@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160814000740.GA5317@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, johnstonj.public@codenest.com
List-Id: dm-devel.ids



On Sat, 13 Aug 2016, Mike Snitzer wrote:

> [top-posting just because others went wild with it]
> 
> I don't have a strong opinion but I just assumed the local dm-crypt
> workaround wasn't the way forward.  I didn't stage it because Christoph
> disagreed with it:
> https://lkml.org/lkml/2016/6/1/456
> https://lkml.org/lkml/2016/6/1/477
> 
> Also, this would appear to be a more generic fix:
> "block: make sure big bio is splitted into at most 256 bvecs
> https://lkml.org/lkml/2016/8/12/154
> (but Christoph disagrees there too, so the way forward isn't clear)
> 
> Mike


On Wed, Jun 01 2016 at  9:44am -0400, Christoph Hellwig <hch@infradead.org> wrote:

> > > be dm-crypt.c.  Maybe you've identified some indirect use of
> > > BIO_MAX_SIZE?
> >
> > I mean the recently introduced BIO_MAX_SIZE in -next tree:
> >
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/md/dm-crypt.c?id=4ed89c97b0706477b822ea2182827640c0cec486
>
> The crazy bcache bios striking back once again.  I really think it's
> harmful having a _MAX value and then having a minor driver
> reinterpreting it and sending larger ones.  Until we can lift the
> maximum limit in general nad have common code exercise it we really need
> to stop bcache from sending these instead of littering the tree with
> workarounds.

The bio_kmalloc function allocates bios with up to 1024 vector entries (as 
opposed to bio_alloc and bio_alloc_bioset that has a limit of 256 vector 
entries).

Device mapper is using bio_alloc_bioset with a bio set, so it is limited 
to 256 vector entries, but other kernel users may use bio_kmalloc and 
create larger bios.

So, if you don't want bios with more than 256 vector entries to exist, you 
should impose this limit in bio_kmalloc (and fix all the callers that use 
it).

Mikulas
