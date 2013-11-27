From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking changes
Date: Wed, 27 Nov 2013 10:00:59 -0600
Message-ID: <716327D0-E0C7-48B1-B7DB-1A72D7E02784@redhat.com>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com> <1385335843-14021-2-git-send-email-jbrassow@redhat.com> <20131125110315.262223cf@notabene.brown> <D89A7889-9B7B-40F1-AD7D-08937D168C7E@redhat.com> <30A220BB-6E93-44C9-A487-F23DBF546ED6@redhat.com> <20131126162746.4d42ef1d@notabene.brown> <3526D887-4D5D-4B09-9CAE-F771EFE45E6A@redhat.com> <E92B633B-F0C9-4D97-B97A-4B5536BE907D@redhat.com> <20131127141208.06109ed6@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131127141208.06109ed6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids


On Nov 26, 2013, at 9:12 PM, NeilBrown wrote:

> 
> If a stripe is on the released_stripes list (and has STRIPE_ON_RELEASE_LIST)
> set, it means that a call to __release_stripe is pending, so the ->count must
> be at least 1.
> So we would need some other actor to be holding device_lock, incrementing
> ->count, and  then placing the stripe on the released_stripes list.  I don't
> think that is possible.
> 
> I think I see the race now though (don't know why I couldn't see it
> yesterday .. but knowing it must be there from your testing must have
> helped).
> 
> I think the race is with __get_priority_stripe().  That is the  only place
> other than get_active_stripe() where we can increment ->count from zero.
> So:
>  1-1: get_active_stripe() sees ->count is zero
>  1-2: tried to get device_lock and blocks
>  2-1: meanwhile handle_active_stripes is holding ->device_lock and
>       chooses this stripe from handle list.  It deletes it from the
>       ->lru and increments the count - then releases ->device_lock
>  1-3: get_active_stripe() sees that ->lru is empty, and complains.
> 
> You other BUG is triggered by a difference race caused by the same locking
> problem.
> 
> ->active_stripes counts the number of stripes which have a non-zero ->count,
> or have STRIPE_HANDLE set.  STRIPE_HANDLE can only be set when ->count is
> non-zero, so we just need to update this whenever count reaches zero or
> leaves zero while STRIPE_HANDLE is set.
> This would previously always happen under device_lock.  However
> get_active_stripe() now increments ->count from zero under ->hash_locks.
> This could  race with __release_stripe() which only needs device_lock
> So 
>  1-1: get_active_stripe notices that ->count is not zero and skips locking
>       with device_lock
>  2-1: __release_stripe() decrements ->count to zero and calls
>      do_release_stripe which, as STRIPE_HANDLE is not set, decrements
>      ->active_stripes
>  1-1: get_active_stripe proceeds to increment ->count from zero without a
>       matching increment for ->active_stripes
> 
> so now ->active_stripes is 1 too small and your BUG is not far away.
> 
> 
> So I think we do need to extend the lock region exactly as in the patch you
> tried.
> Sad thing is that Shaohua originally had the code like that but I talked him
> out of it. :-(
> http://www.spinics.net/lists/raid/msg44290.html
> 
> It seems a shame to be taking device_lock here rather than just hash_locks.
> It might be possible to relax that a bit, but first we would need to measure
> if it was worth it.
> 
> This is the patch I'm thinking of for now.  It also fixes up the two BUGs as
> both of them are wrong.
> STRIPE_ON_RELEASE_LIST has no effect on the value of ->lru, so it shouldn't
> be included.  And while STRIPE_EXPANDING justifies an active stripe_head
> being on an lru, it is never ever set for an inactive stripe_head (which is
> always on an lru) so it shouldn't be there either.
> 
> Does that all sound convincing?

Yes.  The proof is in the testing for me though, and things look good there.

 brassow


