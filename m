From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 19:45:00 -0500
Message-ID: <20180113004500.GA7207@redhat.com>
References: <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
 <20180112231708.GA6722@redhat.com>
 <1515800544.2396.89.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515800544.2396.89.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "axboe@fb.com" <axboe@fb.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at  6:42pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Fri, 2018-01-12 at 18:17 -0500, Mike Snitzer wrote:
> > @@ -1570,7 +1570,10 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
> >  	if (error && blk_path_error(error)) {
> >  		struct multipath *m = ti->private;
> >  
> > -		r = DM_ENDIO_REQUEUE;
> > +		if (r == BLK_STS_RESOURCE)
> > +			r = DM_ENDIO_DELAY_REQUEUE;
> > +		else
> > +			r = DM_ENDIO_REQUEUE;
> 
> Did you perhaps intend "error == BLK_STS_RESOURCE"?

Yes, it was a quick patch to get your thoughts.

> 
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index 9ba8453..da83f64 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -550,6 +550,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
> >  #define DM_ENDIO_DONE		0
> >  #define DM_ENDIO_INCOMPLETE	1
> >  #define DM_ENDIO_REQUEUE	2
> > +#define DM_ENDIO_DELAY_REQUEUE	3
> >  
> >  /*
> >   * Definitions of return values from target map function.
> > @@ -557,7 +558,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
> >  #define DM_MAPIO_SUBMITTED	0
> >  #define DM_MAPIO_REMAPPED	1
> >  #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
> > -#define DM_MAPIO_DELAY_REQUEUE	3
> > +#define DM_MAPIO_DELAY_REQUEUE	DM_ENDIO_DELAY_REQUEUE
> >  #define DM_MAPIO_KILL		4
> >  
> >  #define dm_sector_div64(x, y)( \
> 
> Please consider to introduce enumeration types for the DM_ENDIO_* and the
> DM_MAPIO_* constants such that the compiler can catch what I reported above.

OK, point taken.

> Otherwise this patch looks fine to me.

Cool, thanks.

Mike
