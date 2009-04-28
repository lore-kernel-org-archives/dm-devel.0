From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Tue, 28 Apr 2009 12:35:27 -0700
Message-ID: <1240947327.13184.13.camel@chandra-ubuntu>
References: <200904281145.40357.knikanth@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200904281145.40357.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Nikanth,

Talked to Alasdair regarding this during yesterday's dm-devel conf call.

He mentioned that he is not convinced with "why 2 seconds", why not any
other numbers. Basically, he doesn't want another patch following this
after few days saying that we want to change it to X seconds :)

I am working on a patch on keeping it 2 seconds and adding a parameter
giving user/user space tool the control to change it to any number.

On Tue, 2009-04-28 at 11:45 +0530, Nikanth Karthikesan wrote:
> On Saturday 21 February 2009 02:41:33 Chandra Seetharaman wrote:
> > On Fri, 2009-02-20 at 10:33 +0530, Nikanth Karthikesan wrote:
> > > On Friday 20 February 2009 06:15:29 Chandra Seetharaman wrote:
> > > > On Thu, 2009-02-19 at 12:40 +0530, Nikanth Karthikesan wrote:
> > > >
> > >
> > > I missed resetting pg_init_delay to zero after using it. I have attached
> > > the corrected patch with this. This variable keeps the code
> > > cleaner(avoids taking m->lock). Also having only a boolean in struct
> > > multipath keeps it a bit smaller.
> >
> > Ok. I am fine with your justification.
> >
> > > off-topic:
> > > I think struct multipath can be shrunk even further by making various
> > > flags like pg_init_required, pg_init_in_progress, queue_io,
> > > queue_if_no_path, saved_queue_if_no_path in to a single variable.
> > > Thoughts?
> >
> > As Konrad mentioned, it is worth the cost of readability ?
> >
> >
> 
> I think based on the above off-topic comment you had mistakenly marked this in 
> patch-work as changes requested.
> 
> > <snip>
> >
> > > SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
> > > immediately and SCSI_DH_RETRY in cases where it is better to retry
> > > after some delay.
> > >
> > > Currently we retry immediately irrespective of SCSI_DH_IMM_RETRY and
> > > SCSI_DH_RETRY.  This patch adds a 2 second delay before retrying to
> > > activate a device, if it returns SCSI_DH_RETRY.
> > >
> > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
> >
> 
> All the comments received were incorporated already.
> 
> Can you merge this?
> 
> Thanks
> Nikanth
> 
> > > ---
> > >
> > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > index 095f77b..7ddf775 100644
> > > --- a/drivers/md/dm-mpath.c
> > > +++ b/drivers/md/dm-mpath.c
> > > @@ -65,12 +65,13 @@ struct multipath {
> > >  	spinlock_t lock;
> > >
> > >  	const char *hw_handler_name;
> > > -	struct work_struct activate_path;
> > > +	struct delayed_work activate_path;
> > >  	struct pgpath *pgpath_to_activate;
> > >  	unsigned nr_priority_groups;
> > >  	struct list_head priority_groups;
> > >  	unsigned pg_init_required;	/* pg_init needs calling? */
> > >  	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
> > > +	unsigned pg_init_delay;		/* delay required before retry? */
> > >
> > >  	unsigned nr_valid_paths;	/* Total number of usable paths */
> > >  	struct pgpath *current_pgpath;
> > > @@ -203,7 +204,7 @@ static struct multipath *alloc_multipath(struct
> > > dm_target *ti) m->queue_io = 1;
> > >  		INIT_WORK(&m->process_queued_ios, process_queued_ios);
> > >  		INIT_WORK(&m->trigger_event, trigger_event);
> > > -		INIT_WORK(&m->activate_path, activate_path);
> > > +		INIT_DELAYED_WORK(&m->activate_path, activate_path);
> > >  		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
> > >  		if (!m->mpio_pool) {
> > >  			kfree(m);
> > > @@ -431,6 +432,7 @@ static void process_queued_ios(struct work_struct
> > > *work) struct pgpath *pgpath = NULL;
> > >  	unsigned init_required = 0, must_queue = 1;
> > >  	unsigned long flags;
> > > +	unsigned long delay = 0;
> > >
> > >  	spin_lock_irqsave(&m->lock, flags);
> > >
> > > @@ -452,13 +454,17 @@ static void process_queued_ios(struct work_struct
> > > *work) m->pg_init_required = 0;
> > >  		m->pg_init_in_progress = 1;
> > >  		init_required = 1;
> > > +		if (m->pg_init_delay) {
> > > +			delay = SCSI_DH_RETRY_DELAY;
> > > +			m->pg_init_delay = 0;
> > > +		}
> > >  	}
> > >
> > >  out:
> > >  	spin_unlock_irqrestore(&m->lock, flags);
> > >
> > >  	if (init_required)
> > > -		queue_work(kmpath_handlerd, &m->activate_path);
> > > +		queue_delayed_work(kmpath_handlerd, &m->activate_path, delay);
> > >
> > >  	if (!must_queue)
> > >  		dispatch_queued_ios(m);
> > > @@ -1060,6 +1066,7 @@ static void pg_init_done(struct dm_path *path, int
> > > errors) struct priority_group *pg = pgpath->pg;
> > >  	struct multipath *m = pg->m;
> > >  	unsigned long flags;
> > > +	unsigned delay = 0;
> > >
> > >  	/* device or driver problems */
> > >  	switch (errors) {
> > > @@ -1084,8 +1091,11 @@ static void pg_init_done(struct dm_path *path, int
> > > errors) */
> > >  		bypass_pg(m, pg, 1);
> > >  		break;
> > > -	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
> > > +	/*
> > > +	 * For SCSI_DH_RETRY we wait before retrying.
> > > +	 */
> > >  	case SCSI_DH_RETRY:
> > > +		delay = 1;
> > >  	case SCSI_DH_IMM_RETRY:
> > >  	case SCSI_DH_RES_TEMP_UNAVAIL:
> > >  		if (pg_init_limit_reached(m, pgpath))
> > > @@ -1112,6 +1122,7 @@ static void pg_init_done(struct dm_path *path, int
> > > errors) }
> > >
> > >  	m->pg_init_in_progress = 0;
> > > +	m->pg_init_delay = delay;
> > >  	queue_work(kmultipathd, &m->process_queued_ios);
> > >  	spin_unlock_irqrestore(&m->lock, flags);
> > >  }
> > > @@ -1120,7 +1131,7 @@ static void activate_path(struct work_struct *work)
> > >  {
> > >  	int ret;
> > >  	struct multipath *m =
> > > -		container_of(work, struct multipath, activate_path);
> > > +		container_of(work, struct multipath, activate_path.work);
> > >  	struct dm_path *path;
> > >  	unsigned long flags;
> > >
> > > diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> > > index 33efce2..f099d86 100644
> > > --- a/include/scsi/scsi_dh.h
> > > +++ b/include/scsi/scsi_dh.h
> > > @@ -55,6 +55,10 @@ enum {
> > >  	SCSI_DH_NOSYS,
> > >  	SCSI_DH_DRIVER_MAX,
> > >  };
> > > +
> > > +/* Time to wait before retry in case of SCSI_DH_RETRY */
> > > +#define SCSI_DH_RETRY_DELAY ((HZ * 2))
> > > +
> > >  #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
> > >  extern int scsi_dh_activate(struct request_queue *);
> > >  extern int scsi_dh_handler_exist(const char *);
> > > &#0;
> 
> 
