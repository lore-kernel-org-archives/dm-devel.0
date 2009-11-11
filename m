From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Wed, 11 Nov 2009 15:46:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911111530240.32278@hs20-bc2-1.build.redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
	<20091111124138.GA24901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091111124138.GA24901@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

> > Hi
> > 
> > Please drop snapshot-linking through this "handover_snap" field, it will 
> > create real or possible problems with locking or with dangling pointers 
> > (i.e. are both properly locked? Which to lock first? If you destroy a 
> > snapshot, you must check if something links to it, etc. --- these problems 
> > could be solved, but if they can be avoided by dropping linking, it's 
> > better to avoid them).
> 
> I agree, lock_snapshots_for_handover() is too complicated.  But by dropping
> these 'handover_snap' associations we'll lose the ability to have tight
> constraints on what handover will take place on resume of new snapshot
> (ideally a source of handover will only have one destination).
> 
> The new snapshot (destination of exception handover) is not registered
> with the origin until after resume's handover_exceptions (via
> register_snapshot).  And therefore it can't be found via
> find_snapshot_using_cow().  But that is a good thing as we'll know that
> if find_snapshot_using_cow does return a snapshot then it is the source
> of the handover.

It is registered in snapshot_ctr --- that's how it was originally written. 
So it should be possible to find it.

You moved the registration away? So move it back.

I'm somehow concerned, how this simple handover code (that I wrote 1.5 
years ago, on a train way from Berlin to Prague) is getting more and more 
complicated, just for handling some "can't happen" cases.

First of all, you don't have to handle user's misbehavior --- if the user 
writes dd if=/dev/zero of=/dev/hda, he loses his data --- there is no need 
to protect the user from doing it. Similarly, if the user loads bad dm 
table, he may lose his data too and there is little that can be done.

You can add protection from double target load as a bonus --- but do it 
only as long as it doesn't complicate the code. If this protection from 
double load would complicate the code too much, then don't do it.

Last night, when talking with Alasdair, we found out that the "active" 
variable could be used as a token --- there could be at most one active 
snapshot and on handover, you would set "active=0" on the old snapshot and 
"active=1" on the new snapshot, always enforcing that there is just one 
snapshot active.

But generally:
1. make handover work the simplest way without any protection (like I 
wrote it).
2. add the protection from double load only if it doesn't complicate the 
code too much (for example, checking that there is just one "active" 
snapshot should be relatively easy).

Mikulas

> If we keep regitration of the new snapshot late, as I believe we need
> to, then we do not have a way to check for a conflicting handover (in
> snapshot_ctr).  We'd then have a situation where N new snapshots _could_
> be racing to get the exceptions handed over from a single old snapshot.
> 
> So I think we'll need the snapshot to have a 'is_handover_source' flag;
> it would allow us to check of the 'handover_snap' in snapshot_ctr()
> already 'is_handover_source' and if so fail the new snapshot_ctr().
> I'll look to add this after I have coded the handover to not use any
> state.  Looking will be dead simple (just need to take the old
> snapshot's lock).
> 
> > When you are about to do a handover (Alasdair is arranging generic dm core 
> > do handover only un resume), just search for a possible handover candidate 
> > with find_snapshot_using_cow.
> 
> As I think you're aware: Alasdair's core DM changes have nothing to do
> with actually constraining handover to be on resume.  His changes make
> handover on resume safe; as we can guarantee that handover on resume
> actually worked (and if not rollback to old map).  A very welcomed
> advance.
> 
> Thanks for your review,
> 
> Mike
> 
