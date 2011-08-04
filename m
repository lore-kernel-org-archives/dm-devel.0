From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 3/4] [block-manager] remove spurious
 decrement of write_lock_pending in the case of a recycled block.
Date: Thu, 4 Aug 2011 10:06:36 +0100
Message-ID: <20110804090635.GA3509@ubuntu>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<1312295808-4323-1-git-send-email-ejt@redhat.com>
	<1312295808-4323-3-git-send-email-ejt@redhat.com>
	<Pine.LNX.4.64.1108031043020.28467@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108031043020.28467@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 03, 2011 at 10:50:33AM -0400, Mikulas Patocka wrote:
> I think this is not correct.

I had a similar thought last night, however my concern was the
previous 'read' patch that you've acked.  I'll go back and look at
these today.

- Joe

> 
> The problem here is that the block may have been recycled and the newly 
> created block may have the same block number as the old block.
> 
> If b->where != block, we know that the block was recycled.
> If b->where == block, the block may have been recycled or not and we 
> don't know.
> 
> 
> I think the correct solution could be: make write_lock_pending a boolean 
> variable, not a counter.
> 
> Set write_lock_pending inside __wait_block when we are about to wait (the 
> block may have been recycled each time we waited, so we need to set it 
> each time we are going to wait)
> Clear write_lock_pending when __wait_unlocked exits.
> 
> If we make it a boolean variable, double clearing makes no harm.
> 
> Mikulas
> 
> On Tue, 2 Aug 2011, Joe Thornber wrote:
> 
> > ---
> >  drivers/md/persistent-data/dm-block-manager.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> > index b68be88..d27ab6e 100644
> > --- a/drivers/md/persistent-data/dm-block-manager.c
> > +++ b/drivers/md/persistent-data/dm-block-manager.c
> > @@ -756,9 +756,15 @@ retry:
> >  
> >  				b->write_lock_pending++;
> >  				__wait_unlocked(b, &flags);
> > -				b->write_lock_pending--;
> >  				if (b->where != block)
> > +					/*
> > +					 * Recycled blocks have their
> > +					 * write_lock_pending count reset
> > +					 * to zero, so no need to undo the
> > +					 * above increment.
> > +					 */
> >  					goto retry;
> > +				b->write_lock_pending--;
> >  			}
> >  			break;
> >  		}
> > -- 
> > 1.7.4.1
> > 
