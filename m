From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Wed, 11 Nov 2009 07:41:39 -0500
Message-ID: <20091111124138.GA24901@redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
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

On Tue, Nov 10 2009 at 10:26pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > +	/*
> > +	 * 'is_handover_destination' denotes another snapshot with the same
> > +	 * cow block device (as identified with find_snapshot_using_cow)
> > +	 * will hand over its exception store to this snapshot.
> > +	 *
> > +	 * 'is_handover_destination' is set in snapshot_ctr if an existing
> > +	 * snapshot has the same cow device. The handover is performed,
> > +	 * and 'is_handover_destination' is cleared, when either of the
> > +	 * following occurs:
> > +	 * - src (old) snapshot, that is handing over, is destructed
> > +	 * - dest (new) snapshot, that is accepting the handover, is resumed
> > +	 */
> > +	int is_handover_destination;
> > +
> > +	/*
> > +	 * reference to the other snapshot that will participate in the
> > +	 * exception store handover; src references dest, dest references src
> > +	 */
> > +	struct dm_snapshot *handover_snap;
> 
> Hi
> 
> Please drop snapshot-linking through this "handover_snap" field, it will 
> create real or possible problems with locking or with dangling pointers 
> (i.e. are both properly locked? Which to lock first? If you destroy a 
> snapshot, you must check if something links to it, etc. --- these problems 
> could be solved, but if they can be avoided by dropping linking, it's 
> better to avoid them).

I agree, lock_snapshots_for_handover() is too complicated.  But by dropping
these 'handover_snap' associations we'll lose the ability to have tight
constraints on what handover will take place on resume of new snapshot
(ideally a source of handover will only have one destination).

The new snapshot (destination of exception handover) is not registered
with the origin until after resume's handover_exceptions (via
register_snapshot).  And therefore it can't be found via
find_snapshot_using_cow().  But that is a good thing as we'll know that
if find_snapshot_using_cow does return a snapshot then it is the source
of the handover.

If we keep regitration of the new snapshot late, as I believe we need
to, then we do not have a way to check for a conflicting handover (in
snapshot_ctr).  We'd then have a situation where N new snapshots _could_
be racing to get the exceptions handed over from a single old snapshot.

So I think we'll need the snapshot to have a 'is_handover_source' flag;
it would allow us to check of the 'handover_snap' in snapshot_ctr()
already 'is_handover_source' and if so fail the new snapshot_ctr().
I'll look to add this after I have coded the handover to not use any
state.  Looking will be dead simple (just need to take the old
snapshot's lock).

> When you are about to do a handover (Alasdair is arranging generic dm core 
> do handover only un resume), just search for a possible handover candidate 
> with find_snapshot_using_cow.

As I think you're aware: Alasdair's core DM changes have nothing to do
with actually constraining handover to be on resume.  His changes make
handover on resume safe; as we can guarantee that handover on resume
actually worked (and if not rollback to old map).  A very welcomed
advance.

Thanks for your review,

Mike
