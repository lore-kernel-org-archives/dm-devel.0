From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: clustered snapshots
Date: Mon, 5 Oct 2009 12:24:09 -0400
Message-ID: <20091005162409.GA4391@redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com>
	<20091004034843.GC25374@redhat.com>
	<Pine.LNX.4.64.0910042214530.12074@hs20-bc2-1.build.redhat.com>
	<20091005043334.GA27758@redhat.com>
	<Pine.LNX.4.64.0910050948540.11735@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910050948540.11735@hs20-bc2-1.build.redhat.com>
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

On Mon, Oct 05 2009 at 11:57am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 5 Oct 2009, Mike Snitzer wrote:
...
> > Lesson I learned is that the in-core dm_snap_exception's consecutive
> > chunk accounting is _really_ subtle.  And while I agree there should be
> > no relation between the proper cleanup of on-disk and in-core
> > exceptions; doing the cleanup of each in lock-step appears to be the
> > only way forward (that I found).
> 
> Looking closer at it, all that the patch changes is that before the patch, 
> exceptions were cleaned last-to-first and after the patch they are cleaned 
> first-to-last. This is likely a reason that the patch works around a real 
> bug somewhere else. Not the callback.

Callback aside; the code didn't change the processing order.  You're
reading the code wrong.  persistent_commit_merge() processes the on-disk
exceptions in reverse with the following loop:

	   for (i = 0; i < n; i++)
	       clear_exception(ps, ps->current_committed - 1 - i);

The in-core exception cleanup in merge_callback() also cleans up in
reverse:

	  /*
	   * Must process chunks (and associated exceptions) in reverse
	   * so that dm_consecutive_chunk_count_dec() accounting works
	   */
	   for (i = s->merge_write_interlock_n - 1; i >= 0; i--) {
	   ...

So the fact that I added a callback from persistent_commit_merge()
did _not_ change the last-to-first exception cleanup ordering (for
either on-disk or in-core).

Regardless, I'm not using the callback.. I have simpler code to handle
back-merges within the merge_callback() for-loop.  I emailed that patch
in my previous reply to this thread...

> > > I think this patch just hides other bug that you have made. Do you set and 
> > > test the interlock correctly? If yes, it will block any I/Os to the chunks 
> > > being merged.
> > 
> > What bug have I made?  Pretty bold assertion only to back it up with
> > hand-waving and bravado.  I've worked hard to preserve your original work
> > as closely as possible; yet add the ability to support insertion of
> > chunks before existing chunks.
> 
> If it worked before without this patch and stopped working after you've 
> made some changes, than you have likely made a bug. So find it.

I'm not going to go round and round on this.  Backmerges never worked
with your snapshot-merge because you never took them into account (you
disabled them!).

In the interest of moving forward please test that the following code
works on your sparc64 system:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.31/

You'll also need to update LVM2 2.02-54-cvs to use these patches:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.54/

Mike
