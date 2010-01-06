From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Tue, 5 Jan 2010 22:03:57 -0500
Message-ID: <20100106030357.GB16154@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100106025731.GA16154@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 05 2010 at  9:57pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Jan 05 2010 at  9:23pm -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:
> > 
> > Alasdair> extern int blk_stack_limits(struct queue_limits *t, struct
> > Alasdair> queue_limits *b,
> > Alasdair>                             sector_t offset);
> > 
> > Alasdair> This function is asking for the offset to be supplied as
> > Alasdair> sector_t i.e.  in units of sectors, but this patch uses bytes.
> > Alasdair> Please either change that to sectors as per the prototype, or
> > Alasdair> if it really does want bytes, fix the prototype to make that
> > Alasdair> clear.
> > 
> > It is sector_t because we don't have an existing type that fits the bill
> > (i.e. >= sector_t and dependent on whether LBD is on or not).  We're
> > trying to move away from counting in sectors because the notion is
> > confusing in the light of the logical vs. physical block size, device
> > alignment reporting, etc.
> > 
> > So maybe something like this?
> > 
> > 
> > block: Introduce blk_off_t
> > 
> > There are several places we want to communicate alignment and offsets in
> > bytes to avoid confusion with regards to underlying physical and logical
> > block sizes.  Introduce blk_off_t for block device byte offsets.
> > 
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ...
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index c42724f..729f87a 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -134,9 +134,11 @@ typedef		__s64		int64_t;
> >  #ifdef CONFIG_LBDAF
> >  typedef u64 sector_t;
> >  typedef u64 blkcnt_t;
> > +typedef u64 blk_off_t;
> >  #else
> >  typedef unsigned long sector_t;
> >  typedef unsigned long blkcnt_t;
> > +typedef unsigned long blk_off_t;
> >  #endif
> >  
> >  /*
> 
> After looking closer there seems to be various type inconsistencies in
> the alignment_offset and discard_alignment related routines (returning
> 'int' in places, etc).
> 
> The following patch is what I found; I have no problem with switching
> from 'unsigned long' to blk_off_t for LBD though.
> 
> Martin, would like to carry forward with this?  Have I gone overboard
> with this patch?

I missed fixing disk_stack_limits()'s 'offset' though...

Mike
