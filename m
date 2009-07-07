From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 7 Jul 2009 14:38:32 -0400
Message-ID: <83EE3995-729F-47B6-A03E-768A97D8031E@redhat.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
	<1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
	<19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown>
	<1245697837.7390.456.camel@o> <1246539130.20207.12.camel@o>
	<19025.28110.236108.810671@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: multipart/mixed; boundary="===============1548815292=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19025.28110.236108.810671@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, heinzm@redhat.com, Dan Williams <dan.j.williams@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1548815292==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-58-249256412"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-58-249256412
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Jul 5, 2009, at 11:21 PM, Neil Brown wrote:
> Here your code seems to be 2-3 times faster!
> Can you check which function xor_block is using?
> If it is :
>  xor: automatically using best checksumming function: ....
> then it might be worth disabling that test in calibrate_xor_blocks and
> see if it picks one that ends up being faster.
>
> There is still the fact that by using the cache for data that will be
> accessed once, we are potentially slowing down the rest of the system.
> i.e. the reason to avoid the cache is not just because it won't
> benefit the xor much, but because it will hurt other users.
> I don't know how to measure that effect :-(
> But if avoiding the cache makes xor 1/3 the speed of using the cache
> even though it is cold, then it would be hard to justify not using the
> cache I think.

So, Heinz and I are actually both looking at xor speed issues, but  
from two different perspectives.  While he's comparing some of the  
dmraid45 xor stuff to the xor_blocks routine in crypto/, I'm  
specifically looking at that "automatically using best checksumming  
function" routine.  For the last 9 or so years, we've automatically  
opted for the SSE + non-temporal store routine specifically because  
it's not supposed to pollute cache.  However, after even just a  
cursory reading of the current Intel architecture optimization guide,  
it's obvious that our SSE routine is getting rather aged, and I think  
the routine is in serious need of an overhaul.  This is something I'm  
currently looking into.  But, that raises the question of how to  
decide whether or not to use it, either in its current form or any new  
form it might take.  As you point out, the tradeoff between cache  
polluting and non-cache polluting is hard to quantify.

We made a significant error when we originally wrote the SSE routines,  
and Heinz just duplicated it.  Specifically, we tested performance on  
a quiescent system.  For the SSE routines, I think this is a *major*  
error.  The prefetch instructions need to be timed such that the  
prefetch happens at roughly the right point in time to compensate for  
the memory latency in getting the data to L1/L2 cache prior to use by  
the CPU.  Unfortunately, memory latency in a system that is quiescent  
is drastically different than latency in a system with several CPUs  
actively competing for RAM resources on top of 100MB/s+ of DMA  
traffic, etc.  When we optimized the routines in a quiescent state, I  
think we got our prefetches too close to when the data was needed by  
the CPU under real world use conditions and that's impacting the  
operation of the routines today (or maybe we did get it right, but  
changes in CPU speed relative to memory latency have caused the best  
prefetch point to change over time, either way the current SSE xor  
routine appears to be seriously underperforming in my benchmark tests).

Likewise, Heinz's tests were comparing cold cache to hot cache and  
trying to find a break over point where we switch from one to the  
other.  But that question necessarily depends on other factors in the  
system including what other cores on the same die are doing as that  
impacts the same cache.

So if the error was to not test and optimize these routines under  
load, then the right course of action would be to do the opposite.   
And that leads me to believe that the best way to quantify the  
difference between cache polluting and non-cache polluting should  
likewise not be done on a quiescent system with a micro benchmark.   
Instead, we need a holistic performance test to get the truly best xor  
algorithm.  In my current setup, the disks are so much faster than the  
single threaded xor thread that the bottleneck is the xor speed.  So,  
what does it matter if the xor routine doesn't pollute cache if the  
raid is so slow that programs are stuck in I/O wait all the time as  
the raid5 thread runs non-stop?  Likewise, who cares what the top  
speed of a cache polluting xor routine is if in the process it evicts  
so many cache pages belonging to the processes doing real work on the  
system that now cache reload becomes the bottleneck.  The ultimate  
goal of either approach is overall *system* speed, not micro benchmark  
speed.  I would suggest a specific, system wide workload test that  
involves a filesystem on a device that uses the particular raid level  
and parity routine you want to test, and then you need to run that  
system workload and get a total time required to perform that specific  
work set, CPU time versus idle+I/O wait time in completing that work  
set, etc.  Repeat the test for the various algorithms you wish to  
test, then analyze the results and go from there.  I don't think  
you're going to get a valid run time test for this, instead we would  
likely need to create a few heuristic rules that, combined with  
specific CPU properties, cause us to choose the right routine for the  
machine.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-58-249256412
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkpTljAACgkQQ9aEs6Ims9ge3gCeNEs3Ph/QS3Z94UH6/U4qx6Yi
U1kAoJiPCHQdkd1/BbfBnEdiJRKVVhpj
=7Cn2
-----END PGP SIGNATURE-----

--Apple-Mail-58-249256412--


--===============1548815292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1548815292==--
