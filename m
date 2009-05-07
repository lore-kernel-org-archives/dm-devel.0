From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Shared snapshots
Date: Thu, 7 May 2009 10:44:33 -0500
Message-ID: <3205269F-5017-4C3B-8E11-AD2162C844EF@redhat.com>
References: <1240610034.7392.284.camel@p670.boston.redhat.com>
	<Pine.LNX.4.64.0904270815420.18227@hs20-bc2-1.build.redhat.com>
	<1240836879.1759.16.camel@p670.boston.redhat.com>
	<Pine.LNX.4.64.0905040741190.20446@hs20-bc2-1.build.redhat.com>
	<15B46C78-2846-43C4-8090-1EC362E24FD7@redhat.com>
	<Pine.LNX.4.64.0905060951010.26165@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0905060951010.26165@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


On May 6, 2009, at 11:06 AM, Mikulas Patocka wrote:

> Hi
>
>> I'd like to state that the point of the refactoring work was not to  
>> reduce the
>> size of the code.  The point was to provide a clear and clean  
>> interface for
>> all exception stores - new and old - and do it in a way that  
>> adheres to the
>> principals of the general device-mapper target API.
>
> First let me write about a possible arguments regarding "cleanness",
> "niceness" etc.
>
> I think that what is really hapenning here is loss of reason.
>
> In general, loss of reason is a cognitive bias that happens in the
> following scenario (not only in software engineering, but in other  
> social
> situations as well):
>
> * people want to reach goal G
> * in order to reach the goal G, people do action A
> * they do it thoroughly, consistently, over the long time
> * now, "loss of reason", an error inside human brain happens: people  
> start
> slowly forgetting about the goal G. And they start viewing the  
> action A as
> being "good", "nice", "right", "the way it should be done"
> * from this point on, people are doing action A even in situations  
> when
> it damages the goal G
> * people's performance decreases, they no longer attempt to reach real
> objective goals, all they want to reach is their own emotion of  
> "niceness"
> inside their head.
>
> Now, how does it apply to our snapshot development scenario?
>
> * programmers want to reduce coding time and maintenance time (goal G)
> * to reach this goal, programmers share their code, they sometimes
> refactor code to be better shareable (action A)
> * it has been done consistently over the long time for various  
> projects
> * now people start considering sharing code and refactoring as "good",
> "clean", "the way software should be written" or whatever. They  
> completely
> forgot about the initial goal that was there (save developers' time)
> * and now we are refactoring the snapshot code even if increases our
> development time, it is not going to save the time in the future,  
> but we
> consider this "right", "clean", "clear", "nice"
>
> Are you getting it how these "universal"/"emotional"/"aesthetic"  
> arguments
> not backed by anything are void?
>
>
> Now, if we ignore the emotional stuff and look at it from the real  
> point
> of view.
>
> Is the refactored code saving development time now?
> - it isn't. It already ate 5 months and it will just eat more before  
> it
> gets functional.

I agree.  I think there will be additional time involved to get the  
refactored code ready.  I also believe that it will take additional  
time to get your current solution ready.  There is also more involved  
here than just development time.  You must also consider the time it  
takes to merge things upstream.  If you are unwilling to make any  
concessions on your code, it is unlikely to go upstream.  Where will  
you be then?

> Will the refactored code be saving maintenance time in the future?
> - it won't. The code is as big as if the refactoring hadn't happened  
> (and
> it'll be just bigger if you imeplement missing functionality).
>
> Anyway, two smaller drivers are better maintainable than one big  
> driver of
> the double size. A person who doesn't understand the code will have to
> read just half of the code to understand the logic if he wants to  
> modify
> one of the smaller drivers. It also reduces testing time, if you  
> modify
> one smaller driver, you are certain that the second driver is intact  
> and
> don't have to test it.

I see (have seen) your point; and while I respectfully disagree, I  
still think I have ideas where we can meet in the middle to come up  
with a solution.  (More on this later.)

> Is your refactored code extensible to other exception stores?
> - true. It is. But it was extensible even before refactoring. Before
> refactoring, one could write any exception store driver (either  
> unshared
> or shared) and plug it into the unshared-master-driver or the
> shared-master-driver. All you did was to join the unshared-master- 
> driver
> and the shared-master-driver to one chunk of code.

You make it sound as though there was a modular interface to begin  
with, but there was not.  Every time a new exception store was added  
in the past, it required new parsing code in the snapshot module, new  
'if' statements to conditionalize for it, etc.  A bunch of patches  
have already been added to improve that situation - all of which were  
part of the refactored code.  If just 2 of the remaining 33 patches in  
my further refactoring are added upstream, then there is no need for  
the snapshot module to parse the exception store arguments.  In fact,  
there is no reason for the snapshot module to know anything about how  
the exception store does its job.

> Any other advantages?

Yes.  It is easier to write/stack/include cluster-aware exception  
store modules.

> Regarding the bugs:
> 56MB origin, 160MB snapshot store (128MB of that are reserved for
> non-existing journal, so it will overflow). Run mkfs.reiserfs on the
> origin. Ends up with a lot of messages like this:
> May  6 13:36:10 slunicko kernel: attempt to access beyond end of  
> device
> May  6 13:36:10 slunicko kernel: dm-5: rw=25, want=1048784,  
> limit=327680
> May  6 13:36:11 slunicko kernel: attempt to access beyond end of  
> device
> May  6 13:36:11 slunicko kernel: dm-5: rw=25, want=1376256,  
> limit=327680
> May  6 13:36:11 slunicko kernel: attempt to access beyond end of  
> device
> and the process stucks in "D" state in
> __wait_on_bit/wait_on_page_writeback_range. Vely likely the bio was  
> lost
> somewhere and never returned with either error or success.
>
> I have found a couple of bugs in Fujita/Daniel's exception store long
> time ago (when I was porting it to my driver), the most serious one I
> found was this:
> @@ -510,7 +510,7 @@ static int read_new_bitmap_chunk(struct
>        chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
>
>        ss->cur_bitmap_chunk++;
> -       if (ss->cur_bitmap_chunk == ss->nr_bitmap_chunks)
> +       if (ss->cur_bitmap_chunk == ss->nr_bitmap_chunks +  
> FIRST_BITMAP_CHUNK)
>                ss->cur_bitmap_chunk = FIRST_BITMAP_CHUNK;
>
>        chunk_io(store, ss->cur_bitmap_chunk, READ, 1,  ss->bitmap);
> ... but it doesn't fix this problem. So there's something else.
>
> Maybe the bad accesses could be due to endianity problems, I use  
> sparc64.
> The lost bio can't be caused by endianity, this needs to be  
> investigated.
>
>
> Writable snapshots:
> create an origin and two snapshots. Write to the origin (it creates  
> shared
> chunk for both snapshots). Write to one of the snapshots to the same
> chunk. The write is lost. Read it again and the data is not there.
>
> In this situation you need to copy the chunk from the snapshot store  
> to
> the snapshot store (you can't copy it from the origin). I was  
> looking for
> the code that handles these snapshot-to-snapshot copies, but I  
> didn't find
> it. So the problem is not some silly typo that could be fixed with one
> line - the problem is that the code to handle it wasn't written.

Thank-you for explaining these bugs.  You are right, the code to  
handle snapshot-to-snapshot copy does not exist!  It should not be  
difficult to fix these bugs.

>> I tried to ensure that all necessary API functions were in place.   
>> Like
>> "suspend", which is not used by any of the legacy exception stores,  
>> but will
>> be useful when it comes time to quiesce a shared exception store  
>> that may be
>> performing a "delete" operation.
>
> You can't do this. "delete" is a long-running operation, it needs to  
> walk
> the whole tree. Stopping an exception store during delete is not
> acceptable on big devices. I have already implemented delete in the
> background, it goes step-by-step and blocks concurrent access only for
> these little steps, so it won't lock the computer up for minutes or  
> hours.
> It can also batch multiple delete requests just into one tree-walk.

Your approach is excellent.  However, it would be unacceptable if it  
cannot cease processing when device-mapper needs it to.  Certainly you  
built in the capability to stop and restart the process?  I am not  
asking for the delete operation to be completed in order to suspend.   
I am asking for the operation to halt for a suspend and continue on  
resume.  This is a fundamental requirement.  How will you know when to  
suspend if you are not informed by a 'suspend' call from the API?

>> Please note, that there probably won't be that much code sharing  
>> between
>> exception store modules; but the snapshot code is completely  
>> agnostic to the
>> type of exception store used.  This allows an infinite variety of  
>> exception
>> stores without change to the snapshot code.  This is also nice  
>> because changes
>> in the snapshot code should not require work in the exception  
>> stores and vise
>> versa. Userspace code should also be reduced due to identical  
>> mechanisms used
>> to communicate and operate snapshots with legacy or future  
>> exception stores -
>> you need only change the constructor arguments.  Backwards  
>> compatibility is
>> improved and the meaning of DM ioctls doesn't change depending on  
>> the target
>> type.  It is a necessity that we have new exception stores, but I  
>> don't think
>> that necessitates a new snapshot target - something which, I think,  
>> would
>> increase our maintenance costs because we now support two entirely  
>> different
>> snapshot implementations.
>>
>> We absolutely need your exception store - there is no question  
>> about that.  I
>
> But it is not possible now. What it lacks:
> - the snapshot ids are submitted by the user (in my implementation,  
> the
> exception store itself must make the snapshot id, it is design thing  
> that
> can't be changed)

Really?  It can't be changed?  I think it would be great if you added  
a translation table.  Userspace would pass down a number/name/UUID (it  
doesn't really matter, as long as it is unique among the shared  
snapshots for a given COW device), then your exception store could  
make its own "snapshot id" and associate it with what userspace has  
given it.

This translation table could clean up a number of complaints that we  
have had about your implementation.  Now, all you should need is a  
simple CTR + RESUME to get a snapshot device going - same as the  
legacy snapshot targets and every other device-mapper target without  
exception.  There would no longer be a need to use 'message' to create  
a snapshot and then a further CTR+RESUME to instantiate it.

Additional benefits could be gained from this.  I no longer see a need  
to have the origin constructor changed...  Now things seem to be  
coming more in-line with the way the userspace/kernel interface was in  
the past.  That should simplify userspace coding.

Just this one thing could fix so many complaints... can you not do this?

> - it lacks read-once-write-many copies (they are needed only on my  
> store,
> not on Fujita-Daniel's store)

I need to understand this better.  Perhaps you could help me?  This  
could be your greatest argument.  It would not deter me from asking  
for a exception store/snapshot boundary API, nor will it deter me from  
demanding better userspace/kernel boundary compliance.  However, it  
may make me realize that retrofitting the old snapshot module to also  
be able to handle shared exception stores is not the best.  (This  
would require me to remove 2 of the 33 outstanding patches I have  
posted.)

If you help me, I will probably understand this code more quickly.   
Otherwise, it will take me longer.  If I can see no solution, I will  
very easily accept that the current snapshot module is not the place  
to handle shared exception stores.  I have to warn you though... I can  
be good at finding solutions to problems.

> - it lacks snapshot-to-snapshot copies for writable snapshots (for
> Fujita-Daniel's code you need just one copy, for my code you need at  
> most
> two).

I think there are solutions to this that are not that complicated.

> - it lacks the possibility to re-submit bios to the exception store  
> to do
> more relocations after some of the relocations have been finished. (in
> extreme cases of many writes to the snapshots, there may be many
> relocations on my exception store --- it is no need to optimize for  
> these
> cases, but they must be handled correctly).

I also would like to understand this limitation more.

> - lame delete that blocks the whole device.

What?  There is no reason to block the whole device for a delete -  
that is an exception store implementation detail that has nothing to  
do with the snapshot module or the exception store API.

>> agree with your complaints about the short-comings of the shared  
>> exception
>> store that was ported to the interface (e.g. it has no journaling,  
>> 64 share
>> limit before needing a new store, memory issues).  I ported the  
>> shared
>> exception store to the interface (along with creating a cluster-aware
>> exception store) so I could feel confident that I got the interface  
>> correct.
>> The "shared" exception store should not be viewed as complete; even  
>> though I
>> think the exception store interface is.  Please refrain from  
>> judging the API
>> based on incompleteness in the implementation of one exception store.
>
> This is not about lameness of Fujita's code. What I mean is that your
> interface is too tied on Fujita-Daniel's store. It is not just easy  
> that
> you take my store and plug it in. It still needs many generic  
> changes. It
> is not as beautiful as you described it that it is "completely  
> agnostic to
> the type of exception store used". And I am concerned --- why spend  
> more
> time making the changes, if generic driver that has them is already
> written?

Now trying to aggregate comments... see below.

>
>
>> [However, I have tested the "shared" exception store and did not  
>> suffer from
>> the same problems you did.  I would be interested to have you fill  
>> me in on
>> the problems you encountered - "doesn't support writable snapshots  
>> correctly,
>> it deadlocks when the exception store overflows, it prints warnings  
>> about
>> circular locking"].  I believe I have the interface correct, and I  
>> am not
>> aware of changes that would have to be made to accommodate your  
>> exception
>> store.
>>
>> I also think you have a number of great ideas in your higher level  
>> snapshot
>> code.  I'd love to see these added to the current snapshot module.   
>> I would
>> even be willing to abandon the current snapshot module and make  
>> yours the only
>> one in the kernel iff it adhered to the following principals:
>>
>> 1) It is completely agnostic to all legacy and future exception  
>> stores
>
> My code does support all existing and possible future shared
> snapshots. It doesn't support non-shared snapshots. They are well
> implemented already and there is no reason to reinvent the wheel.

Now trying to aggregate comments... see below.

>
>
>> (e.g.
>> it should know nothing about snapid's and such, as this information  
>> aids in
>> how/where an exception store places data - something that should be  
>> known only
>> to the exception store implementation)  Without a clean break, the  
>> API is
>> meaningless.
>
> My code works in such a way that the kernel creates a snapid, it  
> passes it
> to the userspace, the userspace is supposed to store the snapid in  
> its lvm
> metadata and passes it back to the kernel. The userspace views the  
> snapid
> as an opaque value --- it doesn't look at the snapid, it just passes  
> it
> back and forth.
>
> If you wanted to change it to uuids in the kernel, it is changeable.

Now trying to aggregate comments... see below.

>
>
>> 2) The current meaning of DM ioctls is preserved.  We shouldn't  
>> have to
>> create/resume a snapshot device and then use messages or other  
>> mechanisms to
>> instantiate the shares.  This slippery slope leads us to a place  
>> where each
>> target gets to choose its userspace interaction and the defined  
>> functions for
>> that purpose become meaningless.
>
> It is changeable to uuids if the kernel maintained uuid->snapid
> translation table in the exception store. It is possible, thought we  
> must
> know why. "snapids are submitted by userspace" is not possible.
>
>> Ultimately, I think the exception store API that I have put in  
>> place would be
>> the glue between the upper snapshot layer and the lower exception  
>> store
>> modules - whatever generation of these layers happens to exist.  I  
>> believe the
>> API follows in the models laid down by the dm-raid1/log and
>> multipath/read-balance interfaces.  I think this API is a natural and
>> necessary progression.
>>
>> I would also take issue with the fact that if the code size is  
>> increased, it
>> decreases maintainability.  I think maintainability is improved  
>> with the clean
>> separation of snapshot code and exception store modules; just as I  
>> think
>> maintainability is improved by having a file system switch that  
>> separates the
>> different file systems and provides a clean method for them to  
>> communicate
>> with higher layers.
>>
>> I welcome further thoughts,
>> brassow
>
> Why don't do this refactoring and why not have common driver for  
> shared
> and non-shared exception store? - it already took 5 months, it is  
> still
> incomplete and needs non-trivial changes to be at least as  
> functional as
> if this hadn't happened at all.
>
> If you're still thinking about "cleanness", read the first paragraph  
> about
> loss of reason again. Back into reality --- if you spend 5 months
> shuffling code around without adding any functionality it is only
> reasonable to do it if it will save more than 5 months in the long  
> term.
> And it won't.
>
> It is no shame, it occasionaly happens to anyone. To me it happened on
> other projects too that I had these feelings "wow, it will be super  
> clean
> and easy" and when I got into typing the code, it turned out that it  
> is
> much more time-consuming that I anticipated. And when it happend to  
> me, I
> erased the code and changed my perception of "cleanness" - it's the  
> only
> thing one can do.

Final comments...

You and I are in agreement that we don't want to waste time; and  
certainly, there is no time to waste.  We want a good solution.  Let  
us figure out what we both want; and determine from there what pieces  
of code we can keep and what needs to be adjusted.  I will start...

Here is what I demand:
#1) A clean API that separates the snapshot module and the exception  
store implementations.  This facilitates others who wish to write new  
exception stores - including me, who is responsible for writing the  
cluster-aware exception store.  I would appreciate it if some  
forethought was given to cluster implementations.  I am not saying  
that there cannot be a "shared" API and a "non-shared" API.  Go ahead,  
write your own - it shouldn't take too long.  I'd like to think that  
there can be one API that can satisfy the needs of both (perhaps even  
with a flag that signifies "shared" vs "non-shared if necessary?).  I  
will continue to think that it is possible to make this happen until I  
am proved or can prove to myself otherwise.  This does /not/ mean I  
will block any attempts to do something other than a singular, all- 
inclusive API.

#2) Don't break the current model of userspace/kernel interaction  
unless it is absolutely necessary.  'delete'ing a single snapshot from  
a share exception store is *potentially* one of these cases (although  
I can think of good solutions).  Right now, when we want to delete a  
snapshot, we simply wipe the COW device - obviously, this doesn't work  
when the COW is shared.  However, forcing userspace to know about  
snapid's which are generated by the kernel and overloading the message  
function is not acceptable.  I think there is also much room for  
improvement once that is fixed to minimize changes to the constructor  
tables and reduce the burden on user-space tools.

Here is what I am willing to sacrifice if it proves necessary:
#1) I am willing to give in on having two snapshot modules.  I have  
always stated this as a possibility.  It is very possible that it  
makes more sense this way instead of having one snapshot module be  
able to interact with all exception stores.  This is even more  
palatable if you consider that the legacy snapshots will be largely  
abandoned.  This would mean abandoning some of the patches I've posted  
upstream, but others still remain quite useful.  More than one  
snapshot-merge target might be required in this case.  There are a  
number of other disadvantages to this that I (maybe not others) would  
be willing to set aside based solely on your word that the advantages  
outweigh the disadvantages.

#2) I am willing to put in any extra work required to write the  
cluster-aware modules - even if two APIs and two snapshot modules end  
up being required.

Mikulas, I get the sense that you have looked at the API with a quick  
mind of why it can't be done, instead of whether it can be done.  The  
conclusions may ultimately be the same; but I am asking you to take a  
look and see what *can* be done.  What compromises can be made?  How  
far are you willing to come?  I don't think my base demands are too  
much to ask, nor do I think they materially differ from what is  
required for upstream inclusion.

Thanks for your continued effort on this,
  brassow
