From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Wed, 11 Nov 2009 18:35:36 -0500
Message-ID: <20091111233536.GA7502@redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
	<20091111124138.GA24901@redhat.com>
	<Pine.LNX.4.64.0911111530240.32278@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911111530240.32278@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 11 2009 at  3:46pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > > Hi
> > > 
> > > Please drop snapshot-linking through this "handover_snap" field, it will 
> > > create real or possible problems with locking or with dangling pointers 
> > > (i.e. are both properly locked? Which to lock first? If you destroy a 
> > > snapshot, you must check if something links to it, etc. --- these problems 
> > > could be solved, but if they can be avoided by dropping linking, it's 
> > > better to avoid them).
> > 
> > I agree, lock_snapshots_for_handover() is too complicated.  But by dropping
> > these 'handover_snap' associations we'll lose the ability to have tight
> > constraints on what handover will take place on resume of new snapshot
> > (ideally a source of handover will only have one destination).
> > 
> > The new snapshot (destination of exception handover) is not registered
> > with the origin until after resume's handover_exceptions (via
> > register_snapshot).  And therefore it can't be found via
> > find_snapshot_using_cow().  But that is a good thing as we'll know that
> > if find_snapshot_using_cow does return a snapshot then it is the source
> > of the handover.
> 
> It is registered in snapshot_ctr --- that's how it was originally written. 
> So it should be possible to find it.
>
> You moved the registration away? So move it back.

Why?  That would be counter-productive.

register_snapshot() is skipped if handover will be performed.  The
reason is register_snapshot() looks at the store's chunk_size.  Problem
is we don't have the store yet.  Your handover relied on rereading the
snapshot header.  I no longer read_metadata() at all if the store will
be handed over.
 
> I'm somehow concerned, how this simple handover code (that I wrote 1.5 
> years ago, on a train way from Berlin to Prague) is getting more and more 
> complicated, just for handling some "can't happen" cases.

Believe me, I'd rather not be lingering over the finer points of
exception handover; but once I hit the fact that snapshot_ctr() was
imposing that the COW device must not be suspended it opened a can or
worms (lvchange --refresh exposed this, in general it is fair to assume
the cow device isn't suspended in snapshot_ctr :).  

The handover-based snapshot_ctr() needing to access the COW device
begged the followong questions:
why are we reading the snapshot header via read_metadata()?
Why are we doing any IO to the COW if it will just be handed over?

Answer: we don't have a real need, so don't.  Not only that, but
Alasdair asserted read_metadata() must not be called if another snapshot
is already actively using the COW.  What if something else is changing
it at the same time that the new snapshot_ctr() re-reads it?

Anyway, best to avoid all of that (read_metadata and register_snapshot)
if we're doing exception handover.

> First of all, you don't have to handle user's misbehavior --- if the user 
> writes dd if=/dev/zero of=/dev/hda, he loses his data --- there is no need 
> to protect the user from doing it. Similarly, if the user loads bad dm 
> table, he may lose his data too and there is little that can be done.
> 
> You can add protection from double target load as a bonus --- but do it 
> only as long as it doesn't complicate the code. If this protection from 
> double load would complicate the code too much, then don't do it.

I just posted the latest version of the handover patch (v7); it no
longer has 'handover_snap' pointers.  As such the locking is simplified.

It also handles protecting against double target loads.

> Last night, when talking with Alasdair, we found out that the "active" 
> variable could be used as a token --- there could be at most one active 
> snapshot and on handover, you would set "active=0" on the old snapshot and 
> "active=1" on the new snapshot, always enforcing that there is just one 
> snapshot active.

Right, find_snapshot_using_cow() in v7 of the patch does make use of
active to know to overlook a snapshot on the origin's 'snapshots' list
that are not active (snapshot may be left on the list after handover,
snapshot_dtr() hasn't come through yet, but it is both invalid and
inactive).  v7 handover_exceptions() sets: snap_src->active = 0;

> But generally:
> 1. make handover work the simplest way without any protection (like I 
> wrote it).
> 2. add the protection from double load only if it doesn't complicate the 
> code too much (for example, checking that there is just one "active" 
> snapshot should be relatively easy).

I think v7 is fairly robust; I've tested it pretty extensively both
standalone and with the rest of the snapshot-merge patches.  As always
the full snapshot-merge DM patchset is available here:

http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.32/
