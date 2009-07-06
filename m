From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Mon, 6 Jul 2009 13:21:50 +1000
Message-ID: <19025.28110.236108.810671@notabene.brown>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Heinz Mauelshagen on Thursday July 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Thursday July 2, heinzm@redhat.com wrote:
> 
> Dan, Neil,
> 
> like mentioned before I left to LinuxTag last week, here comes an initial
> take on dm-raid45 warm/cold CPU cache xor speed optimization metrics.
> 
> This shall give us the base to decide to keep or drop the dm-raid45
> internal xor optimization magic or move (part of) it into the crypto
> subsystem.

Thanks for doing this.
> 
> 
> Intel results with 128 iterations each:
> ---------------------------------------
> 
> 1 stripe  : NB:10 111/80 HM:118 111/82
> 2 stripes : NB:25 113/87 HM:103 112/91
> 3 stripes : NB:24 115/93 HM:104 114/93
> 4 stripes : NB:48 114/93 HM:80 114/93
> 5 stripes : NB:38 113/94 HM:90 114/94
> 6 stripes : NB:25 116/94 HM:103 114/94
> 7 stripes : NB:25 115/95 HM:103 115/95
> 8 stripes : NB:62 117/96 HM:66 116/95 <<<--- cold cache starts here
> 9 stripes : NB:66 117/96 HM:62 116/95
> 10 stripes: NB:73 117/96 HM:55 114/95
> 11 stripes: NB:63 114/96 HM:65 112/95
> 12 stripes: NB:51 111/96 HM:77 110/95
> 13 stripes: NB:65 109/96 HM:63 112/95

These results seem to suggest that the two different routines provide
very similar results on this hardware, particularly when the cache is cold.
The high degree of variability might be because you have dropped this:

> -	/* Wait for next tick. */
> -	for (j = jiffies; j == jiffies; )
> -		;

??
Without that, it could be running the test over anything from 4 to 5
jiffies.
I note that do_xor_speed in crypto/xor.c doesn't synchronise at the
start either.  I think that is a bug.
The variability seem to generally be close to 20%, which is consistent
with the difference between 4 and 5.

Could you put that loop back in and re-test?

> 
> Opteron results with 128 iterations each:
> -----------------------------------------
> 1 stripe  : NB:0 30/20 HM:128 64/53
> 2 stripes : NB:0 31/21 HM:128 68/55
> 3 stripes : NB:0 31/22 HM:128 68/57
> 4 stripes : NB:0 32/22 HM:128 70/61
> 5 stripes : NB:0 32/22 HM:128 70/63
> 6 stripes : NB:0 35/22 HM:128 70/64
> 7 stripes : NB:0 32/23 HM:128 69/63
> 8 stripes : NB:0 44/23 HM:128 76/65
> 9 stripes : NB:0 43/23 HM:128 73/65
> 10 stripes: NB:0 35/23 HM:128 72/64
> 11 stripes: NB:0 35/24 HM:128 72/64
> 12 stripes: NB:0 33/24 HM:128 72/65
> 13 stripes: NB:0 33/23 HM:128 71/64

Here your code seems to be 2-3 times faster!
Can you check which function xor_block is using?
If it is :
  xor: automatically using best checksumming function: ....
then it might be worth disabling that test in calibrate_xor_blocks and
see if it picks one that ends up being faster.

There is still the fact that by using the cache for data that will be
accessed once, we are potentially slowing down the rest of the system.
i.e. the reason to avoid the cache is not just because it won't
benefit the xor much, but because it will hurt other users.
I don't know how to measure that effect :-(
But if avoiding the cache makes xor 1/3 the speed of using the cache
even though it is cold, then it would be hard to justify not using the
cache I think.

> 
> Questions/Recommendations:
> --------------------------
> Review the code changes and the data analysis please.

It seems to mostly make sense
 - the 'wait for next tick' should stay
 - it would be interesting to see what the final choice of 'chunks'
   was (i.e. how many to xor together at a time).
  

Thanks!

NeilBrown
