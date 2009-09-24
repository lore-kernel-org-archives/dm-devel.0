From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A BUG in snapshot merging
Date: Wed, 23 Sep 2009 20:07:08 -0400
Message-ID: <20090924000707.GA29085@redhat.com>
References: <Pine.LNX.4.64.0909211349480.16230@hs20-bc2-1.build.redhat.com>
	<20090921175655.GA28074@redhat.com>
	<Pine.LNX.4.64.0909211815580.31653@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909221130590.24935@hs20-bc2-1.build.redhat.com>
	<20090922170000.GA1806@redhat.com>
	<20090922192039.GA13465@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090922192039.GA13465@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 22 2009 at  3:20pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Sep 22 2009 at  1:00pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Sep 22 2009 at 12:37pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > I got this BUG when attempting to use merged patchset of Mike's and Jon's 
> > > patches (from 
> > > http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/)
> > > 
> > > I think we shouldn't join these two patchsets together. I mean, before 
> > > clustered patches, merging was stable (I reviewed and tested it and except 
> > > for one userspace bug (already fixed) there were no flaws) ... now it 
> > > doesn't work.
> > > 
> > > I would recommend to leave merging as it was (i.e. stable, apply only 
> > > little patches on it) and develop Jon's clustering on the top of merging 
> > > and not interleave it with merging, so that the clustering patches could 
> > > be rolled back if problems were found. When clustering will be stable and 
> > > reviewed, it could be added to the kernel --- but it may happen later than 
> > > merging, so don't mix it.
> > 
> > 
> > When did you pull in the patches on my people page?
> > 
> > As of yesterday evening (Boston) I uploaded patches that are broken
> > (based on Jon's reworked handover).  I'm now combining your handover
> > with Jon's handover (in hopes of avoiding refactoring associations).
> > 
> > The patches are in flux... I'm working to resolve the issues that are
> > rooted at the handover mechanism.
> > 
> > As for patch ordering.  I'm not opposed to what you suggested (merge
> > first then clusterized).  But that is a secondary concern right now.  We
> > have enough time between now and the next merge window to get them both
> > working.
> 
> Mikulas,
> 
> I've fixed the handover mechanism.  It now reflects the combination of
> both your handover and Jon's (whereby avoiding refactoring
> associations in dm_exception_store and dm_snapshot).
> 
> I've uploaded the updated quilt series to the usual place:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/
> 
> I not sure which BUG() you hit in dm-snap-persistent.c (because my line
> numbers have changed).. but given that it was in merge_callback() I'd
> imagine it is the BUG_ON() that Jon added to clear_exception().
> 
> That BUG_ON() is actually useful.  If you can reproduce it with these
> updated patches it bears further investigation.
> 
> In general, I think snapshot-merge is stronger for having combined with
> Jon's clusterized patches.  I actually prefer the final result more so
> than if the merge patches were to try to stand on their own (Jon's
> refactoring of the exception-store et al has had a positive side-effect
> on snapshot-merge).

Mikulas,

I can easily reproduce the BUG you reported (you were running on
sparc64) if I take the following patch out of the quilt series:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/dm-exstore-persistent-allow-metadata-reread.patch

I've made an adjusted quilt series available here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified_no_reread/2.6.31/

I'll be working to sort this out but I wanted to give you a heads up
that I can now easily reproduce the BUG on x86.  Don't even need to stop
the merge and restart; just a normal merge triggers the BUG after the
first extent of chunks is merged.

Also, I did try to put the snapshot-merge patches before the
exception/exception_table refactor patches but the new handover
mechanism is very tightly coupled with those so I stopped that effort.

And I'm pretty sure you tested a version of the 'kernel_unified' quilt
tree that was using the old "refactored association" patch.  You hit the
BUG with that too (your initial report).

So what it comes down to is we need to track down the problem that the
new exception/exception_table refactor patches seem to have introduced.
Not ideal but we need all these patches to coexist in the end anyway.

If I can't cut through this BUG in the next day I'll think more about
alternative approaches to forward progress.

Mike
