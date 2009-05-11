From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots
Date: Mon, 11 May 2009 06:44:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905110548140.17497@hs20-bc2-1.build.redhat.com>
References: <1240610034.7392.284.camel@p670.boston.redhat.com>
	<Pine.LNX.4.64.0904270815420.18227@hs20-bc2-1.build.redhat.com>
	<1240836879.1759.16.camel@p670.boston.redhat.com>
	<Pine.LNX.4.64.0905040741190.20446@hs20-bc2-1.build.redhat.com>
	<15B46C78-2846-43C4-8090-1EC362E24FD7@redhat.com>
	<Pine.LNX.4.64.0905060951010.26165@hs20-bc2-1.build.redhat.com>
	<3205269F-5017-4C3B-8E11-AD2162C844EF@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3205269F-5017-4C3B-8E11-AD2162C844EF@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> > Is your refactored code extensible to other exception stores?
> > - true. It is. But it was extensible even before refactoring. Before
> > refactoring, one could write any exception store driver (either unshared
> > or shared) and plug it into the unshared-master-driver or the
> > shared-master-driver. All you did was to join the unshared-master-driver
> > and the shared-master-driver to one chunk of code.
> 
> You make it sound as though there was a modular interface to begin with, but
> there was not.  Every time a new exception store was added in the past, it
> required new parsing code in the snapshot module, new 'if' statements to
> conditionalize for it, etc.

And if you want my exception store, you also need a set of patches to the 
generic code. You haven't made it any better - and no one can make it 
better - when someone else implements something completely new, more 
changes to the generic code will be needed.

> A bunch of patches have already been added to
> improve that situation - all of which were part of the refactored code.  If
> just 2 of the remaining 33 patches in my further refactoring are added
> upstream, then there is no need for the snapshot module to parse the exception
> store arguments.  In fact, there is no reason for the snapshot module to know
> anything about how the exception store does its job.

There are generic command-line arguments and arguments specific to the 
exception store. That's how I already wrote it.

> > Any other advantages?
> 
> Yes.  It is easier to write/stack/include cluster-aware exception store
> modules.

Why stack? The exception store makes sometimes some actions on its own. If 
you stack anything on the top of it, you won't make it cluster-aware.

All you need for clustering is to write a lock module that has these 
functions:

- take the lock (in the return code it indicates whether the lock was held 
by another node in the cluster since the last release --- so that cache 
flush can be implemented)
- release the lock
- ask if someone is competing for the lock (in case of merging/background 
delete, we must hand over the store to another node if it wants to do 
something)

This lock can then be plugged into all the exception stores and make them 
clustered (it could be plugged even to the old non-shared store --- when 
"take the lock" function indicates that someone held the lock meanwhile, 
the non-shared store could just read possible exceptions that the other 
node created and go on).

You don't want to develop new cluster exception store or new layer! All 
you need to develop is the lock.

> > You can't do this. "delete" is a long-running operation, it needs to walk
> > the whole tree. Stopping an exception store during delete is not
> > acceptable on big devices. I have already implemented delete in the
> > background, it goes step-by-step and blocks concurrent access only for
> > these little steps, so it won't lock the computer up for minutes or hours.
> > It can also batch multiple delete requests just into one tree-walk.
> 
> Your approach is excellent.  However, it would be unacceptable if it cannot
> cease processing when device-mapper needs it to.  Certainly you built in the
> capability to stop and restart the process?

Yes, it stores the current point in the commit block, so in case of driver 
unload or crash, it resumes where it left.

> I am not asking for the delete
> operation to be completed in order to suspend.  I am asking for the operation
> to halt for a suspend and continue on resume.  This is a fundamental
> requirement.  How will you know when to suspend if you are not informed by a
> 'suspend' call from the API?

There is no table reload needed now, so I don't have suspend. Maybe it 
will change with clustering and I'll split the initialization into two 
parts: allocate structures (done in the constructor) and read data (done 
in resume).

