From: Alexander Nyberg <alexn@dsv.su.se>
Subject: Re: possible dm-crypt leak over loop
Date: Thu, 10 Mar 2005 19:23:23 +0100
Message-ID: <1110479004.2301.32.camel@boxen>
References: <1110147738.2266.26.camel@boxen>
	<1110461058.14581.3.camel@leto.cs.pocnet.net>
	<1110466511.2301.10.camel@boxen>
	<1110468099.16258.7.camel@leto.cs.pocnet.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <1110468099.16258.7.camel@leto.cs.pocnet.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Saout <christophe@saout.de>
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>, Steffen Michalke <StMichalke@web.de>
List-Id: dm-devel.ids

> > > Can anybody else confirm this?
> > 
> > The original report came from Steffen Michalke (CC'd), but I find it
> > very weird that you can't trigger the lockup. It takes about a second
> > here on a UP non-preempt box to lock up.
> 
> Perhaps my machine has too much memory. ;)
> 
> > Why I think it's a memory leak is due to the sysrq-Meminfo trace
> > and the call-trace showing 
> > crypt_alloc_buffer => mempool_alloc => io_schedule
> 
> That's normal. For write-outs dm-crypt has to allocate some buffers
> where it can put the encrypted data. mempool_alloc means that it ran out
> of preallocated buffers and waits for some in-flight I/O to finish which
> should free some buffers.
> 
> It looks like this is a dm-crypt <-> loop deadlock. The problem with
> loop is that it goes back through the page cache. The loop thread is
> also waiting for memory to actually be able to write out some more
> pages.
> 
> So this seems to be a loop bug. Loop is waiting for pages to become free
> to actually be able to write some pages. dm-crypt uses a mempool to
> avoid this deadlock but if the underlying device deadlocks it can't do
> anything about that.
> 
> loop does a: alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> 
> There is no guarantee that this will succeed. It probably should also
> have some sort of emergency pool.

Ok, but - this is a late revision, the allocation you pointed out did
not exist in for example 2.6.10. I tried this my test script on a 128MB
machine a few kernels back and it did happen in 2.6.10, maybe not as
fast however.

The place where loop does page allocations in writeout in 2.6.10 is 
do_lo_send()
  grab_cache_page()
    find_or_create_page()
      alloc_page()

And the grab_cache_page looks like a common filesystem called function,
but I guess the difference is that this time the data to writeout is in
kernel memory and not user-space owned. I figure loop shouldn't call
this function that does bare alloc_page, but needs something that uses a
mempool to prevent it from deadlocks when stacking with other drivers.

I don't think I've got the whole picture here, but I'm grateful for your
previous explanation, it helps alot!

Thanks!
Alexander
