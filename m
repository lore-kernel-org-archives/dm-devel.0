From: Mikulas Patocka <mpatocka@redhat.com>
Subject: RE: [External]  Re: [PATCH] dm writecache: skip writecache_wait for
 pmem mode
Date: Wed, 4 Sep 2019 11:36:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1909041130520.16043@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190902100450.10600-1-yehs2007@zoho.com> <alpine.LRH.2.02.1909040444440.11252@file01.intranet.prod.int.rdu2.redhat.com> <SL2PR03MB44250F8E14C877F400295EA892B80@SL2PR03MB4425.apcprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SL2PR03MB44250F8E14C877F400295EA892B80@SL2PR03MB4425.apcprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng HS1 Ye <yehs1@lenovo.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "prarit@redhat.com" <prarit@redhat.com>, Tzu ting Yu1 <tyu1@lenovo.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Huaisheng Ye <yehs2007@zoho.com>
List-Id: dm-devel.ids



On Wed, 4 Sep 2019, Huaisheng HS1 Ye wrote:

> > -----Original Message-----
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Sent: Wednesday, September 4, 2019 4:49 PM
> > On Mon, 2 Sep 2019, Huaisheng Ye wrote:
> > 
> > > From: Huaisheng Ye <yehs1@lenovo.com>
> > >
> > > The array bio_in_progress[2] only have chance to be increased and
> > > decreased with ssd mode. For pmem mode, they are not involved at all.
> > > So skip writecache_wait_for_ios in writecache_flush for pmem.
> > >
> > > Suggested-by: Doris Yu <tyu1@lenovo.com>
> > > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> > > ---
> > >  drivers/md/dm-writecache.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > > index c481947..d06b8aa 100644
> > > --- a/drivers/md/dm-writecache.c
> > > +++ b/drivers/md/dm-writecache.c
> > > @@ -726,7 +726,8 @@ static void writecache_flush(struct dm_writecache *wc)
> > >  	}
> > >  	writecache_commit_flushed(wc);
> > >
> > > -	writecache_wait_for_ios(wc, WRITE);
> > > +	if (!WC_MODE_PMEM(wc))
> > > +		writecache_wait_for_ios(wc, WRITE);
> > >
> > >  	wc->seq_count++;
> > >  	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
> > > --
> > > 1.8.3.1
> > 
> > I think this is not needed - wait_event in writecache_wait_for_ios exits
> > immediatelly if the condition is true.
> > 
> > This code path is not so hot that we would need microoptimizations like this to
> > avoid function calls.
> 
> Hi Mikulas,
> 
> Thanks for your reply, I see what you mean, but I can't agree with you.
> 
> For pmem mode, this code path (writecache_flush) is much more hot than 
> SSD mode. Because in the code, the AUTOCOMMIT_BLOCKS_PMEM has been 
> defined to 64, which means if more than 64 blocks have been inserted to 
> cache device, also called uncommitted, writecache_flush would be called. 
> Otherwise, there is a timer callback function will be called every 1000 
> milliseconds.
> 
> #define AUTOCOMMIT_BLOCKS_SSD		65536
> #define AUTOCOMMIT_BLOCKS_PMEM		64
> #define AUTOCOMMIT_MSEC			1000
> 
> So when dm-writecache running in working mode, there are continuous 
> WRITE operations has been mapped to writecache_map, writecache_flush 
> will be used much more often than SSD mode.
> 
> Cheers,
> Huaisheng Ye

So, you save one instruction cache line for every 64*4096 bytes written to 
persistent memory.

If you insist on it, I can acknowledge it, but I think it is really an 
over-optimization.

Acked-By: Mikulas Patocka <mpatocka@redhat.com>

Mikulas
