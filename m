From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition between
 discard bios and ordinary bios.
Date: Tue, 5 Feb 2013 19:11:37 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302051904120.30143@file.rdu.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-6-git-send-email-ejt@redhat.com>
	<20130124023503.GG30267@agk-dp.fab.redhat.com>
	<20130124132259.GA6658@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130124132259.GA6658@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: thornber@redhat.com
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 24 Jan 2013, thornber@redhat.com wrote:

> On Thu, Jan 24, 2013 at 02:35:03AM +0000, Alasdair G Kergon wrote:
> > On Thu, Dec 13, 2012 at 08:19:13PM +0000, Joe Thornber wrote:
> > > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > > index 504f3d6..8e47f44 100644
> > > --- a/drivers/md/dm-thin.c
> > > +++ b/drivers/md/dm-thin.c
> > > @@ -222,10 +222,28 @@ struct thin_c {
> > >  
> > >  	struct pool *pool;
> > >  	struct dm_thin_device *td;
> > > +
> > > +	/*
> > > +	 * The cell structures are too big to put on the stack, so we have
> > > +	 * a couple here for use by the main mapping function.
> > > +	 */
> > > +	spinlock_t lock;
> > > +	struct dm_bio_prison_cell cell1, cell2;
> > 
> > We're also trying to cut down on locking on these code paths.
> > (High i/o load, many many cores?)
> > 
> > Have you hit any problems while testing due to the stack size?
> > The cells don't seem ridiculously big - could we perhaps just put them on 
> > the stack for now?  If we do hit stack size problems in real world
> > configurations, then we can try to compare the locking approach with an
> > approach that uses a separate (local) mempool for each cell (or a
> > mempool with double-sized elements).
> 
> I haven't hit any stack size issues.  But the cell structures are 60
> bytes each and putting two of them on the stack seems wasteful.  I
> don't have enough knowledge to say this will be ok for all
> architectures and so took the safe option.

I think it's better to put the structures on the stack (it is not that 
much, the stack has 8k, so 120 bytes is 1/68 of the stack) and remove the 
spinlock.

Mikulas
