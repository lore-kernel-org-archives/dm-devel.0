From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Mon, 25 Jan 2016 17:37:17 -0600
Message-ID: <20160125233717.GQ24960@octiron.msp.redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160125214016.GA10060@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

On Mon, Jan 25, 2016 at 04:40:16PM -0500, Mike Snitzer wrote:
> On Tue, Jan 19 2016 at  5:45P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:

I don't think this is going to help __multipath_map() without some
configuration changes.  Now that we're running on already merged
requests instead of bios, the m->repeat_count is almost always set to 1,
so we call the path_selector every time, which means that we'll always
need the write lock. Bumping up the number of IOs we send before calling
the path selector again will give this patch a change to do some good
here.

To do that you need to set:

	rr_min_io_rq <something_bigger_than_one>

in the defaults section of /etc/multipath.conf and then reload the
multipathd service.

The patch should hopefully help in multipath_busy() regardless of the
the rr_min_io_rq setting.

-Ben

> 
> > On Mon, Jan 18 2016 at  7:04am -0500,
> > Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> > 
> > > Hi All,
> > > 
> > > I've recently tried out dm-multipath over a "super-fast" nvme device
> > > and noticed a serious lock contention in dm-multipath that requires some
> > > extra attention. The nvme device is a simple loopback device emulation
> > > backed by null_blk device.
> > > 
> > > With this I've seen dm-multipath pushing around ~470K IOPs while
> > > the native (loopback) nvme performance can easily push up to 1500K+ IOPs.
> > > 
> > > perf output [1] reveals a huge lock contention on the multipath lock
> > > which is a per-dm_target contention point which seem to defeat the
> > > purpose of blk-mq i/O path.
> > > 
> > > The two current bottlenecks seem to come from multipath_busy and
> > > __multipath_map. Would it make better sense to move to a percpu_ref
> > > model with freeze/unfreeze logic for updates similar to what blk-mq
> > > is doing?
> > >
> > > Thoughts?
> > 
> > Your perf output clearly does identify the 'struct multipath' spinlock
> > as a bottleneck.
> > 
> > Is it fair to assume that implied in your test is that you increased
> > md->tag_set.nr_hw_queues to > 1 in dm_init_request_based_blk_mq_queue()?
> > 
> > I'd like to start by replicating your testbed.  So I'll see about
> > setting up the nvme loop driver you referenced in earlier mail.
> > Can you share your fio job file and fio commandline for your test?
> 
> Would still appreciate answers to my 2 questions above (did you modify
> md->tag_set.nr_hw_queues and can you share your fio job?)
> 
> I've yet to reproduce your config (using hch's nvme loop driver) or
> test to verify your findings but I did develop a patch that switches
> from spinlock_t to rwlock_t.  I've only compile tested this but I'll try
> to reproduce your setup and then test this patch to see if it helps.
> 
> Your worst offenders (multipath_busy and __multipath_map) are now using
> a read lock in the fast path.
> 
>  drivers/md/dm-mpath.c | 127 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 83 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index cfa29f5..34aadb1 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -11,6 +11,7 @@
>  #include "dm-path-selector.h"
>  #include "dm-uevent.h"
>  
> +#include <linux/rwlock_types.h>
>  #include <linux/blkdev.h>
>  #include <linux/ctype.h>
>  #include <linux/init.h>
> @@ -67,7 +68,7 @@ struct multipath {
>  	const char *hw_handler_name;
>  	char *hw_handler_params;
>  
> -	spinlock_t lock;
> +	rwlock_t lock;
>  
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
> @@ -189,7 +190,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
>  	m = kzalloc(sizeof(*m), GFP_KERNEL);
>  	if (m) {
>  		INIT_LIST_HEAD(&m->priority_groups);
> -		spin_lock_init(&m->lock);
> +		rwlock_init(&m->lock);
>  		m->queue_io = 1;
>  		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
>  		INIT_WORK(&m->trigger_event, trigger_event);
> @@ -386,12 +387,24 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  	struct pgpath *pgpath;
>  	struct block_device *bdev;
>  	struct dm_mpath_io *mpio;
> +	bool use_write_lock = false;
>  
> -	spin_lock_irq(&m->lock);
> +retry:
> +	if (!use_write_lock)
> +		read_lock_irq(&m->lock);
> +	else
> +		write_lock_irq(&m->lock);
>  
>  	/* Do we need to select a new pgpath? */
> -	if (!m->current_pgpath ||
> -	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
> +	if (!use_write_lock) {
> +		if (!m->current_pgpath ||
> +		    (!m->queue_io && (m->repeat_count && m->repeat_count == 1))) {
> +			use_write_lock = true;
> +			read_unlock_irq(&m->lock);
> +			goto retry;
> +		}
> +	} else if (!m->current_pgpath ||
> +		   (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
>  		__choose_pgpath(m, nr_bytes);
>  
>  	pgpath = m->current_pgpath;
> @@ -401,13 +414,23 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  			r = -EIO;	/* Failed */
>  		goto out_unlock;
>  	} else if (m->queue_io || m->pg_init_required) {
> +		if (!use_write_lock) {
> +			use_write_lock = true;
> +			read_unlock_irq(&m->lock);
> +			goto retry;
> +		}
>  		__pg_init_all_paths(m);
>  		goto out_unlock;
>  	}
>  
> +	if (!use_write_lock)
> +		read_unlock_irq(&m->lock);
> +	else
> +		write_unlock_irq(&m->lock);
> +
>  	if (set_mapinfo(m, map_context) < 0)
>  		/* ENOMEM, requeue */
> -		goto out_unlock;
> +		return r;
>  
>  	mpio = map_context->ptr;
>  	mpio->pgpath = pgpath;
> @@ -415,8 +438,6 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  
>  	bdev = pgpath->path.dev->bdev;
>  
> -	spin_unlock_irq(&m->lock);
> -
>  	if (clone) {
>  		/* Old request-based interface: allocated clone is passed in */
>  		clone->q = bdev_get_queue(bdev);
> @@ -443,7 +464,10 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  	return DM_MAPIO_REMAPPED;
>  
>  out_unlock:
> -	spin_unlock_irq(&m->lock);
> +	if (!use_write_lock)
> +		read_unlock_irq(&m->lock);
> +	else
> +		write_unlock_irq(&m->lock);
>  
>  	return r;
>  }
> @@ -474,14 +498,15 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  
>  	if (save_old_value)
>  		m->saved_queue_if_no_path = m->queue_if_no_path;
>  	else
>  		m->saved_queue_if_no_path = queue_if_no_path;
>  	m->queue_if_no_path = queue_if_no_path;
> -	spin_unlock_irqrestore(&m->lock, flags);
> +
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	if (!queue_if_no_path)
>  		dm_table_run_md_queue_async(m->ti->table);
> @@ -898,12 +923,12 @@ static void multipath_wait_for_pg_init_completion(struct multipath *m)
>  	while (1) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  
> -		spin_lock_irqsave(&m->lock, flags);
> +		read_lock_irqsave(&m->lock, flags);
>  		if (!m->pg_init_in_progress) {
> -			spin_unlock_irqrestore(&m->lock, flags);
> +			read_unlock_irqrestore(&m->lock, flags);
>  			break;
>  		}
> -		spin_unlock_irqrestore(&m->lock, flags);
> +		read_unlock_irqrestore(&m->lock, flags);
>  
>  		io_schedule();
>  	}
> @@ -916,18 +941,18 @@ static void flush_multipath_work(struct multipath *m)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  	m->pg_init_disabled = 1;
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	flush_workqueue(kmpath_handlerd);
>  	multipath_wait_for_pg_init_completion(m);
>  	flush_workqueue(kmultipathd);
>  	flush_work(&m->trigger_event);
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  	m->pg_init_disabled = 0;
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  }
>  
>  static void multipath_dtr(struct dm_target *ti)
> @@ -946,7 +971,7 @@ static int fail_path(struct pgpath *pgpath)
>  	unsigned long flags;
>  	struct multipath *m = pgpath->pg->m;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  
>  	if (!pgpath->is_active)
>  		goto out;
> @@ -968,7 +993,7 @@ static int fail_path(struct pgpath *pgpath)
>  	schedule_work(&m->trigger_event);
>  
>  out:
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	return 0;
>  }
> @@ -982,7 +1007,7 @@ static int reinstate_path(struct pgpath *pgpath)
>  	unsigned long flags;
>  	struct multipath *m = pgpath->pg->m;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  
>  	if (pgpath->is_active)
>  		goto out;
> @@ -1014,7 +1039,7 @@ static int reinstate_path(struct pgpath *pgpath)
>  	schedule_work(&m->trigger_event);
>  
>  out:
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  	if (run_queue)
>  		dm_table_run_md_queue_async(m->ti->table);
>  
> @@ -1049,13 +1074,13 @@ static void bypass_pg(struct multipath *m, struct priority_group *pg,
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  
>  	pg->bypassed = bypassed;
>  	m->current_pgpath = NULL;
>  	m->current_pg = NULL;
>  
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	schedule_work(&m->trigger_event);
>  }
> @@ -1076,7 +1101,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
>  		return -EINVAL;
>  	}
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  	list_for_each_entry(pg, &m->priority_groups, list) {
>  		pg->bypassed = 0;
>  		if (--pgnum)
> @@ -1086,7 +1111,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
>  		m->current_pg = NULL;
>  		m->next_pg = pg;
>  	}
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	schedule_work(&m->trigger_event);
>  	return 0;
> @@ -1125,14 +1150,14 @@ static int pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
>  	unsigned long flags;
>  	int limit_reached = 0;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  
>  	if (m->pg_init_count <= m->pg_init_retries && !m->pg_init_disabled)
>  		m->pg_init_required = 1;
>  	else
>  		limit_reached = 1;
>  
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  
>  	return limit_reached;
>  }
> @@ -1186,7 +1211,7 @@ static void pg_init_done(void *data, int errors)
>  		fail_path(pgpath);
>  	}
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  	if (errors) {
>  		if (pgpath == m->current_pgpath) {
>  			DMERR("Could not failover device. Error %d.", errors);
> @@ -1213,7 +1238,7 @@ static void pg_init_done(void *data, int errors)
>  	wake_up(&m->pg_init_wait);
>  
>  out:
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  }
>  
>  static void activate_path(struct work_struct *work)
> @@ -1272,7 +1297,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (mpio->pgpath)
>  		fail_path(mpio->pgpath);
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	read_lock_irqsave(&m->lock, flags);
>  	if (!m->nr_valid_paths) {
>  		if (!m->queue_if_no_path) {
>  			if (!__must_push_back(m))
> @@ -1282,7 +1307,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  				r = error;
>  		}
>  	}
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	read_unlock_irqrestore(&m->lock, flags);
>  
>  	return r;
>  }
> @@ -1340,9 +1365,9 @@ static void multipath_resume(struct dm_target *ti)
>  	struct multipath *m = (struct multipath *) ti->private;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	write_lock_irqsave(&m->lock, flags);
>  	m->queue_if_no_path = m->saved_queue_if_no_path;
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	write_unlock_irqrestore(&m->lock, flags);
>  }
>  
>  /*
> @@ -1372,7 +1397,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
>  	unsigned pg_num;
>  	char state;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	read_lock_irqsave(&m->lock, flags);
>  
>  	/* Features */
>  	if (type == STATUSTYPE_INFO)
> @@ -1467,7 +1492,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
>  		break;
>  	}
>  
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	read_unlock_irqrestore(&m->lock, flags);
>  }
>  
>  static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
> @@ -1534,16 +1559,27 @@ out:
>  }
>  
>  static int multipath_prepare_ioctl(struct dm_target *ti,
> -		struct block_device **bdev, fmode_t *mode)
> +				   struct block_device **bdev, fmode_t *mode)
>  {
>  	struct multipath *m = ti->private;
>  	unsigned long flags;
>  	int r;
> +	bool use_write_lock = false;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +retry:
> +	if (!use_write_lock)
> +		read_lock_irqsave(&m->lock, flags);
> +	else
> +		write_lock_irqsave(&m->lock, flags);
>  
> -	if (!m->current_pgpath)
> +	if (!m->current_pgpath) {
> +		if (!use_write_lock) {
> +			use_write_lock = true;
> +			read_unlock_irqrestore(&m->lock, flags);
> +			goto retry;
> +		}
>  		__choose_pgpath(m, 0);
> +	}
>  
>  	if (m->current_pgpath) {
>  		if (!m->queue_io) {
> @@ -1562,17 +1598,20 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
>  			r = -EIO;
>  	}
>  
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	if (!use_write_lock)
> +		read_unlock_irqrestore(&m->lock, flags);
> +	else
> +		write_unlock_irqrestore(&m->lock, flags);
>  
>  	if (r == -ENOTCONN) {
> -		spin_lock_irqsave(&m->lock, flags);
> +		write_lock_irqsave(&m->lock, flags);
>  		if (!m->current_pg) {
>  			/* Path status changed, redo selection */
>  			__choose_pgpath(m, 0);
>  		}
>  		if (m->pg_init_required)
>  			__pg_init_all_paths(m);
> -		spin_unlock_irqrestore(&m->lock, flags);
> +		write_unlock_irqrestore(&m->lock, flags);
>  		dm_table_run_md_queue_async(m->ti->table);
>  	}
>  
> @@ -1627,7 +1666,7 @@ static int multipath_busy(struct dm_target *ti)
>  	struct pgpath *pgpath;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&m->lock, flags);
> +	read_lock_irqsave(&m->lock, flags);
>  
>  	/* pg_init in progress or no paths available */
>  	if (m->pg_init_in_progress ||
> @@ -1674,7 +1713,7 @@ static int multipath_busy(struct dm_target *ti)
>  		busy = 0;
>  
>  out:
> -	spin_unlock_irqrestore(&m->lock, flags);
> +	read_unlock_irqrestore(&m->lock, flags);
>  
>  	return busy;
>  }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
