From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid: stack limits instead of overwriting them.
Date: Thu, 24 Sep 2020 15:15:15 -0400
Message-ID: <20200924191515.GA15323@redhat.com>
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh87GLea=7_4qGuPhMj0WKnB-596HzkKQDafLirHiBpSzQ@mail.gmail.com>
	<20200924170047.GB14650@redhat.com>
	<CAMeeMh-KfeEFAZE9v_UiDx_TELg3twKg6Ayvbbaf=NwYJ-8Csg@mail.gmail.com>
	<CAMeeMh-6kdN_73qc3uH_UVqbWyo07nWR8yhypVcboyXry-2N9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh-6kdN_73qc3uH_UVqbWyo07nWR8yhypVcboyXry-2N9A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: John Dorminy <jdorminy@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2020 at  2:56pm -0400,
John Dorminy <jdorminy@redhat.com> wrote:

> On Thu, Sep 24, 2020 at 1:24 PM John Dorminy <jdorminy@redhat.com> wrote:
> >
> > I am impressed at how much I read wrong...
> >
> > On Thu, Sep 24, 2020 at 1:00 PM Mike Snitzer <snitzer@redhat.com> wrote:
> > >
> > > On Thu, Sep 24 2020 at 12:45pm -0400,
> > > John Dorminy <jdorminy@redhat.com> wrote:
> > >
> > > > I don't understand how this works...
> > > >
> > > > Can chunk_size_bytes be 0? If not, how is discard_granularity being set to 0?
> > >
> > > Yeah, I had same question.. see the reply I just sent in this thread:
> > > https://www.redhat.com/archives/dm-devel/2020-September/msg00568.html
> > >
> > > > I think also limits is local to the ti in question here, initialized
> > > > by blk_set_stacking_limits() via dm-table.c, and therefore has only
> > > > default values and not anything to do with the underlying queue. So
> > > > setting discard_granularity=max(discard_granularity, chunk_size_bytes)
> > > > doesn't seem like it should be working, unless I'm not understanding
> > > > what it's there for...
> > >
> > > You're reading the dm-table.c limits stacking wrong.  Of course DM stack
> > > up the underlying device(s) limits ;)
> >
> > Yep, I failed to read iterate_devices...
> >
> > >
> > > >
> > > > And shouldn't melding in the target's desired io_hints into the
> > > > existing queue limits be happening in blk_stack_limits() instead?
> > > > (Also, it does lcm_not_zero() for stacking granularity, instead of
> > > > max()...)
> > > >
> > >
> > > DM core does do that, the .io_hints hook in the DM target is reserved
> > > for when the target has additional constraints that blk_stack_limits()
> > > didn't/couldn't factor in.
> > Yes, I had erroneously thought the limit-stacking was after getting
> > the targets' individual limits, not before.
> >
> > >
> > > And blk_stack_limts() does use max() for discard_granularity.
> > ... I'm just terrible at reading this morning.
> >
> > Thanks for pointing out all the things I misread!
> 
> Actually, though, I don't understand why it should be max instead of
> lcm_not_zero(). If the raid's chunk size is 1024 sectors, say, and
> you're constructing it on something that has discard_granularity 812
> sectors, say, blkdev_issue_discard will be generating 1024 sector IOs
> which will work poorly when passed down to the 812-sector-granularity
> underlying device. While, if lcm(812,1024) were used, lcm(812,1024)
> sector IOs would be compatible with both the chunk size and underlying
> device's granularity, perhaps? Maybe I'm missing something, but I read
> the doc and code an extra time around this time ;)

Martin may correct me if I'm wrong but I _think_ it is because
discard_granularity is unintuitive.  The larger the discard_granularity
the more constraining it is (on other devices with more relaxed, or
smaller, discard_granularity).  So you need to impose the most
constrained limit for all when stacking.

Mike
