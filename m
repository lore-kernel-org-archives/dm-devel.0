From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH 1/2] block: cope with gendisk's 'queue' being
 added later
Date: Tue, 9 Jan 2018 18:41:33 -0500
Message-ID: <20180109234133.GA18842@redhat.com>
References: <20180109221039.33282-1-snitzer@redhat.com>
 <20180109221039.33282-2-snitzer@redhat.com>
 <1515539064.2721.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515539064.2721.34.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Jan 09 2018 at  6:04pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2018-01-09 at 17:10 -0500, Mike Snitzer wrote:
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index 870484eaed1f..0b0dda8e2420 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -919,8 +919,20 @@ int blk_register_queue(struct gendisk *disk)
> >  	ret = 0;
> >  unlock:
> >  	mutex_unlock(&q->sysfs_lock);
> > +
> > +	/*
> > +	 * Take an extra ref on queue which will be put on disk_release()
> > +	 * so that it sticks around as long as @disk is there.
> > +	 */
> > +	WARN_ON_ONCE(!blk_get_queue(q));
> > +
> > +	WARN_ON(sysfs_create_link(&dev->kobj,
> > +				  &q->backing_dev_info->dev->kobj,
> > +				  "bdi"));
> > +
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(blk_register_queue);
> 
> Hello Mike,
> 
> So the sysfs_create_link() call is moved from register_disk() into
> blk_register_queue() but the sysfs_remove_link() call stays in del_gendisk()?
> Are you sure that you want this asymmetry?

My focus was on the add_disk() side of things, due to disk->queue
possibly being NULL on add.  But on remove all was basically left
unmodified (aside from removing the WARN_ON).

I dont think the asymmetry is a big deal but I can fix it.  I'll wait
for more feedback before sending out a v2 though.

Thanks,
Mike
