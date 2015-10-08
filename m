From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Thu, 8 Oct 2015 11:08:59 -0400
Message-ID: <20151008150859.GA11770@redhat.com>
References: <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
 <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
 <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
 <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, kent.overstreet@gmail.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 08 2015 at 11:04am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 6 Oct 2015, Mike Snitzer wrote:
> 
> > To give others context for why I'm caring about this issue again, this
> > recent BZ against 4.3-rc served as a reminder that we _need_ a fix:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1267650
> > 
> > FYI, I cleaned up the plug-based approach a bit further, here is the
> > incremental patch:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=f73d001ec692125308accbb5ca26f892f949c1b6
> > 
> > And here is a new version of the overall combined patch (sharing now
> > before I transition to looking at alternatives, though my gut is the use
> > of a plug in generic_make_request really wouldn't hurt us.. famous last
> > words):
> > 
> >  block/bio.c            | 82 +++++++++++++-------------------------------------
> >  block/blk-core.c       | 21 ++++++++-----
> >  drivers/md/dm-bufio.c  |  2 +-
> >  drivers/md/raid1.c     |  6 ++--
> >  drivers/md/raid10.c    |  6 ++--
> >  include/linux/blkdev.h | 11 +++++--
> >  include/linux/sched.h  |  4 ---
> >  7 files changed, 51 insertions(+), 81 deletions(-)
> > 
...
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 2dd3308..c2bff16 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -168,7 +168,7 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
> >  #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
> >  #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
> >  
> > -#define dm_bufio_in_request()	(!!current->bio_list)
> > +#define dm_bufio_in_request()	(current->plug && !!current->plug->bio_list)
> 
> This condition is repeated several times throughout the whole patch - so 
> maybe you should make it a function in block device header file.

Yeah, I thought of that too but forgot to come back to it.  Will do,
thanks.

FYI, I found another bug in my last patch and fixed it up.  I'll get
some refactoring done (including your suggestion), actually _test_ the
code (e.g. verify all of lvm testsuite passes) and then send out v3.

Mike
