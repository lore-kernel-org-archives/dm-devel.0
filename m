From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Mon, 22 Jun 2009 21:10:37 +0200
Message-ID: <1245697837.7390.456.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o> <19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19006.8756.925105.737041@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Sun, 2009-06-21 at 22:06 +1000, Neil Brown wrote:
> On Friday June 19, heinzm@redhat.com wrote:
> > On Fri, 2009-06-19 at 11:43 +1000, Neil Brown wrote:
> > > On Wednesday June 17, neilb@suse.de wrote:
> > > > 
> > > > I will try to find time to review your dm-raid5 code with a view to
> > > > understanding how it plugs in to dm, and then how the md/raid5 engine
> > > > can be used by dm-raid5.
> > 
> > Hi Neil.
> > 
> > > 
> > > I've had a bit of a look through the dm-raid5 patches.
> > 
> > Thanks.
> > 
> > > 
> > > Some observations:
> > > 
> > > - You have your own 'xor' code against which you do a run-time test of
> > >   the 'xor_block' code which md/raid5 uses - then choose the fasted.
> > >   This really should not be necessary.  If you have xor code that runs
> > >   faster than anything in xor_block, it really would be best to submit
> > >   it for inclusion in the common xor code base.
> > 
> > This is in because it actually shows better performance regularly by
> > utilizing cache lines etc. more efficiently (tested on Intel, AMD and
> > Sparc).
> > 
> > If xor_block would always have been performed best, I'd dropped that
> > optimization already.
> 
> I'm no expert on this I must admit - I just use the xor code that
> others have provided.
> However it is my understanding that some of the xor code options were
> chosen deliberately because they bypassed the cache.  As the xor
> operation operates on data that very probably was not in the cache,
> and only touches it once, and touches quite a lot of data, there is
> little benefit having in the cache, and a possible real cost as it
> pushes other data out of the cache.
> 
> That said, the "write" process involves copying data from a buffer
> into the cache, and then using that data as a source for xor.  In that
> case the cache might be beneficial, I'm not sure.
> I've occasionally wondered if it might be good to have an xor routine
> that does "copy and xor".   This would use more registers than the
> current code so we could possibly process fewer blocks at a time, but
> we might be processing them faster.  In that case, if we could bypass
> the cache to read the data, but use the cache to store the result of
> the xor, that would be ideal.  However I have no idea if that is
> possible.
> 
> The mechanism you use, which is much the same as the one used by
> xor_block, calculates speed for the hot-cache case.  It is not clear
> that this is often a relevant cache - mostly xor is calculated when
> the cache is cold.  So it isn't clear if it is generally applicable.
> That is why calibrate_xor_blocks sometimes skips the xor_speed test
> (in crypto/xor.c).

I can actually perform cold cache runs likely with a little code change
which should allow us to empirically find out, if my optimization is
worth it.

Not sure though, if I'll be able to do this before heading out to
LinuxTag for the rest of this week.

> 
> However if your code performs better than the cache-agnostic code in
> xor_block, then we should replace that code with your code, rather
> than have two places that try to choose the optimal code.

Sure, we'll see after some more investigation.

For the time being, it can stay in the raid45 target until we either
come to the conclusion that it should get moved underneath crypto's
generic API or get dropped altogether.

> 
> And I would be very interested to see a discussion about how relevant
> the cache bypassing is in real life...  It looks like it was Zach
> Brown who introduced this about 10 years ago, presumably in
> consultation with Ingo Molnar.
> 
> > 
> > > 
> > > - You have introduced "dm-message" which is a frame work for sending
> > >   messages to dm targets.
> > 
> > dm-message is a parser for messages sent to a device-mapper targets
> > message interface. It aims at allowing common message parsing functions
> > to be shared between targets.
> > 
> > The message interface in general allows for runtime state changes of
> > targets like those you found below.
> > 
> > See "dmsetup message ..."
> > 
> > > It is used for adjusting the cache size,
> > >   changing the bandwidth used by resync, and doing things with
> > >   statistics.  Linux already has a framework for sending messages to
> > >   kernel objects.  It is called "sysfs".  It would be much nicer if
> > >   you could use that.
> > 
> > Looks to me like heavier to program (I counted ~100 LOC of sysfs defines
> > and calls in md.c) for 3 files used in md.
> > 
> > That needs some more discussion.
> 
> In dm-raid45 you have 170 lines from "Message interface" to "END
> message interface", which is 4 files I think.  Am I counting the same
> things?

