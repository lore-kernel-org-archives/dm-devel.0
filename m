From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Thu, 15 Oct 2015 11:27:57 +0800
Message-ID: <CACVXFVPgvKEJo1dPigk303=GGVc3fJnuEk+QP+VEf=xa_Lz+vA@mail.gmail.com>
References: <5384B26D.1000703@kernel.dk>
	<alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
	<5384CE82.90601@kernel.dk>
	<alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
	<20151005205943.GB25762@redhat.com>
	<alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
	<20151006185016.GA31955@redhat.com>
	<20151006201637.GA4158@redhat.com>
	<alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
	<20151008150859.GA11770@redhat.com>
	<20151009195203.GA18790@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151009195203.GA18790@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 10, 2015 at 3:52 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Thu, Oct 08 2015 at 11:08am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Thu, Oct 08 2015 at 11:04am -0400,
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>> >
>> >
>> > On Tue, 6 Oct 2015, Mike Snitzer wrote:
>> >
>> > > To give others context for why I'm caring about this issue again, this
>> > > recent BZ against 4.3-rc served as a reminder that we _need_ a fix:
>> > > https://bugzilla.redhat.com/show_bug.cgi?id=1267650
>> > >
>> > > FYI, I cleaned up the plug-based approach a bit further, here is the
>> > > incremental patch:
>> > > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=f73d001ec692125308accbb5ca26f892f949c1b6
>> > >
>> > > And here is a new version of the overall combined patch (sharing now
>> > > before I transition to looking at alternatives, though my gut is the use
>> > > of a plug in generic_make_request really wouldn't hurt us.. famous last
>> > > words):
>> > >
>> > >  block/bio.c            | 82 +++++++++++++-------------------------------------
>> > >  block/blk-core.c       | 21 ++++++++-----
>> > >  drivers/md/dm-bufio.c  |  2 +-
>> > >  drivers/md/raid1.c     |  6 ++--
>> > >  drivers/md/raid10.c    |  6 ++--
>> > >  include/linux/blkdev.h | 11 +++++--
>> > >  include/linux/sched.h  |  4 ---
>> > >  7 files changed, 51 insertions(+), 81 deletions(-)
>> > >
>> ...
>> > > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> > > index 2dd3308..c2bff16 100644
>> > > --- a/drivers/md/dm-bufio.c
>> > > +++ b/drivers/md/dm-bufio.c
>> > > @@ -168,7 +168,7 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
>> > >  #define DM_BUFIO_CACHE(c)        (dm_bufio_caches[dm_bufio_cache_index(c)])
>> > >  #define DM_BUFIO_CACHE_NAME(c)   (dm_bufio_cache_names[dm_bufio_cache_index(c)])
>> > >
>> > > -#define dm_bufio_in_request()    (!!current->bio_list)
>> > > +#define dm_bufio_in_request()    (current->plug && !!current->plug->bio_list)
>> >
>> > This condition is repeated several times throughout the whole patch - so
>> > maybe you should make it a function in block device header file.
>>
>> Yeah, I thought of that too but forgot to come back to it.  Will do,
>> thanks.
>>
>> FYI, I found another bug in my last patch and fixed it up.  I'll get
>> some refactoring done (including your suggestion), actually _test_ the
>> code (e.g. verify all of lvm testsuite passes) and then send out v3.
>
> Turns out that this change:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=2639638c77768a86216be456c2764e32a2bcd841
>
> needed to be reverted with:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=ad3ccd760da7c05b90775372f9b39dc2964086fe
>
> Because nested plugs caused generic_make_request()'s onstack bio_list to
> go out of scope (blk_finish_plug() wouldn't actually flush the list
> within generic_make_request because XFS already added an outermost
> plug).

Looks you should have defined bio_list in plug as

               'struct bio_list bio_list'

instead of one pointer.

>
> But even after fixing that I then hit issues with these changes now
> resulting in imperfect 'in_generic_make_request' accounting that happens
> lazily once the outermost plug completes blk_finish_plug.  manifested as
> dm-bufio.c:dm_bufio_prefetch's BUG_ON(dm_bufio_in_request()); hitting.

Looks this problem should be related with above 'bio_list' definition too.

>
> Basically using the blk-core's onstack plugging isn't workable for
> fixing this deadlock and we're back to having to seriously consider
> this (with its additional hook in the scheduler):
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ming Lei
