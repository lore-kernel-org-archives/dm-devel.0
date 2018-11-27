From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Disconcerting observation with multipathd's dmevent
	polling code
Date: Tue, 27 Nov 2018 14:13:33 -0600
Message-ID: <20181127201333.GD5077@octiron.msp.redhat.com>
References: <9f372197ec112f97298641e223d2e5e6a5e1b33a.camel@suse.de>
	<6fab77be-763c-4de0-a312-de112e7d1c0a@suse.de>
	<82f6c1b983936a2de4a3f1663f2886cf636460f3.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <82f6c1b983936a2de4a3f1663f2886cf636460f3.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 27, 2018 at 10:19:20AM +0100, Martin Wilck wrote:
> Hi Ben,
> 
> On Wed, 2018-11-21 at 12:20 +0100, Hannes Reinecke wrote:
> > On 11/21/18 11:50 AM, Martin Wilck wrote:
> > > Hi Ben,
> > > 
> > > I recently encountered a strange and disturbing phenomenon with the
> > > latest upstream code.
> > > 
> > > The system in question had two iSCSI connections on separate
> > > networks.
> > > On one of them, I tested iSCSI disconnect and re-connects, and
> > > broken
> > > storage configurations (different LUNs diffenent sizes and with the
> > > same WWID). The other one was idle.
> > > 
> > > During one test, I observed that multipathd's internal
> > > representation
> > > of the map representing the *idle* connection had vanished. The map
> > > was
> > > still present on the device-mapper level, but multipathd seemed to
> > > have
> > > "forgotten" it completely. The respective paths were tracked as
> > > orphans.
> > > 
> > > Here is a log excerpt. multipathd is working on path additions for
> > > the
> > > map I was testing with (149455...), when a DM event is received.
> > > Right
> > > after ev_add_path() releases the lock, the idle map
> > > (36001405...) is removed (not flushed, as the messages suggest).
> > > 
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdg: add path
> > > (uevent)
> > > # uev_add_path->pathinfo()
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdg: udev
> > > property SCSI_IDENT_LUN_T10 whitelisted
> > > # ev_add_path()->adopt_paths()
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sde: ownership
> > > set to 149455400000000006d706174683100000000000000000000
> > > ...
> > > # ev_add_path->setup_map()
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]:
> > > 149455400000000006d706174683100000000000000000000: failback =
> > > "manual" (setting: multipath internal)
> > > # ev_add_path->domap()
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]:
> > > 149455400000000006d706174683100000000000000000000: load table [0
> > > 2097152 multipath 0 0 3 1 service-time 0 1 1 8:64 ...
> > > # ev_add_path->setup_multipath()->update-multipath_strings
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]:
> > > 149455400000000006d706174683100000000000000000000: disassemble map
> > > [0 0 3 1 service-time 0 1 2 8:64 1 1 service-time ...
> > > # (!!!!) devmap event for LIO map
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]:
> > > 36001405d08f748dd4c5481f9ec22b888: devmap event #20
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdg [8:96]:
> > > path added to devmap
> > > 149455400000000006d706174683100000000000000000000
> > > # ev_add_path() returns, vecs->lock is released
> > > # uev_add_path() goes on to next path, lock currently not held
> > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdh: add path
> > > (uevent)
> > > # (!!!!) The LIO map is flushed (36001405d08f748dd4c5481f9ec22b888)
> > > # this looks like remove_map() or remove_map_and_stop_waiter()
> > > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdd: orphan
> > > > path, map flushed
> > > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sysfs
> > > > prioritizer refcount 2
> > > > Nov 15 22:05:46 sles15-gm-iscsi-03 multipathd[568]: sdc: orphan
> > > > path, map flushed
> > > 
> > > To me this looks like the map was removed by the DM event handler.
> > > More detail can be found on
> > > https://bugzilla.opensuse.org/show_bug.cgi?id=1116272.
> > > I've also tried to reproduce the problem, with no success so far
> > > (actually I haven't observed any dmevents in those reproduction
> > > attempts).
> > > 
> > > After encountering this problem, I've scrutinized your polling
> > > dmevent
> > > handler code over and over last week, but I couldn't spot any
> > > possible
> > > problems :-)
> > > 
> > > The concern that I have is with the design of the polling dmevent
> > > API,
> > > in particular the fact that the default action is EVENT_REMOVE. If,
> > > for
> > > whatever reason, one map is missing from the return value of the
> > > DM_DEVICE_LIST ioctl, multipath removes the map immediately, and
> > > there's nothing short of a "reconfigure" or "add map" CLI command
> > > that
> > > would reinstate the map. IOW, we remove the map not on a kernel
> > > event
> > > saying "this map has been removed", but on receiving a list where
> > > this
> > > element happens to be missing. We handle this differently for
> > > paths,
> > > where we wait for a "remove" uevent before we really delete the
> > > path
> > > from our data structures. (Note that the messages file I saved from
> > > the
> > > event above shows no sign of such an uevent ever beeing sent - as I
> > > said, the dm map was still present after the above occured).
> > > 
> > > What do you think about this? Could you maybe inspect those logs I
> > > took, to make sure I didn't get on a totally wrong track here?
> > > 
> > There's an easy solution to it: drop the dmevent handling code in 
> > multipath-tools completely.
> > It's original design was to track _external_ map reloads, as
> > originally 
> > the maps had been setup by 'multipath', and 'multipahtd' was just 
> > tracking state changes. As such multipathd needed to track those 
> > changes, and it had been using dmevents for this.
> > However, with the advent of udev and updates to the multipathd
> > daemon 
> > external map reloads rarely happens, and even if they happen we
> > still 
> > would be notified by uevents.
> > So we might as well drop the dmevent code and rely on udev
> > completely.
> > Which is what we do nowadays anyway.
> 
> I like this idea, in particular for map removal.
> Ben, what do you think?