Yes.

> 
> In any case, it is certainly possible that sysfs usage could be
> improved.  We recently added strict_blocks_to_sectors() which extracted
> a common parsing task.  Once upon a time, we open coded things with
> simple_strtoull and repeated the error checking every time.
> There is always room for improvement.
> 
> But I think the uniformity across the kernel is the most important
> issue here, not the lines of code.

Well, it should be balanced between this possibly exclusive extremes.

Nobody wants to add huge amounts of codes to maintain just to allow for
uniformity without enhancing shared code upfront.

> 
> There is a bit of tension here:  your dm-message approach is similar
> in style to the way targets are created.  The sysfs approach is
> similar in style to many other parts of the kernel.  So should your
> new mechanism be consistent with dm or consistent with linux - it
> cannot easily be both.
> 
> This is really a question that the dm developers as a group need to
> consider and answer.  I would like to recommend that transitioning
> towards more uniformity with the rest of linux is a good idea, and
> here is excellent opportunity to start.  But it isn't my decision.

We're meeting in Berlin at LinuxTag so this is going to be an item
there...

> 
> > > - Your algorithm for limiting bandwidth used by resync seems to be
> > >   based on a % concept (which is rounded to the nearest reciprocal,
> > >   so 100%, 50%, 33%, 25%, 20%, 16% etc).  If there is outstanding
> > >   IO, the amount of outstanding resync IO must not exceed the given
> > >   percentage of regular IO.   While it is hard to get resync "just
> > >   right", I think this will have some particularly poor
> > >   characteristics.
> > 
> > My ANALYZEME pointed you there ? ;-)
> > That's why it's in. I admitted with that that I'm not satisfied with the
> > characteristics yet.
> 
> Fair enough.
> My concern then is that the mechanism for guiding the speed - which is
> not yet finalised - is being encoded in the command for creating the
> array.  That would make it difficult to change at a later date.
> I would suggest not specifying anything when creating the array and
> insisting that a default be chosen.

It is not mandatory to specify already and a default will be set.
I'm not aware of any application utilizing it yet.

> Then you can experiment with mechanism using different dm-message or
> sysfs-files with some sort of warning that these are not part of the
> api yet.

I got that freedom already with the tiny flaw of an optional paramter
being supported. If this is perceived to be bad, I can surely drop it.

> 
> > > 
> > >   Also it does not take account of IO to other partitions on a device.
> > >   It is common to have a number of different arrays on the same device
> > >   set.  You really want to resync to back off based on IO to all of
> > >   the device, not just to the array.
> > 
> > Does MD RAID > 0 cope with that in multi-partition RAID configs ?
> > E.g.:
> > disk1:part1+disk2:part1 -> md0 and disk1:part2+disk2:part2 -> md1 with
> > global iostats for disk[12] ?
> 
> Yes.  'gendisk' has 'sync_io' specifically for this purpose.
> When md submits IO for the purpose of resync (or recovery) it adds a
> count of the sectors to this counter.  That can be compared with the
> regular io statistics for the genhd to see if there is an non-sync IO
> happening.  If there is the genhd is assumed to be busy and we backoff
> the resync.
> 
> This is not a perfect solution as it only goes one level down.
> If we had raid1 over raid0 over partitions, then we might not notice
> resync IO from elsewhere properly.  But I don't think I've ever had a
> complaint about that.

Thanks for the explanation.

> 
> > > 
> > > Everything else could be made available by md to dm with only a
> > > moderate amount of effort.
> > > Of the different interface routines you require:
> > > +	.ctr = raid_ctr,
> > > 
> > >   This would be quite straight forward, though it might be worth
> > >   discussing the details of the args passed in.
> > >   "recovery_bandwidth" (as I say above) I don't think is well chosen,
> > 
> > I was aware it needs further tweaking (your points above taken).
> > 
> > You mean the wording here ?
> 
> The thing that I don't think was well chosen was the choice of a
> percentage to guide the speed of resync.

I actually like percent of total bandwidth, because it allows for
maximum throughput when there's no application IO while limiting to the
respective and adjustable bandwidth percentage during application IO.

