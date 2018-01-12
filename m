From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v4 3/4] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 21:03:20 -0500
Message-ID: <20180112020319.GC32298@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
 <20180111201417.2042-4-snitzer@redhat.com>
 <1515717455.2752.82.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515717455.2752.82.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  7:37pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 15:14 -0500, Mike Snitzer wrote:
> > -void device_add_disk(struct device *parent, struct gendisk *disk)
> > +void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
> >  {
> >  	dev_t devt;
> >  	int retval;
> > @@ -682,7 +682,6 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
> >  				    exact_match, exact_lock, disk);
> >  	}
> >  	register_disk(parent, disk);
> > -	blk_register_queue(disk);
> >  
> >  	/*
> >  	 * Take an extra ref on queue which will be put on disk_release()
> > @@ -693,6 +692,21 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
> >  	disk_add_events(disk);
> >  	blk_integrity_add(disk);
> >  }
> > +EXPORT_SYMBOL(device_add_disk_no_queue_reg);
> 
> Hello Mike,
> 
> This change can increase the time between the generation of the disk uevent
> and the registration of the request queue sysfs attributes. Can this cause
> any udev rules to fail?

Certainly not for DM (DM has very sophisticated udev rules that wait for
the final dm generated "CHANGE" event before considering a device to be
"ready").

But are you asking about non-DM devices?  I cannot see, what amounts to,
moving blk_register_queue() to the end of device_add_disk() as reason for
concern.  If it were there technically would already be that race.

Mike
