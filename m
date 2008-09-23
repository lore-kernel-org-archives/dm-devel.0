From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Fix Null pointer Exception
Date: Tue, 23 Sep 2008 17:56:28 +0100
Message-ID: <20080923165628.GI5288@agk.fab.redhat.com>
References: <48C5478B.2040401@linux.vnet.ibm.com>
	<20080908172153.05268f6d.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080908172153.05268f6d.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: raspl@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, h.carstens@de.ibm.com, dm-devel@redhat.com, martin.schwidefsky@de.ibm.com
List-Id: dm-devel.ids

On Mon, Sep 08, 2008 at 05:21:53PM -0700, Andrew Morton wrote:
> On Mon, 08 Sep 2008 17:40:59 +0200
> Stefan Raspl <raspl@linux.vnet.ibm.com> wrote:
> > Here's a trivial patch for the kernel panics that we reported last week
> > when testing various ways to forcefully disconnect or temporarily disable
> > DASD disks from an IBM System z machine. We ran into NULL pointer exceptions
> > at the respective places.
> Please look at the above text and consider how it will look to people
> who read it in the git repository in 2011.
> 
> And consider how it looks today, to people who don't know anything
> about "the kernel panics that we reported last week".
 
I've found this message:

+ Date: Mon, 01 Sep 2008 15:48:18 +0200
+ From: Stefan Raspl <raspl@linux.vnet.ibm.com>
+ Subject: [dm-devel] bdev lost its queue
+ To: device-mapper development <dm-devel@redhat.com>
+ 
+ We conducted a bunch tests where we used various ways to forcefully 
+ disconnect or temporarily disable DASD disks from an IBM System z 
+ machine. In the course we ran into a kernel panic in 
+ dm_table_unplug_all() (dm-table.c), specifically at
+ 
+    struct request_queue *q = bdev_get_queue(dd->bdev);
+     blk_unplug(q);
+ 
+ since the queue of the bdev was NULL.
+ Did anyone see a crash in this place before? And are there other disk 
+ drivers to can set their queue to NULL due to unplugging/outages or similar?

> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -943,7 +943,8 @@ int dm_table_any_congested(struct dm_tab
> >  
> >  	list_for_each_entry(dd, devices, list) {
> >  		struct request_queue *q = bdev_get_queue(dd->bdev);
> > -		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
> > +		if (q)
> > +			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
> >  	}
> >  
> >  	return r;
> > @@ -957,7 +958,8 @@ void dm_table_unplug_all(struct dm_table
> >  	list_for_each_entry(dd, devices, list) {
> >  		struct request_queue *q = bdev_get_queue(dd->bdev);
> >  
> > -		blk_unplug(q);
> > +		if (q)
> > +			blk_unplug(q);
> >  	}
> >  }
> >  
> 
> And it's not just a trivial matter of getting the paperwork right. 
> This could be the wrong fix - how did these null pointers come about? 
> What was the workload?  It seems strange to have a blockdev which has
> no queue associated with it.
 
Indeed, there is also code in other files that assumes struct
request_queue is not NULL.  And no, I've not heard of other drivers
causing this problem.  (Our dm multipath code doesn't do this when all
the paths disappear, for example.)

Have you had chance to look at old kernel versions to see in which
commit this was introduced?

Jens - What's your opinion: s390 driver fix or more messages like this one?
                if (!q) {
                        printk(KERN_ERR
                               "generic_make_request: Trying to access "
                                "nonexistent block-device %s (%Lu)\n",
                                bdevname(bio->bi_bdev, b),
                                (long long) bio->bi_sector);

Alasdair
-- 
agk@redhat.com
