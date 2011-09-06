From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Tue, 6 Sep 2011 11:57:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109061154040.21793@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
	<20110905150714.GA2722@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110905150714.GA2722@infradead.org>
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

On Mon, 5 Sep 2011, Christoph Hellwig wrote:

> On Mon, Sep 05, 2011 at 03:49:14PM +0100, Joe Thornber wrote:
> > I changed the test suite to reset the peak_allocated parameter before
> > each test and record it at the end of each test.  It's very hard to
> > say what is right and wrong when talking about cache sizes, since you
> > always have to qualify anything by saying 'for this particular load'.
> > However, I think bufio could be more aggressive about recycling cache
> > entries.  With the old block manager the test suite ran nicely with
> > less than 256k, from memory I think I started seeing slow down around
> > 128k.  With bufio I'm seeing consistently larger cache sizes for the
> > same performance.
> 
> IS there any reason you'll need a fixed size?  This is fairly similar in
> concept to the XFS buffercache, which does perfectly well by allocation
> memory as needed, and letting the shrinker reclaim buffers when under
> memory pressure.

It is possible to make unlimited size. --- the question: is the shrinker 
run when we exhaust vmalloc arena?

dm-bufio cache uses vmalloc arena under some circumstances. On some 
architectures (for example i386), vmalloc arena is smaller than main 
memory, therefore it may overflow before main memory does.

What does XFS do when vmalloc arena is exhausted?

Mikulas
