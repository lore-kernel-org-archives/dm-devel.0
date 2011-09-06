From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Tue, 6 Sep 2011 12:08:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109061202280.21793@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
	<Pine.LNX.4.64.1109051148450.22564@hs20-bc2-1.build.redhat.com>
	<20110906093332.GB3619@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110906093332.GB3619@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 6 Sep 2011, Joe Thornber wrote:

> On Mon, Sep 05, 2011 at 12:01:28PM -0400, Mikulas Patocka wrote:
> > "cache_size" is the value that you set as a maximum cache size. The 
> > default is 2% of memory or 25% of vmalloc area.
> 
> ah, could you rename this variable to 'max_allocated' then please, to
> match with the 'total_allocated' field (which I presume gives the
> current cache size?).

OK.

> > > With the old block manager the test suite ran nicely with
> > > less than 256k, from memory I think I started seeing slow down around
> > > 128k.  With bufio I'm seeing consistently larger cache sizes for the
> > > same performance.
> > 
> > So, reduce cache_size to 256k (or whatever value you want to test) and see 
> > how it performs.
> 
> But then I'm limited to 256k, my point is we want scaling _and_ to use
> less memory.  We cannot tell our users to experiment to find the right
> setting for this depending on the number of pools they're running and
> the usage of each pool.
> 
> > > For instance the test_overwriting_various_thin_devices scenario from
> > > here
> > > (https://github.com/jthornber/thinp-test-suite/blob/master/basic_tests.rb)
> > > has a peak use of ~1100k, if I change from using dt with random io
> > > pattern to plain old dd then the usage drops to ~900k. Setting the
> > > max_age parameter to 1 second had very little effect.
> > 
> > Reduce cache_size and try it.
> 
> Here are the numbers (best of 3 runs):
> 
> | Test                        | 256k cache (M/s) | 2M cache (M/s) |
> | unprovisioned thin          |             74.4 |             75 |
> | provisioned thin            |             72.8 |           72.6 |
> | new snap (complete sharing) |             73.7 |           73.8 |
> | old snap (no sharing)       |             72.2 |           72.8 |
> 
> So I think that proves my point.  We're getting no benefit from that
> extra memory, is there a subsystem that could be making better use of
> it? (eg, page cache?).  Or are you telling me that nobody else would
> have been using that memory?
> 
> (This is all just tweaking, bufio is working very well).
> 
> - Joe

So, I can implement a call "void dm_bufio_discard_buffer(struct 
dm_bufio_client *c, sector_t block)" and this call will discard a specific 
buffer at a specific location (the call is not guaranteed to succeed, it 
would not discard if someone is holding the buffer or so). It would be 
like a "bforget" function for filesystem buffers.

You will call this function on metadata sectors that you are freeing.

Do you agree with this interface?


Other than this, I don't know how to reduce cache size, I don't know about 
any algorithm that would guess cache size automatically. In operating 
systems, caches usually grow without limit regardless of whether someone 
needs the cache or not.

Mikulas
