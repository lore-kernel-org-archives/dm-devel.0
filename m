From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Wed, 24 Apr 2019 18:22:40 -0400
Message-ID: <20190424222240.GA14922@redhat.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
	<45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
	<CAFTvtQ=JiZ7FWNiayM5bVY5A8ZCNbDtXV=rUxa_0u6Xm6rJAqg@mail.gmail.com>
	<CAMeeMh-v+xpn2YDizFQg4cKHZgC=aCdJwLfAMeGLGT1gB1ZURw@mail.gmail.com>
	<CAFTvtQnLDU_MKzse5t4xc_CVWENsZtwQQSTAFyj-45tPg5STZQ@mail.gmail.com>
	<CAFTvtQnALzibyS3jKisXRb+XGe8dopQfkj33=gtJAjd2+XymYQ@mail.gmail.com>
	<20190424212751.GC14367@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190424212751.GC14367@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryan Norwood <ryan.p.norwood@gmail.com>
Cc: vdo-devel@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 24 2019 at  5:27pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> 
> On Wed, Apr 24 2019 at 10:46am -0400,
> Ryan Norwood <ryan.p.norwood@gmail.com> wrote:
> 
> >    On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood <[1]ryan.p.norwood@gmail.com>
> >    wrote:
> > 
> >      Thank you for your help.
> >      You are correct, it appears that the problem occurs when there is a RAID
> >      5 or RAID 50 volume beneath VDO.
> >      NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC LOG-SEC
> >      RQ-SIZE SCHED    WSAME
> >      sdh
> >       sdh     128 977.5G         0     512       0     512     512     128
> >      deadline    0B
> >      +-sed6
> >      dm-6    128 977.5G         0     512       0     512     512     128
> >               0B
> >        +-md127
> >       md127 12288   5.7T         0 1048576 6291456     512     512     128
> >               0B
> >          +-vdo_data
> >      dm-17   128   5.7T         0 1048576 6291456     512     512     128
> >               0B
> >            +-vdo
> >       dm-18   128  57.3T         0    4096    4096    4096    4096     128
> >               0B

<snip>

> >      /sys/block/dm-18/queue/max_hw_sectors_kb:4
> >      /sys/block/dm-18/queue/max_sectors_kb:4

These are getting set as a side-effect of MD raid imposing the need for
merge_bvec (in the context of RHEL7.x only, not upstream) otherwise it
goes conservative and forces the IO to be contrained to a single page,
please see:

drivers/md/dm-table.c:dm_set_device_limits() at the end:

        /*
         * Check if merge fn is supported.
         * If not we'll force DM to use PAGE_SIZE or
         * smaller I/O, just to be safe.
         */
        if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
                blk_limits_max_hw_sectors(limits,
                                          (unsigned int) (PAGE_SIZE >> 9));

With MD raid in the IO stack, dm_queue_merge_is_compulsory() will return
true, so the VDO target not providing ti->type->merge causes this issue.

Please file a BZ at bugzilla.redhat.com against VDO and I'll continue to
work with the VDO developers to get this fixed for you for RHEL7.5, etc.

Thanks,
Mike
