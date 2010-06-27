From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2 v2] dm: discard support for the linear
	target
Date: Sun, 27 Jun 2010 09:41:47 -0400
Message-ID: <20100627134145.GA3970@redhat.com>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
	<20100627094918.GF12016@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100627094918.GF12016@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Sun, Jun 27 2010 at  5:49am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Sat, Jun 26, 2010 at 04:31:24PM -0400, Mike Snitzer wrote:
> > Allow discards to be passed through to a single device linear mapping.
> > Introduce DM_TARGET_SUPPORTS_DISCARDS target features flag that each
> > target must set once discard support is added.
> > 
> > Verify table's underlying devices support discards prior to setting the
> > associated DM device as capable of discards (via QUEUE_FLAG_DISCARD).
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm-linear.c        |    1 +
> >  drivers/md/dm-table.c         |   51 ++++++++++++++++++++++++++++++++++
> >  drivers/md/dm.c               |   60 ++++++++++++++++++++++++++++++++--------
> >  drivers/md/dm.h               |    1 +
> >  include/linux/device-mapper.h |    1 +
> >  5 files changed, 102 insertions(+), 12 deletions(-)
> 
> > +static int device_discard_incapable(struct dm_target *ti, struct dm_dev *dev,
> > +				    sector_t start, sector_t len, void *data)
> > +{
> > +	struct block_device *bdev = dev->bdev;
> > +	struct request_queue *q = bdev_get_queue(bdev);
> > +
> > +	WARN_ON(!q);
> > +	return (!q || !blk_queue_discard(q));
> > +}
> 
> How could a NULL queue happen here?

It really cannot, I was just being defensive.
