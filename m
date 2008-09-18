From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 15:44:12 +0200
Message-ID: <20080918134412.GK25711@one.firstfloor.org>
References: <200809181127.37704.knikanth@suse.de> <48D1FBBE.4080305@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48D1FBBE.4080305@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 18, 2008 at 08:57:02AM +0200, Milan Broz wrote:
> - imagine DM device which has barrier support switched on by this simple patch and
> you try to run pvmove on it. How is the barrier request processed by underlying
> devices now?

I don't see how a barrier can go through incorrectly even in this scenario. The pvmove
will always be handled by the remapper and then remapper always checks
underlying single device and barrier supported and rejects the barrier
as needed. 

After a request passed the remapper to extent cannot be moved elsewhere again
because it's already in flight on the underlying device queues.

Please describe the scenario in more detail that you think will break.

> 
> -> mapping can change online (pvmove, lvextend, lvconvert, ...) to more
> complicated mapping - who reset barrier flag support?
> 
> - what about stacking devices? Imagine crypto - there is one device per
> table possible under linear target (where you enable barriers by this patch).
> dm-crypt will need to implement some queue flushes to properly support
> barriers.

Yes dm_crypt needs more work for barriers (I have an experimental but not
quite right patch here for that), but my other patch doesn't enable 
barriers on dm_crypt anyways. dm_crypt doesn't call dm_barrier_supported() 
on its target ever, so there won't be any barriers for it.

> Another example - partition mapping over multipath (kpartx), ...

dm-mpath doesn't call dm_barrier_supported() either. Did you
really read my patch?  It sounds like you're ranting about something
else, but not my patch.

> Are you sure that is it safe with Andi's patch?

I think it is.

> That's why we need something more robust.
> 
> Unfortunately I received _no_ feedback to mentioned RFC barrier patches.

What patches?  Pointer please.

-Andi