That was my original goal when I ended up with the dmevents code.  I
kept running into new corner cases.  The issue is that udev, by design,
does not guarantee that you will get all the uevents, and in fact, we do
see this happen occasionally, so it's not a theoretical problem.

Because of that, any system that relies on ueventis has to handle things
like

1. Someone removes a multipath device
2. mutipathd misses the remove uevent
3. Someone creates a differnt multipath device with the same alias
4. multipathd misses the add uevent.
5. multipathd notices that your multipath device has all the wrong
   paths, and switches them. Well, fortunately, disable_changed_wwids
   will catch this and simply disable the device

Someone decides to switch the names of two (or more) multipath devices:
1. Someone disables user_friendly_names, renaming the devices to
   their wwid names.
2. mutipathd misses the uevents.
3. The person switches the aliases in mutipath.conf and reloads
4. Now multipathd needs to figure out how to swap two (or more) device
   aliases

I kept trying to figure out methods around issues like these, and kept
thinking up new ones.  One observation I hit on was that it was really
important to not miss removing a device, because that was the first step
in having your multipath devices pointing to the wrong place.  I'm not
saying it is impossible, I'm just saying that I gave up on it. I would
happily review code that dealt with all of these issues.

However, before we start down that road (because I went down it once
already, and turned back), lets look at fixing what we have. I agree
that what happened here is that the dmevents code didn't see the device,
and thus removed it. There seem to be two possible ways for this to
happen

1. device-mapper told us that it successfully completed our command, but
   gave us incomplete information.  This would be a really big issue.
   Unlike udev, device mapper is supposed to guarantee that if it
   returns success, it has the information that you asked for. It's not
   just multipath that depends on this.  Many tools use libdevmapper.
   If there is a bug like this in it, that needs to get fixed, not
   worked around on a tool-by-tool basis. But, I don't think that this
   is what happened.

2. device-mapper told us that it failed to complete our command, and we
   didn't differentiate that from a successful completion with a certain
   result.  I think that this is more likely the cause, largely because
   I can see where we do this. In dm_get_events() once we get the list
   of names from device-mapper we call dm_is_mpath() on each name.  I'm
   not sure why I did this.  Probably, I was worried about searching
   through a large list of non-multipath names with a lock held, and
   thought that culling devices that obviously weren't correct would
   speed this up. At any rate, if the device-mapper command fails, we
   assume that the device isn't a multipath device, even though
   device-mapper never told us that.  This is clearly a bug, and it
   clearly would cause exactly the result you saw. That check should be
   removed, or at least we should differentiate between failure of the
   command and success of the command, where the device does not have a
   multipath table.

thoughts?

-Ben

> Martin
> 
> 
