From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 20:13:11 +0200
Message-ID: <20080918181311.GN25711@one.firstfloor.org>
References: <200809181127.37704.knikanth@suse.de> <48D1FBBE.4080305@redhat.com>
	<20080918134412.GK25711@one.firstfloor.org>
	<48D27D17.6040207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48D27D17.6040207@redhat.com>
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

On Thu, Sep 18, 2008 at 06:08:55PM +0200, Milan Broz wrote:
> Andi Kleen wrote:
> > On Thu, Sep 18, 2008 at 08:57:02AM +0200, Milan Broz wrote:
> >> - imagine DM device which has barrier support switched on by this simple patch and
> >> you try to run pvmove on it. How is the barrier request processed by underlying
> >> devices now?
> > 
> > I don't see how a barrier can go through incorrectly even in this scenario. The pvmove
> > will always be handled by the remapper and then remapper always checks
> > underlying single device and barrier supported and rejects the barrier
> > as needed. 
> 
> Well, it depends what we expect from barrier implementation.
> I work with the idea that if block device support barriers,
> it should support them in all situations.

It does.

> 
> You patch test every single request, so the same request can succeed,
> minute later the same request can return NOTSUPP because mapping changed.
> So if this is what you want, you are right - it works.
> 
> The pvmove example:
> 1) one disk, linear mapping -> barriers supported
> 2) user run pvmove to another disk -> all barriers are rejected during the move
> 3) pvmove finished -> barriers are supported again
> 
> That's probably fine (I expect barrier fs code support this correctly).
> But it is workaround, not real barrier support in device-mapper.

It works for 95+% of the users that only have a single disk.
That is all my patch was attempting: support the single disk case.

Yes I know there could be more done for multiple disks or dm crypt
(although I think to do it well for multiple disks needs behaviour
changes in the barriers), but that's orthogonal and shouldn't delay
the single disk case patch.


> 
> That wass not against your patch - I just want more generic solution
> (and and wrote some simple implementation already).

Does solve the single disk case?  If it passes the barriers
through similar to my patch in the single disk case they would
be fine for me.

Although I don't know if your patches would be ready for a .28 merge.
I think my patch is. So if your patches would need more work
it would be quite reasonable to target the simple patch for .28
and do the more complex stuff later.

> And these workarounds mostly delay the real implementation...

I don't know why you can call it a workaround. It's a perfectly fine
design to handle barriers on single disk. And no, complexity is not
always the goal.

I also don't see how it delays more complex solutions. If you have
a more sophisticated scheme ready you can just do it on top of that
patch. It's not that it's an extremly complicated patch that makes
it hard to do other patches on top of it :)

> 
> >> Unfortunately I received _no_ feedback to mentioned RFC barrier patches.
> > 
> > What patches?  Pointer please.
> 
> The mail I replied to contains links to all mentioned patches:
> 
> > [1] http://lkml.org/lkml/2008/2/15/125
> > [2] http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5941

That's just a description, where are the patches?

Are they equivalent in the single disk case to my patch?

-Andi
