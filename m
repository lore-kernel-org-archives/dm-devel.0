From: Martin Wilck <mwilck@suse.de>
Subject: Re: Disconcerting observation with multipathd's dmevent
	polling code
Date: Wed, 28 Nov 2018 10:31:02 +0100
Message-ID: <b3608cce3000a34787d5c252d2dcb8fb6775ba42.camel@suse.de>
References: <9f372197ec112f97298641e223d2e5e6a5e1b33a.camel@suse.de>
	<6fab77be-763c-4de0-a312-de112e7d1c0a@suse.de>
	<82f6c1b983936a2de4a3f1663f2886cf636460f3.camel@suse.de>
	<20181127201333.GD5077@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181127201333.GD5077@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-11-27 at 14:13 -0600, Benjamin Marzinski wrote:
> On Tue, Nov 27, 2018 at 10:19:20AM +0100, Martin Wilck wrote:
> > 
> > I like this idea, in particular for map removal.
> > Ben, what do you think?
> 
> That was my original goal when I ended up with the dmevents code.  I
> kept running into new corner cases.  The issue is that udev, by
> design,
> does not guarantee that you will get all the uevents, and in fact, we
> do
> see this happen occasionally, so it's not a theoretical problem.
> 
> Because of that, any system that relies on ueventis has to handle
> things
> like
> 
> 1. Someone removes a multipath device
> 2. mutipathd misses the remove uevent
> 3. Someone creates a differnt multipath device with the same alias
> 4. multipathd misses the add uevent.
> 5. multipathd notices that your multipath device has all the wrong
>    paths, and switches them. Well, fortunately, disable_changed_wwids
>    will catch this and simply disable the device

Maybe we should put more work in the "delegate dangerous commands to
multipathd" approach.

> Someone decides to switch the names of two (or more) multipath
> devices:
> 1. Someone disables user_friendly_names, renaming the devices to
>    their wwid names.
> 2. mutipathd misses the uevents.
> 3. The person switches the aliases in mutipath.conf and reloads
> 4. Now multipathd needs to figure out how to swap two (or more)
> device
>    aliases

IMO this works well with the current code (unless names are really
*swapped*, e.g. mpatha<->mpathb). But maybe I'm overlooking something.

> 
> I kept trying to figure out methods around issues like these, and
> kept
> thinking up new ones.  One observation I hit on was that it was
> really
> important to not miss removing a device, because that was the first
> step
> in having your multipath devices pointing to the wrong place.  I'm
> not
> saying it is impossible, I'm just saying that I gave up on it. I
> would
> happily review code that dealt with all of these issues.

If "remove" uevents is most important, what if we created an additional
monitor for "kernel" uevents in multipathd? Those should be just as
reliable as dmevents, and for removal, we don't need the udev rule
processing. Having ACTION==remove and the KERNEL name should be
sufficient. This would obviously not work for "change" or "add" events.

Also, I'd like to understand in what (test? production?) scenarios
you've observed lost uevents. Lack of reliablity of udev is a problem
not only for multipathd, and udev should be fixed. I can mainly think
of:

 1) udev rule processing gets stuck on slow IO or IO timeouts, causing
the worker to be killed,
 2) resource contention between udev workers, in particular on large
systems during "coldplug".

Do you have other failure scenarios in mind?

> 
> However, before we start down that road (because I went down it once
> already, and turned back), lets look at fixing what we have. I agree
> that what happened here is that the dmevents code didn't see the
> device,
> and thus removed it. There seem to be two possible ways for this to
> happen
> 
> 1. device-mapper told us that it successfully completed our command,
> but
>    gave us incomplete information.  This would be a really big issue.
>    Unlike udev, device mapper is supposed to guarantee that if it
>    returns success, it has the information that you asked for. It's
> not
>    just multipath that depends on this.  Many tools use libdevmapper.
>    If there is a bug like this in it, that needs to get fixed, not
>    worked around on a tool-by-tool basis. But, I don't think that
> this
>    is what happened.
> 
> 2. device-mapper told us that it failed to complete our command, and
> we
>    didn't differentiate that from a successful completion with a
> certain
>    result.  I think that this is more likely the cause, largely
> because
>    I can see where we do this. In dm_get_events() once we get the
> list
>    of names from device-mapper we call dm_is_mpath() on each
> name.  I'm
>    not sure why I did this.  Probably, I was worried about searching
>    through a large list of non-multipath names with a lock held, and
>    thought that culling devices that obviously weren't correct would
>    speed this up. At any rate, if the device-mapper command fails, we
>    assume that the device isn't a multipath device, even though
>    device-mapper never told us that.  This is clearly a bug, and it
>    clearly would cause exactly the result you saw. That check should
> be
>    removed, or at least we should differentiate between failure of
> the
>    command and success of the command, where the device does not have
> a
>    multipath table.

Good thought. I'd stared at your code in length, but that didn't occur
to me. I feel relieved that you found an explanation short of
DM_DEVICE_LIST being unreliable.

Martin