If the set is moved to other HW with different bandwidth, this still
holds up, whereas absolute throughput changes the ratio.

Of course, we could support both absolute and relative.

> 
> > 
> > >   and I don't quite see the point of io_size (maybe I'm missing
> > >   something obvious)
> > 
> > Performance related. I studied read ahead/chunk size/io size pairs and
> > found examples of better performance with io_size > PAGE_SIZE <=
> > chunk_size. io_size being 2^N.
> > 
> > Do you have similar experiences to share with MD RAID ?
> 
> My position has always been that it is up to lower layers to combine
> pages together.  md/raid5 does all IO in pages.  If it is more
> efficient for some device to do multiple pages as a time, it should
> combine the pages.

I can share that standpoint but had differing tests showing otherwise.

> 
> The normal plugging mechanisms combined with the elevator should be
> enough for this.

Will make a series of tests when I get to this in order to finally
decide how to go about it.

> 
> We have put more focus in to gathering write-pages into whole strips
> so that no pre-reading is needed - we can just calculate parity and
> write.  This has a significant effect on throughput.

Yes, the raid45 target does the same.
It's a huge win to avoid the read before write penalty altogether, when
a stripe gets completely written over.

> (A 'strip' is like a 'stripe' but it is one page wide, not one chunk
> wide).
> 
> > > +	.presuspend = raid_presuspend,
> > > 
> > >   I call this 'quiesce'
> > > 
> > > +	.postsuspend = raid_postsuspend,
> > > 
> > >   I'm not sure exactly how this fits in.  Something related to the 
> > >   log...
> > 
> > We use these distinct presuspend/postsuspend methods in order to allow
> > for targets to distinguish flushing any io in flight in presuspend and
> > release/quiesce/... any resource (e.g. quiesce the dirty log) utilized
> > in the first step in postsuspend.
> > 
> > If MD RAID doesn't need that, stick with presuspend.
> 
> OK, thanks.
> 
> > > +	.message = raid_message,
> > > 
> > >   As I said, I would rather this didn't exist.
> > 
> > I think its better to offer options to be utilized for different
> > purposes. Tradeoff is always (some) overlap.
> > 
> > We don't have one filesystem for all use cases ;-)
> > 
> 
> No...  I find myself wearing several hats here.
> 
> As a developer, I think it is great that you are writing your own
> raid5 implementation.  Doing stuff like that is lots of fun and a
> valuable learning experience.  As I read though the code there were a
> number of time when I thought "that looks rather neat".

Thanks :-)

> Quite
> possibly there are ideas in dm-raid5 that I could "steal" to make
> md/raid5 better.

I wouldn't bet you ain't do that ;-)

> dm-message certainly has its merits too (as I said, it fits the dm model).
> 
> As a member of the linux kernel community, I want to see linux grow
> with a sense of unity.  Where possible, similar tasks should be
> addressed in similar ways.  This avoid duplicating mistakes, eases
> maintenance, and makes it easier for newcomers to learn.  Establishing
> Patterns and following them is a good thing.  Hence my desire to
> encourage the use of sysfs and a single xor implementation.

Understandable/sharable standpoint. Takes us back to the dm team
discussion mentioned above.

> 
> As an employee of a company that sells support, I really don't want a
> profusion of different implementations of something that I am seen as
> an expert in, as I know I'll end up having to support all of them.
> So for very selfish reasons, I'd prefer fewer versions of NFS, fewer
> file-systems, and fewer raid5 implementations :-)
> Well... fewer that we contract to support anyway.
> 

We might end up with one...

But we can take advantage of impulses from different implementations to
help better solutions, which ain't happen if there's just one.

> > > 
> > >  I suspect, using your model, the approach would be a 'dm-message'
> > >  acknowledging that a given device is faulty.  I would, of course,
> > >  rather this be done via sysfs.
> > > 
> > >  I will try to look at factoring out the md specific part of md/raid5
> > >  over the next few days (maybe next week) and see how that looks.
> > 
> > That'll be interesting to see how it fits into the device-mapper
> > framework
> > 
> > I take it You'll port code to create an "md-raid456" target ?
> 
> That's the idea.  I'll let you know when I have something credible.

Ok, We were thinking alike.

Regards,
Heinz

> 
> Thanks,
> NeilBrown
