From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: lower bio-based reservation
Date: Thu, 18 Aug 2011 18:34:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108181831250.7668@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108181518360.1529@hs20-bc2-1.build.redhat.com>
	<20110818195741.GA29123@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110818195741.GA29123@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> > Request-based memory consumption cannot be easily reduced, it uses 
> > GFP_ATOMIC to allocate all entries at once, and if it fails, request is 
> > pushed back to the block layer. Thus it needs reservations to process at 
> > least one complete request.
> 
> But couldn't the rq-based reserves be shared and simply protected by a
> lock?

I you don't need a special lock --- mempools are protected by a lock on 
their own.

> We'd need a scheme where we provided a pool+lock per rq-based DM layer
> (for the conceptual possibility that we'd stack request-based DM devices
> even though in practice it isn't done).
> 
> Being aware of how deep the stacking is isn't very elegant though
> (breaks DM abstraction).
> 
> Not to mention, we'd also serialize cloned-request allocations (note it
> wouldn't serialize IO, just the allocations).
> 
> Chances are it would hurt performance for heavy IO to many mpath
> devices.. so I'm not saying it is a wonderful solution.  But can you
> guys think of variants of this shared pool scheme that might work?

If you don't stack rm-based devices, then a shared mempool may work.

It is prone to livelocks --- suppose continuous stream of IO to one device 
blocking progress on another device. But if we suppose that that 
continuous stream won't be infinite or that some memory is freed 
eventually, it may work.

Mikulas

> Mike
> 
