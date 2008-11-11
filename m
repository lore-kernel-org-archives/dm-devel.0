From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Tue, 11 Nov 2008 17:08:43 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811111657360.5129@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
	<Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
	<20081111181854.GA25049@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081111181854.GA25049@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 11 Nov 2008, Christoph Hellwig wrote:

> On Mon, Nov 10, 2008 at 09:19:21AM -0500, Mikulas Patocka wrote:
> > For device mapper, congested_fn asks every device in the tree and make OR 
> > of their bits --- so if the user has 50 devices, it asks them all.
> > 
> > For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
> > same --- asking every device.
> > 
> > If you have a better idea how to implement congested_fn, say it.
> 
> Well, even asking 50 devices shouldn't take that long normally.

There are some atomic operations inside congested_fn.

I remember that there was some database benchmark on a setup with 48 
devices. Just dropping one spinlock from unplug function resulted in 
overall improvement (not microbenchmarks, the whole run) by 18%. The 
slowdown with unplug is similar as with congested_fn --- unplugs walks all 
the physical devices for a given logical device and unplugs them.

So simplifying congested_fn might help too. Do you have an idea, how often 
is it called? I thought about caching the return value for one jiffy.

> Do you take some sleeping lock that might block forever?  In that case I 
> would just return congested for that device as it would delay pdflush 
> otherwise.

Sometimes we do, and we shouldn't, because congested_fn is called with 
spinlock. That's what I'm working on now.

BTW. how "realtime" do you expect the Linux kernel to be? Is there some 
effort to make all spinlocks locked for finite time? (so that someone 
could one day calculate the times of all spinlocks, take the maximum time 
and give Linux a "realtime" label). If so, then bdi_congested call should 
be moved out of spinlocks. If there are already many cases when spinlock 
could be taken and list of indefinite length walked inside, it isn't worth 
optimizing for it.

Mikulas