> > > We absolutely need your exception store - there is no question about that.
> > > I
> > 
> > But it is not possible now. What it lacks:
> > - the snapshot ids are submitted by the user (in my implementation, the
> > exception store itself must make the snapshot id, it is design thing that
> > can't be changed)
> 
> Really?  It can't be changed?  I think it would be great if you added a
> translation table.  Userspace would pass down a number/name/UUID (it doesn't
> really matter, as long as it is unique among the shared snapshots for a given
> COW device), then your exception store could make its own "snapshot id" and
> associate it with what userspace has given it.
> 
> This translation table could clean up a number of complaints that we have had
> about your implementation.  Now, all you should need is a simple CTR + RESUME
> to get a snapshot device going - same as the legacy snapshot targets and every
> other device-mapper target without exception.  There would no longer be a need
> to use 'message' to create a snapshot and then a further CTR+RESUME to
> instantiate it.

I'll write the userspace lvm code and if I find out that it'd be better to 
implement the translation table in the kernel instead of in the userspace, 
I'll do it. So far, I'm undecided on this.

> Additional benefits could be gained from this.  I no longer see a need to have
> the origin constructor changed...  Now things seem to be coming more in-line
> with the way the userspace/kernel interface was in the past.  That should
> simplify userspace coding.
> 
> Just this one thing could fix so many complaints... can you not do this?
> 
> > - it lacks read-once-write-many copies (they are needed only on my store,
> > not on Fujita-Daniel's store)
> 
> I need to understand this better.  Perhaps you could help me?  This could be
> your greatest argument.  It would not deter me from asking for a exception
> store/snapshot boundary API, nor will it deter me from demanding better
> userspace/kernel boundary compliance.  However, it may make me realize that
> retrofitting the old snapshot module to also be able to handle shared
> exception stores is not the best.  (This would require me to remove 2 of the
> 33 outstanding patches I have posted.)
> 
> If you help me, I will probably understand this code more quickly.  Otherwise,
> it will take me longer.  If I can see no solution, I will very easily accept
> that the current snapshot module is not the place to handle shared exception
> stores.  I have to warn you though... I can be good at finding solutions to
> problems.

My store is b+-tree that contains (old chunk number, starting snapshot id, 
ending snapshot id, new chunk number) (struct dm_multisnap_bt_entry). So 
it can share only chunks in consecutive ranges of snapshot ids. Snapshot 
ids are assigned sequentially. If there were no writing to the snapshots, 
the sharing would be always perfect --- i.e. chunks would be always shared 
if they could be.

But if you write to the snapshot, the sharing becomes imperfect. Suppose 
that you have snapshots 1,2,3,4,5. You write to snapshot 3. You create 
record for range (3-3). Now you write to the origin. In this case there 
must be two chunks allocated and two copies performed, one for range (1-2) 
and the other for range (4-5).

kcopyd can performa up to 8 simultaneous writes, so I use this 
functionality. I make kcopyd call that reads it once and makes several 
writes.

> > - it lacks snapshot-to-snapshot copies for writable snapshots (for
> > Fujita-Daniel's code you need just one copy, for my code you need at most
> > two).
> 
> I think there are solutions to this that are not that complicated.
> 
> > - it lacks the possibility to re-submit bios to the exception store to do
> > more relocations after some of the relocations have been finished. (in
> > extreme cases of many writes to the snapshots, there may be many
> > relocations on my exception store --- it is no need to optimize for these
> > cases, but they must be handled correctly).
>
> I also would like to understand this limitation more.

See the above paragraph. If it is needed to copy to more than 8 places, I 
just fill all 8 slots, submit it to kcopyd, and when it finishes, I 
resubmit the bio to the entry path, do lookup for new copies again and if 
there are more, fill up to 8 new jobs to kcopyd ... and so on, until it is 
processed.

Note that this only happens if someone writes to the snapshots, if not, 
there'll be always perfect sharing and at most one copy.

> > Why don't do this refactoring and why not have common driver for shared
> > and non-shared exception store? - it already took 5 months, it is still
> > incomplete and needs non-trivial changes to be at least as functional as
> > if this hadn't happened at all.
> > 
> > If you're still thinking about "cleanness", read the first paragraph about
> > loss of reason again. Back into reality --- if you spend 5 months
> > shuffling code around without adding any functionality it is only
> > reasonable to do it if it will save more than 5 months in the long term.
> > And it won't.
> > 
> > It is no shame, it occasionaly happens to anyone. To me it happened on
> > other projects too that I had these feelings "wow, it will be super clean
> > and easy" and when I got into typing the code, it turned out that it is
> > much more time-consuming that I anticipated. And when it happend to me, I
> > erased the code and changed my perception of "cleanness" - it's the only
> > thing one can do.
> 
> Final comments...
> 
> You and I are in agreement that we don't want to waste time; and certainly,
> there is no time to waste.  We want a good solution.  Let us figure out what
> we both want; and determine from there what pieces of code we can keep and
> what needs to be adjusted.  I will start...
> 
> Here is what I demand:
> #1) A clean API that separates the snapshot module and the exception store
> implementations.  This facilitates others who wish to write new exception
> stores - including me, who is responsible for writing the cluster-aware
> exception store.  I would appreciate it if some forethought was given to
> cluster implementations.  I am not saying that there cannot be a "shared" API
> and a "non-shared" API.  Go ahead, write your own - it shouldn't take too
> long.

I have already did.

I started with my exception store only. Later I refactored it to handle 
both my and Fujita's code. This refactoring took me only one week.

> I'd like to think that there can be one API that can satisfy the needs
> of both (perhaps even with a flag that signifies "shared" vs "non-shared if
> necessary?).

This is what you did, but the shared driver is as big as both the smaller 
drivers. So there is no advantage from it.

> I will continue to think that it is possible to make this happen
> until I am proved or can prove to myself otherwise.  This does /not/ mean I
> will block any attempts to do something other than a singular, all-inclusive
> API.
> 
> #2) Don't break the current model of userspace/kernel interaction unless it is
> absolutely necessary.  'delete'ing a single snapshot from a share exception
> store is *potentially* one of these cases (although I can think of good
> solutions).  Right now, when we want to delete a snapshot, we simply wipe the
> COW device - obviously, this doesn't work when the COW is shared.  However,
> forcing userspace to know about snapid's which are generated by the kernel and
> overloading the message function is not acceptable.  I think there is also
> much room for improvement once that is fixed to minimize changes to the
> constructor tables and reduce the burden on user-space tools.

This is too one sided view. The lookup code will be written either in the 
kernel or in the userspace. It has to be written anyway.

I won't argue about "what would be easier if someone were writing the 
userspace code". I'll just start writing the userspace code now. If I get 
intense feeling that snapids and create message are complicating it too 
much, I'll implement the lookup in the kernel.

Keep in mind that the task here is not to create some emotion of 
"cleanness", but to save coding time.

> Here is what I am willing to sacrifice if it proves necessary:
> #1) I am willing to give in on having two snapshot modules.  I have always
> stated this as a possibility.  It is very possible that it makes more sense
> this way instead of having one snapshot module be able to interact with all
> exception stores.  This is even more palatable if you consider that the legacy
> snapshots will be largely abandoned.  This would mean abandoning some of the
> patches I've posted upstream, but others still remain quite useful.  More than
> one snapshot-merge target might be required in this case.  There are a number
> of other disadvantages to this that I (maybe not others) would be willing to
> set aside based solely on your word that the advantages outweigh the
> disadvantages.
> 
> #2) I am willing to put in any extra work required to write the cluster-aware
> modules - even if two APIs and two snapshot modules end up being required.

See above --- don't write the clustered exception store layer, write the 
cluster lock. The lock can be with little cost plugged into both old and 
new snapshots.

> Mikulas, I get the sense that you have looked at the API with a quick mind of
> why it can't be done, instead of whether it can be done.  The conclusions may
> ultimately be the same; but I am asking you to take a look and see what *can*
> be done.  What compromises can be made?  How far are you willing to come?  I
> don't think my base demands are too much to ask, nor do I think they
> materially differ from what is required for upstream inclusion.

I'm not saying that your code won't work. If you put a couple of months 
into it, you could definitely make it work. But why doing it if it's 
already done?

If you want to do something useful, you can clean-up deficiencies in the 
Fujita's code and implement journal in it. Or you can write that cluster 
lock as I proposed above, and when I finish the userspace code, I'll plug 
in into the kernel driver.

I'm just suggesting that you shouldn't waste more time shuffling code 
around.

Mikulas

> Thanks for your continued effort on this,
> brassow
