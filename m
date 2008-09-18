From: Milan Broz <mbroz@redhat.com>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 18:08:55 +0200
Message-ID: <48D27D17.6040207@redhat.com>
References: <200809181127.37704.knikanth@suse.de> <48D1FBBE.4080305@redhat.com>
	<20080918134412.GK25711@one.firstfloor.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080918134412.GK25711@one.firstfloor.org>
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
Cc: Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Andi Kleen wrote:
> On Thu, Sep 18, 2008 at 08:57:02AM +0200, Milan Broz wrote:
>> - imagine DM device which has barrier support switched on by this simple patch and
>> you try to run pvmove on it. How is the barrier request processed by underlying
>> devices now?
> 
> I don't see how a barrier can go through incorrectly even in this scenario. The pvmove
> will always be handled by the remapper and then remapper always checks
> underlying single device and barrier supported and rejects the barrier
> as needed. 

Well, it depends what we expect from barrier implementation.
I work with the idea that if block device support barriers,
it should support them in all situations.

You patch test every single request, so the same request can succeed,
minute later the same request can return NOTSUPP because mapping changed.
So if this is what you want, you are right - it works.

The pvmove example:
1) one disk, linear mapping -> barriers supported
2) user run pvmove to another disk -> all barriers are rejected during the move
3) pvmove finished -> barriers are supported again

That's probably fine (I expect barrier fs code support this correctly).
But it is workaround, not real barrier support in device-mapper.

>> - what about stacking devices? Imagine crypto - there is one device per
>> table possible under linear target (where you enable barriers by this patch).
>> dm-crypt will need to implement some queue flushes to properly support
>> barriers.
> 
> Yes dm_crypt needs more work for barriers (I have an experimental but not
> quite right patch here for that), but my other patch doesn't enable 
> barriers on dm_crypt anyways. dm_crypt doesn't call dm_barrier_supported() 
> on its target ever, so there won't be any barriers for it.
> 
>> Another example - partition mapping over multipath (kpartx), ...
> 
> dm-mpath doesn't call dm_barrier_supported() either. Did you
> really read my patch?  It sounds like you're ranting about something
> else, but not my patch.

Sure - your patch enabled it only for linear target. So the request will fail
somewhere down the stack - in mpath/crypt/whatever target.

That wass not against your patch - I just want more generic solution
(and and wrote some simple implementation already).
And these workarounds mostly delay the real implementation...

I want barriers for all targets - use some core functionality and process
only special situation in targets. See my comments in link below.

>> Unfortunately I received _no_ feedback to mentioned RFC barrier patches.
> 
> What patches?  Pointer please.

The mail I replied to contains links to all mentioned patches:

> [1] http://lkml.org/lkml/2008/2/15/125
> [2] http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5941

Milan
