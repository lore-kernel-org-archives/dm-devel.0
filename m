From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH 00/12] A dm-raid45 target implemented using
 md raid5.
Date: Fri, 16 Apr 2010 08:14:52 +1000
Message-ID: <20100416081452.71c7d0cf@notabene.brown>
References: <20100415062909.15646.16.stgit@notabene.brown>
	<1271352435.13960.32.camel@o>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1271352435.13960.32.camel@o>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 15 Apr 2010 19:27:15 +0200
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> 
> Hi Neil,
> 
> had a first go reading through your patch series w/o finding any major
> issues. The only important feature for an initial release which needs
> adding (as you mentioned) is (persistent) dirty log support.
> 
> Because you're using a persistent bitmap in the MD RAID personalities,
> this looks like a bit more surgery to factor it out to potentially
> enhance dm-log.c. For an initial solution we can as well just go with
> MDs existing bitmap while keeping the dm-raid456 ctr support for
> explicit dirty logging in order to avoid compatibility issues (there's
> obviously no parameter to support bitmap chunk sizes so far).

I don't think we can use md's existing bitmap support as there is no easy way
to store it on an arbitrary target:  it either lives near the metadata or on
a file (not a device).
There a just a few calls in the interface to md/bitmap.c - it shouldn't be
too hard to make those selectively call into a dm_dirty_log instead.
I want to do something like that anyway as I want to optionally be able to use
a dirty log which is a list of dirty sector addresses rather than a bitmap.
I'll have a look next week.

And the "bitmap chunk size" is exactly the same as the dm "region size".
(which would probably have been a better name to choose for md too).

> 
> Reshaping could be triggered either preferably via the constructor
> involving MD metadata reads to be able to recognize the size change
> requested or the message interface. Both ctr/message support could be
> implemented sharing the same functions. Enhancements in the status
> interface and dm_table_event() throwing on error/finish are mandatory if
> we support reshaping.

I imagine enhancing the constructor to take before/after values for
type, disks, chunksize, and a sector which marks where "after" starts.
You also need to know which direction the reshape is going (low addresses to
high addresses, or the reverse) though that might be implicit in the other
values.

> 
> A shortcoming of this MD wrapping solution vs. dm-raid45 is, that there
> is no obvious way to leverage it to be a clustered RAID456 mapping
> target. dm-raid45 has been designed with that future enhancement
> possibility in mind.
> 

I haven't given cluster locking a lot of thought...
I would probably do the locking on a per-"stripe_head" basis as everything
revolves around that structure.
Get a shared lock when servicing a read (Which would only happen on a
degraded array - normally reads bypass the stripe cache), or a write lock
when servicing a write or a resync.
It should all interface with DLM quite well - when DLM tries to reclaim a lock
we first mark all the stripe as not up-to-date...

Does DM simply use DLM for locking or something else?


> Will try testing your code tomorrow.

Thanks,

NeilBrown
