From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: init_emergency_isa_pool calling mempool_create in
	non-sleeping context
Date: Wed, 17 Jun 2009 18:50:23 -0400
Message-ID: <20090617225022.GC9405@redhat.com>
References: <4A396195.8060503@goop.org>
	<0f79c2d4513c50184383e223d3d2ee97.squirrel@neil.brown.name>
	<20090617224219.GA9405@redhat.com> <4A3971FE.7040700@goop.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A3971FE.7040700@goop.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Wed, Jun 17 2009 at  6:45pm -0400,
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 06/17/09 15:42, Mike Snitzer wrote:
> > This has been resolved and is waiting to be pushed along with the rest
> > of the DM changes for 2.6.31.
> >
> > See:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-table-establish-queue-limits-by-copying-table-limits.patch
> >   
> 
> OK, good to know.
> 
> > Maybe this fix should go now rather than wait a day or so for the larger
> > DM push?
> >   
> 
> The machine booted fine with no apparent badness, so I don't think its
> urgent.  I just reported it for diligence's sake.

OK, thanks.

Mike
