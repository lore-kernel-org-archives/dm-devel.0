From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: RE: patch to discovery.c to still get path
	priorityforpaths with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 01:48:41 -0500
Message-ID: <1163573321.4917.13.camel@linux-cxyg.rtp.netapp.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D154C@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D154C@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

On Tue, 2006-11-14 at 15:09 -0500, Edward Goggin wrote:
> On Tuesday, November 14, 2006 9:27 AM, Dave Wysochanski wrote:
> > Are you saying that there's no way in the path checker to distinguish
> > between this kind of path and a path that is genuinely down?
> 
> No, I'm certainly not saying that at all.  I would rather not
> complicate matters by adding yet another path state though.
> 
> The particular problem I'm trying to fix is that the path group
> membership for a multipath map can be incorrectly initially set
> up if scsi_id(8) is successful but the paths are all failed.
> When the paths return to a ready state, the path group membership
> is not corrected by reloading the map -- this only happens if the
> paths are removed and later added back.
> 
> What do you think of a fix involving changing need_switch_pathgroup()
> in multipathd to check and reload a corrected version of the map
> in this case?
>  

Maybe something like that yes.  It doesn't look like the code handles a
switch in priority of a path really at all so putting that in there
somewhere (checkerloop?) seems worth doing.  Such an approach would have
to be careful that triggering off a change in priority wouldn't cause
other problems if the priority callout fails in a transient way (e.g. if
the priority goes to -1, you probably don't want to modify anything).


>  
> > By "down",
> > I mean "fails ioctl" either directly or with an unexpected
> > CHECK_CONDITION (this seems to be what PATH_DOWN means in the 
> > code today
> > for all the path checkers).  Can you return another state in your path
> > checker for this type of path/LUN?
> > 
> > IMO, if at all possible, it would be good to leave 
> > "PATH_DOWN" with its
> > current meaning and not call the priority callouts for paths in this
> > state.  If the priority callouts could obtain priorities without SG_IO
> > succeeding, it might make sense, but this is not the case 
> > today.  If you
> > once had a good priority because you could get a command through, now
> > you call it when the path is down it will be replaced with an 
> > incorrect
> > one.
> 
> Yes, good point.  The converse of this statement is indeed what my
> patch is trying to prevent.  That is, initially having an incorrect
> priority before the path groups are created then having the good or
> correct priority calculated only after the path groups are already
> created.
> 

One other thought I had was the notion of a "priority valid" flag (or a
special priority value) in the path for the case of group_by_prio.  Set
it to invalid in alloc_path(), then just don't add the path to the
multipath struct in coalesce_paths() if the priority value was invalid.
Then over in checkerloop(), add the path to the multipath map when you
get a valid priority.

It is more complicated than that I'm sure (e.g. checkerloop() assumes
pp->mpp is non-null in places, etc) but seemed like a half-decent
approach to at least consider.

This approach doesn't take into consideration the general case of a
change in path priority though.


> > 
> > Arguably the states are fuzzy and "types of paths" are mixed in with
> > "path states" which leads to the fuzzyness/confusion.  Right 
> > now I don't
> > have a good enough feel for it to offer clarifying suggestions though
> > other than the attached comment patch which tries to clarify 
> > the meaning
> > of each state as it is in the code today.
