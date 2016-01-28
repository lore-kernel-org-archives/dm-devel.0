From: Joe Thornber <thornber@redhat.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Thu, 28 Jan 2016 10:44:06 +0000
Message-ID: <20160128104405.GA21697@rh-vpn>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
	<20160126161919.GA19606@rh-vpn>
	<CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 27, 2016 at 12:51:09PM +0800, Dennis Yang wrote:
> Hi Joe,
> 
> I have applied this patch to kernel 4.4 and get the following result.

Thanks for taking the time to do this.

> To delete a fully-mapped 10TB thin devices,
> with this patch takes 48 sec.
> without this patch takes 48 sec.
> 
> To read an empty thin device while deleting a fully-mapped 10TB thin
> devices,
> with this patch I/O throughput drops from 4.6TB/s to 4.3TB/s
> without this patch, I/O blocks.
> 
> To write an empty thin device while deleting a fully-mapped 10TB thin
> devices,
> with this patch I/O throughput drops from 3.2TB/s to below 4MB/s
> without this patch, I/O blocks
> 
> Since it looks like the write performance still suffer from the lock
> contention, I make it to sleep 100 msec between lock release and reacquire
> in commit_decs().

Well it's really provisioning or breaking of sharing that's slow, not
writes in general.  Rather than adding a sleep it would be worth
playing with the MAX_DECS #define.  eg, try 16 and 8192 and see how
that effects the throughput.

> The one thing I am curious about is what data structures are dm-thin tries
> to protect by holding the pool lock during all those btree operations. At
> first, I think the lock is held to protect the btree itself. But based on
> the comments in the source code, I believe that it has already been
> protected by the read/writes lock in transaction manager
> (dm_tm_read/write_lock). Does this mean that the pool lock is held only to
> protect the reference count bitmap/btree?

You're correct.  I wrote all of persistent data using a rolling lock
scheme that allows updates to the btrees to occur in parallel.  But I
didn't extend this to cover the superblock or in core version of the
superblock.  So the top level rw semaphore is protecting this in core
sb.  I've spent a couple of days this week experimenting with
switching over to using the rolling lock scheme properly.  The changes
are extensive:

    - Strip out the root_lock rw_sem.

    - Introduce a transaction_lock.

      Every metadata op needs to hold a rw sem in 'read' mode (even if
      it's doing an update), except commit which would hold in write
      mode, this forces all the threads to synchronise whenever we
      commit.

    - Change the block manager to allow us to 'lock' abstract things,
      like the in core sb.  This is really just introducing another
      namespace to the bm.  Pretty easy.

    - Change the interfaces to persistent data structures like btree,
      array etc. to take one of these locks representing the
      superblock.  Audit to make sure this lock is released early to
      support the rolling lock scheme.

    - Add locking/protection to the space maps (which have some in
      core data structs).

Given this long list of changes I don't think it's worth the risk.  So
I'd rather use the patch I posted earlier.

- Joe
