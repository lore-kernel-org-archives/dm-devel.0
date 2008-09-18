From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 15:47:36 +0200
Message-ID: <20080918134736.GL25711@one.firstfloor.org>
References: <200809181546.32242.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200809181546.32242.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Christophe Saout <christophe@saout.de>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 18, 2008 at 03:46:31PM +0530, Nikanth Karthikesan wrote:
> Hi Milan
> 
> I was able to talk to Alasdair on Freenode#device-mapper and he is also of the 
> opinion full-barrier support is the way to go.
> 
> On Thu, Sep 18, 2008 at 12:27 PM, Milan Broz <mbroz@redhat.com> wrote:
> > Andi's patch is not complete and I think there can be several problems with 
> > it:
> >
> > - imagine DM device which has barrier support switched on by this simple
> > patch and you try to run pvmove on it. How is the barrier request processed
> > by underlying devices now?
> >
> > -> mapping can change online (pvmove, lvextend, lvconvert, ...) to more
> > complicated mapping - who reset barrier flag support?
> >
> 
> I think these things will not create problems.

Correct.

> 
> > - what about stacking devices? Imagine crypto - there is one device per
> > table possible under linear target (where you enable barriers by this
> > patch).
> > dm-crypt will need to implement some queue flushes to properly support
> > barriers. Another example - partition mapping over multipath (kpartx), ...
> > Are you sure that is it safe with Andi's patch?
> > ...
> 
> I do not have knowledge of dm-crypt, but yes, dm-crypt might possibly reorder.
> Either they should flush the queues or atleast return -EOPNOTSUPP if we need 
> to use Andi's patch.

That's already done because it doesn't call dm_table_support_barrier() on
its target. Only the simple remapper does.

All the scenarios you guys are describing (except for pvmove which
just seems to be confused thinking) would happen when the ->barrier_supported
target flag wasn't there, but it really is.

> > It is dangerous to use that patch IMO, better not support barriers at all
> > here. That's why we need something more robust.
> >
> 
> I understand the possible problems.

Sorry, but Milan is just wrong on all of them as far as I know.

-Andi


-- 
ak@linux.intel.com
