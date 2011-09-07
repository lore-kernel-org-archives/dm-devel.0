From: Joe Thornber <thornber@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Wed, 7 Sep 2011 10:46:43 +0100
Message-ID: <20110907094642.GA3729@ubuntu>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
	<Pine.LNX.4.64.1109051148450.22564@hs20-bc2-1.build.redhat.com>
	<20110906093332.GB3619@ubuntu>
	<Pine.LNX.4.64.1109061202280.21793@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109061202280.21793@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 06, 2011 at 12:08:51PM -0400, Mikulas Patocka wrote:
> So, I can implement a call "void dm_bufio_discard_buffer(struct 
> dm_bufio_client *c, sector_t block)" and this call will discard a specific 
> buffer at a specific location (the call is not guaranteed to succeed, it 
> would not discard if someone is holding the buffer or so). It would be 
> like a "bforget" function for filesystem buffers.
> 
> You will call this function on metadata sectors that you are freeing.
> 
> Do you agree with this interface?

That's not really what I was after, but it's a good idea.  Don't do
anything about it now, and I'll instrument to see if I can drive it
effectively.  I try and recycle freed blocks as quickly as possible to
avoid fragmenting free space, which may mean there is little benefit.

> Other than this, I don't know how to reduce cache size, I don't know about 
> any algorithm that would guess cache size automatically. In operating 
> systems, caches usually grow without limit regardless of whether someone 
> needs the cache or not.

ok, let's go with things as they are.  Thx for your hard work.

One other optimisation to think about: As you know, if a non-blocking
lookup of the thinp mapping fails, the bio gets handed across to a
worker thread to do the blocking lookup.  Is there any way to you
could make dm_bm_read_try_lock() pass a preload hint to bufio, since
we know that block is going to be required in the near future?

- Joe
