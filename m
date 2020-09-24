From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-raid: stack limits instead of overwriting them.
Date: Thu, 24 Sep 2020 14:12:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009241410490.8544@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
	<20200924165616.GA14650@redhat.com>
	<alpine.LRH.2.02.2009241306170.28814@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009241306170.28814@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Thu, 24 Sep 2020, Mikulas Patocka wrote:

> 
> 
> On Thu, 24 Sep 2020, Mike Snitzer wrote:
> 
> > WAIT... Could it be that raid_io_hints _really_ meant to special case
> > raid0 and raid10 -- due to their striping/splitting requirements!?
> > So, not raid1 but raid0?
> > 
> > E.g.:
> > 
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index 56b723d012ac..6dca932d6f1d 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3730,10 +3730,10 @@ static void raid_io_hints(struct dm_target *ti,
> > struct queue_limits *limits)
> >         blk_limits_io_opt(limits, chunk_size_bytes *
> > 	mddev_data_stripes(rs));
> > 
> >         /*
> > -        * RAID1 and RAID10 personalities require bio splitting,
> > -        * RAID0/4/5/6 don't and process large discard bios properly.
> > +        * RAID0 and RAID10 personalities require bio splitting,
> > +        * RAID1/4/5/6 don't and process large discard bios properly.
> >          */
> > -       if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
> > +       if (rs_is_raid0(rs) || rs_is_raid10(rs)) {
> >                 limits->discard_granularity = chunk_size_bytes;
> >                 limits->max_discard_sectors = rs->md.chunk_sectors;
> >         }
> > 
> > Mike
> 
> Yes - that's an interesing point.
> 
> Mikulas

But raid0_handle_discard handles discards with arbitrary start/end 
sectors.

So, we don't need to set discard_granularity for that.

Mikulas
