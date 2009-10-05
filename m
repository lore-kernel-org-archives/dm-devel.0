From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: clustered snapshots
Date: Mon, 5 Oct 2009 11:57:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910050948540.11735@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com> <20091004034843.GC25374@redhat.com>
	<Pine.LNX.4.64.0910042214530.12074@hs20-bc2-1.build.redhat.com>
	<20091005043334.GA27758@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091005043334.GA27758@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 5 Oct 2009, Mike Snitzer wrote:

> On Sun, Oct 04 2009 at 10:25pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > I don't understand the purpose of this patch. I think it's useless.
> 
> You don't understand it, so you think it's useless.. nice to know where
> I'm starting.
> 
> > - during merge, nothing except the merge process reads the on-disk 
> > exceptions. So it doesn't matter when you clean them. You must clean them 
> > before dropping the interlock, but the order is not important.
> 
> Sure, I thought the same but quickly realized that in practice order
> does matter if you'd like to avoid failing the in-core exception cleanup
> (IFF we allow chunks to be inserted before existing chunks; aka
> "back-merges").
> 
> Your original approach to cleaning all on-disk exceptions then all
> in-core has no hope of working for "back-merges".  Your original
> snapshot-merge completely eliminated insertions before existing chunks.
> 
> I also tried to clean all in-core exceptions and then clean all on-disk
> exceptions.  I chose this order because when cleaning in-core exceptions
> you need to _know_ the {old,new}_chunk for the on-disk
> exception.. Otherwise you can't properly determine whether the in-core's
> exception that has consecutive chunks needs e->{old,new}_chunk++ before
> dm_consecutive_chunk_count_dec(e).
> 
> Even though it was awkward I tried it... code was ugly as hell and
> simply didn't work.  Judging the in-core exception's cleanup based on
> some exception store's location of the associated on-disk exception
> required taking the approach I did with adding a callback to
> commit_merge().  The exception stores should not know anything of the
> in-core exceptions in the common snapshot code.

Well, you can't "try" to fix bugs without understanding them. This effort 
may hide the bug.

Unrelated changes may hide the bug --- not fix it but make it appear under 
different conditions. So, if there's a bug, I take a snapshot of my code 
(so that I can always revert to the "buggy" code) and then try to find it. 
If the code works after some change but I don't know why, it cannot be 
considered as a fix for the bug.

> Lesson I learned is that the in-core dm_snap_exception's consecutive
> chunk accounting is _really_ subtle.  And while I agree there should be
> no relation between the proper cleanup of on-disk and in-core
> exceptions; doing the cleanup of each in lock-step appears to be the
> only way forward (that I found).

Looking closer at it, all that the patch changes is that before the patch, 
exceptions were cleaned last-to-first and after the patch they are cleaned 
first-to-last. This is likely a reason that the patch works around a real 
bug somewhere else. Not the callback.

> > I think this patch just hides other bug that you have made. Do you set and 
> > test the interlock correctly? If yes, it will block any I/Os to the chunks 
> > being merged.
> 
> What bug have I made?  Pretty bold assertion only to back it up with
> hand-waving and bravado.  I've worked hard to preserve your original work
> as closely as possible; yet add the ability to support insertion of
> chunks before existing chunks.

If it worked before without this patch and stopped working after you've 
made some changes, than you have likely made a bug. So find it.

Mikulas
