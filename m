From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] new patchset to eliminate DM's use of BIOSET_NEED_RESCUER
 [was: Re: [PATCH 00/13] block: assorted cleanup for bio splitting and
 cloning.]
Date: Tue, 21 Nov 2017 16:23:02 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171121194709.GA18903@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Tue, 21 Nov 2017, Mike Snitzer wrote:

> On Tue, Nov 21 2017 at  7:43am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  
> > Decided it a better use of my time to review and then hopefully use the
> > block-core's bio splitting infrastructure in DM.  Been meaning to do
> > that for quite a while anyway.  This mail from you just made it all the
> > more clear that needs doing:
> > https://www.redhat.com/archives/dm-devel/2017-September/msg00098.html
> > 
> > So I will start here on this patch you proposed:
> > https://www.redhat.com/archives/dm-devel/2017-September/msg00091.html
> > (of note, this patch slipped through the cracks because I was recovering
> > from injury when it originally came through).
> > 
> > Once DM is using q->bio_split I'll come back to this patch (aka
> > "[1]") as a starting point for the follow-on work to remove DM's use of
> > BIOSET_NEED_RESCUER:
> > https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html
> 
> Hey Neil,
> 
> Good news!  All your code works ;)
> 
> (well after 1 fixup due to a cut-n-paste bug.. the code you added to
> dm_wq_work() to process the md->rescued bio_list was operating on
> the md->deferred bio_list due to cut-n-paste from code you copied from
> just below it)
> 
> I split your code out some to make it more reviewable.  I also tweaked
> headers accordingly.
> 
> Please see this branch (which _will_ get rebased between now and the
> 4.16 merge window):
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16
> 
> I successfully tested these changes using Mikulas' test program that
> reproduces the snapshot deadlock:
> https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html
> 
> I'll throw various other DM testsuites at it to verify they all look
> good (e.g. thinp, cache, multipath).
> 
> I'm open to all suggestions about changes you'd like to see (either to
> these patches or anything you'd like to layer ontop of them).
> 
> Thanks for all your work, much appreciated!
> Mike

This is not correct:

   2206 static void dm_wq_work(struct work_struct *work)
   2207 {
   2208         struct mapped_device *md = container_of(work, struct mapped_device, work);
   2209         struct bio *bio;
   2210         int srcu_idx;
   2211         struct dm_table *map;
   2212
   2213         if (!bio_list_empty(&md->rescued)) {
   2214                 struct bio_list list;
   2215                 spin_lock_irq(&md->deferred_lock);
   2216                 list = md->rescued;
   2217                 bio_list_init(&md->rescued);
   2218                 spin_unlock_irq(&md->deferred_lock);
   2219                 while ((bio = bio_list_pop(&list)))
   2220                         generic_make_request(bio);
   2221         }
   2222
   2223         map = dm_get_live_table(md, &srcu_idx);
   2224
   2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
   2226                 spin_lock_irq(&md->deferred_lock);
   2227                 bio = bio_list_pop(&md->deferred);
   2228                 spin_unlock_irq(&md->deferred_lock);
   2229
   2230                 if (!bio)
   2231                         break;
   2232
   2233                 if (dm_request_based(md))
   2234                         generic_make_request(bio);
   2235                 else
   2236                         __split_and_process_bio(md, map, bio);
   2237         }
   2238
   2239         dm_put_live_table(md, srcu_idx);
   2240 }

You can see that if we are in dm_wq_work in __split_and_process_bio, we 
will not process md->rescued list.

The processing of md->rescued is also wrong - bios for different devices 
must be offloaded to different helper threads, so that processing a bio 
for a lower device doesn't depend on processing a bio for a higher device. 
If you offload all the bios on current->bio_list to the same thread, the 
bios still depend on each other and the deadlock will still happen.

Mikulas
