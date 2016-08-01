From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: To add, or not to add, a bio REQ_ROTATIONAL flag
Date: Sun, 31 Jul 2016 19:58:50 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1607291113060.10662@mail.ewheeler.net>
References: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net> <yq1y44l2qhr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1y44l2qhr.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, hurikhan77@gmail.com, antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>, "Jason B. Akers" <jason.b.akers@intel.com>, Kapil Karkra <kapil.karkra@intel.com>, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, david@fromorbit.com
List-Id: dm-devel.ids

[+cc from "Enable use of Solid State Hybrid Drives"
	https://lkml.org/lkml/2014/10/29/698 ]

On Thu, 28 Jul 2016, Martin K. Petersen wrote:
> >>>>> "Eric" == Eric Wheeler <bcache@lists.ewheeler.net> writes:
> Eric> [...]  This may imply that
> Eric> we need a new way to flag cache bypass from userspace [...]
> Eric> So what are our options?  What might be the best way to do this?
[...] 
> Eric> Are FADV_NOREUSE/FADV_DONTNEED reasonable candidates?
> 
> FADV_DONTNEED was intended for this. There have been patches posted in
> the past that tied the loop between the fadvise flags and the bio. I
> would like to see those revived.

That sounds like a good start, this looks about right from 2014:
	https://lkml.org/lkml/2014/10/29/698
	https://lwn.net/Articles/619058/

I read through the thread and have summarized the relevant parts here 
with additional commentary below the summary:

/* Summary 

They were seeking to do basically the same in 2014 thing we want with 
stacked block caching drivers today: hint to the IO layer so the (ATA 3.2) 
driver can decide whether a block should hit the cache or spinning disk.  
This was done by adding bitflags to ioprio for IOPRIO_ADV_ advice.

There are two arguments throughout the thread: one that the cache hint 
should be per-process (ionice) and the other, that hints should be per 
inode via fadvise (and maybe madvise).  Dan Williams noted with respect to 
fadvise for their implementation that "It's straightforward to add, but I 
think "80%" of the benefit can be had by just having a per-thread cache 
priority."

Kapil Karkra extended the page flags so the ioprio advice bits can be 
copied into bio->bi_rw, to which Jens said "is a bit...icky. I see why 
it's done, though, it requires the least amount of plumbing."

Martin K. Petersen provides a matrix of desires for actual use cases here:
	https://lkml.org/lkml/2014/10/29/1014 
and asks "Are there actually people asking for sub-file granularity? I 
didn't get any requests for that in the survey I did this summer. [...] In 
any case I thought it was interesting that pretty much every use case that 
people came up with could be adequately described by a handful of I/O 
classes."

Further, Jens notes that "I think we've needed a proper API for passing in 
appropriate hints on a per-io basis for a LONG time. [...] We've tried 
(and failed) in the past to define a set of hints that make sense. It'd be 
a shame to add something that's specific to a given transport/technology. 
That said, this set of hints do seem pretty basic and would not 
necessarily be a bad place to start. But they are still very specific to 
this use case."
*/


So, perhaps it is time to plan the hint API and figure out how to plumb 
it.  These are some design considerations based on the thread:

a. People want per-process cache hinting (ionice, or some other tool).
b. Per inode+range hinting would be useful to some (fadvise, ioctl, etc)
c. Don't use page flags to convey cache hints---or find a clean way to do so.
d. Per IO hints would be useful to both stacking and hardware drivers.
e. Cache layers will implement their own device assignment choice based 
on the caching hint; for example, an IO flagged to miss the cache might 
hit if already in cache due to unrelated IO and such a determination would 
be made per-cache-implementation.


I can see this go two ways:

1. A dedicated implementation for cache hinting.
2. An API for generalized hinting, upon which cache hinting may be 
implemented.

To consider #2, what hinting is wanted from processes and inodes down to 
bio's?  Does it justify an entire API for generalized hinting, or do we 
just need a cache hinting implementation?  If we do want #2, then what are 
all of the features wanted by the community so it can be designed as such?

If #1 is sufficient, then what is the preferred mechanism and 
implementation for cache hinting?

In either direction, how can those hints pass down to bio's in an 
appropriate way (ie, not page flags)?


With the interest of a cache hinting implementation independent of 
transport/technology, I have been playing with an idea to use two per-IO 
"TTL" counters, both of which tend toward zero; I've not yet started an 
implementation:

cacheskip: 
	Decrement until zero to skip cache layers (slow medium)
	Ignore cachedepth until cacheskip==0.
	
cachedepth:
	Initialize to positive, negative, or zero value.  Once zero, no 
	special treatment is given to the IO.  When less than zero, prefer the 
	slower medium.  When greater than zero, prefer the faster medium.  
	Inc/decrement toward zero each time the IO passes through a 
	caching layer.

Independent of how we might apply these counters to a pid/inode, the cache 
layers might look something like this:

cachedepth	description
  0		direct IO
+-1		pagecache
+-2		som arbitrary
+-3		caching
+-4		driver
+-n		...

Layers beyond the pagecache are assigned arbitrarily by the driver 
stacking order implemented by the end user. For example, if passing 
through dm-cache, then dm-cache would use its own preference logic to 
decide whether it should cache or not if cachedepth is zero.  If nonzero, 
it would cache/bypass appropriately and then inc/decrements cachedepth 
toward zero after making its decision.  Understandably, extenuating 
circumstances may require a layer to ignore the hint---such as a 
bypass-hinted IO that gets cached because it is already hot.

Consider the following scenarios for this contrived cache stack:

1. pagecache
2. dm-cache
3. bcache
4. HBA supporting cache hints (ATA 3.2, perhaps)

cacheskip	cachedepth	description
-------------------------------------------
	0		0	use pagecache; lower layers do what they want
	1		0	skip pagecache (direct IO); lower layers do what they want
	0		-1	same as previous
	2		1	skip pagecache, dmcache; prefer bcache-ssd
	0		-3	skip pagecache; dmcache bypass; bcache bypass
	1		2	skip pagecache; prefer dmcache-ssd, prefer bcache-ssd
	3		1	hint to prefer HBA cache only

This would empower the user to decide where caching should begin, and for 
how many layers caching should hint for slow(-) or fast(+) backing devices 
before letting the IO stack make its own hintless choice.  Hopefully this 
lets each layer make their own choices that best fit their implementation.

Note that this would not support multi-device tiering as written.  If some 
layer supports multiple IO performance tiers (more than 2) at the same 
layer, then this hinting algorithm is insufficient unless a 
cache-layer-specific datastructure could be passed with the IO hinting 
request.  Also, an eviction hint is not supported by this model.


Please comment with your thoughts.  I look forward to feedback and 
implementation ideas for what would be the best way to plumb cache hinting 
for whatever implementation is chosen.

--
Eric Wheeler


