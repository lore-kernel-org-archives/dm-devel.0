From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Wed, 11 Nov 2009 18:47:49 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911111839030.1911@hs20-bc2-1.build.redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
	<20091111124138.GA24901@redhat.com>
	<Pine.LNX.4.64.0911111530240.32278@hs20-bc2-1.build.redhat.com>
	<20091111233536.GA7502@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091111233536.GA7502@redhat.com>
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

> > It is registered in snapshot_ctr --- that's how it was originally written. 
> > So it should be possible to find it.
> >
> > You moved the registration away? So move it back.
> 
> Why?  That would be counter-productive.
> 
> register_snapshot() is skipped if handover will be performed.  The
> reason is register_snapshot() looks at the store's chunk_size.  Problem
> is we don't have the store yet.  Your handover relied on rereading the
> snapshot header.  I no longer read_metadata() at all if the store will
> be handed over.

If you don't want to read the header and get the chunk size from there, 
you can get it from the existing active snapshot. And then register the 
new to-be-activated snapshot with active == 0 (so that it will be skipped 
for exception reallocation).

> > I'm somehow concerned, how this simple handover code (that I wrote 1.5 
> > years ago, on a train way from Berlin to Prague) is getting more and more 
> > complicated, just for handling some "can't happen" cases.
> 
> Believe me, I'd rather not be lingering over the finer points of
> exception handover; but once I hit the fact that snapshot_ctr() was
> imposing that the COW device must not be suspended it opened a can or
> worms (lvchange --refresh exposed this, in general it is fair to assume
> the cow device isn't suspended in snapshot_ctr :).  

No one should be calling any target constructor if there are any suspended 
devices. But there may be bugs in lvm2 that do that ... and you may need 
to work around them ...

The reason: the constructor can allocate memory and that could attempt to 
flush pages to the suspended devices and deadlock.

> The handover-based snapshot_ctr() needing to access the COW device
> begged the followong questions:
> why are we reading the snapshot header via read_metadata()?
> Why are we doing any IO to the COW if it will just be handed over?

Originaly it read the whole snapshot store :) And I optimized away the 
worst thing (reading exceptions) because it takes a lot of memory.

> Answer: we don't have a real need, so don't.  Not only that, but
> Alasdair asserted read_metadata() must not be called if another snapshot
> is already actively using the COW.  What if something else is changing
> it at the same time that the new snapshot_ctr() re-reads it?

It won't cause trouble. It will just read incomplete list of exceptions 
(that will be thrown away anyway). But reading exceptions is a memory 
waste, my patch didn't do it too.

Mikulas
