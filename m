From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Wed, 7 Sep 2011 14:47:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109071444260.484@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
	<20110905150714.GA2722@infradead.org>
	<Pine.LNX.4.64.1109061154040.21793@hs20-bc2-1.build.redhat.com>
	<20110906160839.GA12866@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110906160839.GA12866@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 6 Sep 2011, Christoph Hellwig wrote:

> On Tue, Sep 06, 2011 at 11:57:00AM -0400, Mikulas Patocka wrote:
> > > IS there any reason you'll need a fixed size?  This is fairly similar in
> > > concept to the XFS buffercache, which does perfectly well by allocation
> > > memory as needed, and letting the shrinker reclaim buffers when under
> > > memory pressure.
> > 
> > It is possible to make unlimited size. --- the question: is the shrinker 
> > run when we exhaust vmalloc arena?
> > 
> > dm-bufio cache uses vmalloc arena under some circumstances. On some 
> > architectures (for example i386), vmalloc arena is smaller than main 
> > memory, therefore it may overflow before main memory does.
> > 
> > What does XFS do when vmalloc arena is exhausted?
> 
> At this point shrinkers do not handle vmalloc space, although we could
> add them.  In the default configuration XFS uses very little vmalloc
> space in the buffer cache - only the 8 log buffers are vmapped, and
> those can't be reclaimed anyway.  During log recovery or if using the
> non-standard larger directory block mkfs option it can consume a larger
> amount of vmalloc space, and we have run into problems because of that,
> e.g. take a look at the loop around vm_map_ram() in _xfs_buf_map_pages()
> that we had to add as a workaround, and the commit introducing it for
> more details (a19fb380).

I see --- but: shouldn't vm_map_ram() do its own cleanup and call 
vm_unmap_aliases() accordingly? Do you mean that any function that 
allocates something from vmalloc area needs to call vm_unmap_aliases() and 
retry in case of failure?

> Just curious, why do you need the buffers to be vmapped?  If we'd design
> the dir2 format these days we'd make sure it is aligned in a way that
> we could deal with individually mapped pages.

I need it if we use larger buffers than pages. They are allocated with 
get_free_pages, but it is unreliable and has its own limit, so I use 
vmalloc as a reliable backup.

Mikulas
