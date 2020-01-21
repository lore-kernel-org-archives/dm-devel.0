From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 6/7] dm: Directly disable max_allocate_sectors for now
Date: Tue, 21 Jan 2020 09:43:10 -0500
Message-ID: <20200121144310.GA10055@redhat.com>
References: <157960325642.108120.13626623438131044304.stgit@localhost.localdomain>
 <157960337238.108120.18048939587162465175.stgit@localhost.localdomain>
 <20200121122458.GA9365@redhat.com>
 <f7e0fb38-a894-da33-c46b-e192ed907ee0@virtuozzo.com>
 <619a7a14-44e6-eca7-c1ea-3f04abeee53d@virtuozzo.com>
 <20200121134840.GA9944@redhat.com>
 <a19d5957-9aaa-b518-5855-e5fa2b5d3b22@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a19d5957-9aaa-b518-5855-e5fa2b5d3b22@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com
List-Id: dm-devel.ids

On Tue, Jan 21 2020 at  9:20am -0500,
Kirill Tkhai <ktkhai@virtuozzo.com> wrote:

> On 21.01.2020 16:48, Mike Snitzer wrote:
> > On Tue, Jan 21 2020 at  8:33am -0500,
> > Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> > 
> >> On 21.01.2020 15:36, Kirill Tkhai wrote:
> >>> On 21.01.2020 15:24, Mike Snitzer wrote:
> >>>> On Tue, Jan 21 2020 at  5:42am -0500,
> >>>> Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> >>>>
> >>>>> Since dm inherits limits from underlining block devices,
> >>>>> this patch directly disables max_allocate_sectors for dm
> >>>>> till full allocation support is implemented.
> >>>>>
> >>>>> This prevents high-level primitives (generic_make_request_checks(),
> >>>>> __blkdev_issue_write_zeroes(), ...) from sending REQ_ALLOCATE
> >>>>> requests.
> >>>>>
> >>>>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> >>>>> ---
> >>>>>  drivers/md/dm-table.c |    2 ++
> >>>>>  drivers/md/md.h       |    1 +
> >>>>>  2 files changed, 3 insertions(+)
> >>>>
> >>>> You're mixing DM and MD changes in the same patch.
> >>>>
> >>>> But I'm wondering if it might be best to set this default for stacking
> >>>> devices in blk_set_stacking_limits()?
> >>>>
> >>>> And then it is up to each stacking driver to override as needed.
> >>>
> >>> Hm. Sound like a good idea. This "lim->max_allocate_sectors = 0" in blk_set_stacking_limits()
> >>> should work for dm's dm_calculate_queue_limits(), since it calls blk_stack_limits(), which is:
> >>>
> >>> 	t->max_allocate_sectors = min(t->max_allocate_sectors,
> >>> 				      b->max_allocate_sectors);
> >>>
> >>> Could you please tell is this fix is also enough for md?
> >>
> >> It looks like it's enough since queue defaults are set in md_alloc()->blk_set_stacking_limits().
> >> In case of we set "max_allocate_sectors = 0", in further it can be changed only manually,
> >> but nobody does this.
> > 
> > Yes, it will work to disable this capability for MD and DM.
> > 
> > But if/when a stacked device _dooes_ want to support this then it'll be
> > awkward to override this stacking default to allow blk_stack_limits()
> > to properly stack up this limit.  blk_limits are extremely fiddley so
> > this isn't necessarily new.  But by explicitly defaulting to 0 and then
> > having blk_stack_limits use min() for this limit: it results in stacking
> > drivers needing to clumsily unwind the default.  E.g. DM will need to
> > tweak its blk_stack_limits() related code to allow override that
> > actually _does_  stack up the underlying devices' capability (and not
> > just impose its own limit that ignores the underlying devices).
> > 
> > So I'm not convinced this is the right way to go (be it the v4 approach
> > you took or the cleaner use of blk_set_stacking_limits I suggested).
> 
> Is there a strong vision about the way we should go? Or you leave this choose
> up to me?

I don't have time to work through it at the moment (e.g. implementing
dm-thinp support to know what the block core code should be) so I'll
just defer to you on a disabling it for now.

> > And to be clear, I'm interested in having DM thinp support this
> > capability to preallocate blocks.
> 
> My opinion is it would be better to not mix several subsystem related
> support in a single patch set. Both of the approaches (v4 or that you
> suggested) do not prevents us to implement allocation support in next
> patch series. After we have the base functionality enabled, we may add
> support in other subsystems and drivers one by one with more focus
> on the subsystem specificities and with the best possible attention.

Yeah, I'm aware nothing is ever set in stone.

Setting to 0 in blk_set_stacking_limits() is OK for now.

Thanks,
Mike
