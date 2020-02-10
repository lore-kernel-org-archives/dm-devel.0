From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 15/17] libmultipath: make directio checker
 share io contexts
Date: Mon, 10 Feb 2020 17:15:53 -0600
Message-ID: <20200210231553.GE30153@octiron.msp.redhat.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-16-git-send-email-bmarzins@redhat.com>
	<5f6810410ac8deac3e335ad45ba02184eff155ac.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5f6810410ac8deac3e335ad45ba02184eff155ac.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 10, 2020 at 06:08:14PM +0100, Martin Wilck wrote:
> On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> > On systems with a large number of cores (>500), io_destroy() can take
> > tens to hundreds of milliseconds to complete, due to RCU
> > synchronization. If there are a large number of paths using the directio
> > checker on such a system, this can lead to multipath taking almost a
> > minute to complete, with the vast majority of time taken up by
> > io_destroy().
> > 
> > To solve this, the directio checker now allocates one aio context for
> > every 1024 checkers. This reduces the io_destroy() delay to a thousandth
> > of its previous level. However, this means that muliple checkers are
> > sharing the same aio context, and must be able to handle getting results
> > for other checkers.  Because only one checker is ever running at a
> > time, this doesn't require any locking.  However, locking could be added
> > in the future if necessary, to allow multiple checkers to run at the
> > same time.
> > 
> > When checkers are freed, they usually no longer destroy the io context.
> > Instead, they attempt to cancel any outstanding request. If that fails,
> > they put the request on an orphan list, so that it can be freed by other
> > checkers, once it has completed. IO contexts are only destroyed at three
> > times, during reconfigure (to deal with the possibility that multipathd
> > is holding more aio events than it needs to be, since there is a single
> > limit for the whole system), when the checker class is unloaded, and
> > in a corner case when checkers are freed. If an aio_group (which
> > contains the aio context) is entirely full of orphaned requests, then
> > no checker can use it. Since no checker is using it, there is no checker
> > to clear out the orphaned requests. In this (likely rare) case, the
> > last checker from that group to be freed and leave behind an orphaned
> > request will call io_destroy() and remove the group.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/directio.c | 336 +++++++++++++++++++++++++------
> >  multipath/multipath.conf.5       |   7 +-
> >  2 files changed, 281 insertions(+), 62 deletions(-)
> 
> Although I concur now that your design is sound, I still have some
> issues, see below.
> 
> > 
> > diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
> > index 1b00b775..740c68e5 100644
> > --- a/libmultipath/checkers/directio.c
> > +++ b/libmultipath/checkers/directio.c
> > 
> > +/* If an aio_group is completely full of orphans, then no checkers can
> > + * use it, which means that no checkers can clear out the orphans. To
> > + * avoid keeping the useless group around, simply remove remove the
> > + * group */
> > +static void
> > +check_orphaned_group(struct aio_group *aio_grp)
> > +{
> > +	int count = 0;
> > +	struct list_head *item;
> > +
> > +	if (aio_grp->holders < AIO_GROUP_SIZE)
> > +		return;
> > +	list_for_each(item, &aio_grp->orphans)
> > +		count++;
> > +	if (count >= AIO_GROUP_SIZE) {
> > +		remove_aio_group(aio_grp);
> > +		if (list_empty(&aio_grp_list))
> > +			add_aio_group();
> 
> OK, but not beautiful. Can be improved later, I guess. In general, you
> could delay allocation of an aio_group until it's actually needed (i.e.
> when the first path is using it, in set_aio_group(), as you're already
> doing it for 2nd and later groups).

Sure. I figured it would be more consistent to always have a group after
start-up, since even on reset we keep a group around, to avoid the pain
of removing and then re-adding it. But there really isn't any need to do
it that way, so if you would rather it worked the other way, I can send
another patch to change that.

> 
> > +	}
> > +}
> > +
> > +int libcheck_load (void)
> > +{
> > +	if (add_aio_group() == NULL) {
> > +		LOG(1, "libcheck_load failed: %s", strerror(errno));
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +void libcheck_unload (void)
> > +{
> > +	struct aio_group *aio_grp, *tmp;
> > +
> > +	list_for_each_entry_safe(aio_grp, tmp, &aio_grp_list, node)
> > +		remove_aio_group(aio_grp);
> > +}
> 
> I have one concern here - this might cause delays during multipathd
> shutdown, which we have struggled to eliminate in previous patches.
> OTOH, according to what you wrote, with the current code the shutdown
> delays will probably be higher, so this is actually an improvement.
> We should take a mental note about the shutdown issue. Like with TUR,
> avoiding hanging on shutdown is tricky if we consider possibly hanging
> device I/O.

Yeah. This should be faster than calling io_destroy on each path, when
shutting down, especially when you have a large number of CPUs and
devices.

> > +
> > +int libcheck_reset (void)
> > +{
> > +	struct aio_group *aio_grp, *tmp, *reset_grp = NULL;
> > +
> > +	/* If a clean existing aio_group exists, use that. Otherwise add a
> > +	 * new one */
> > +	list_for_each_entry(aio_grp, &aio_grp_list, node) {
> > +		if (aio_grp->holders == 0 &&
> > +		    list_empty(&aio_grp->orphans)) {
> > +			reset_grp = aio_grp;
> > +			break;
> > +		}
> > +	}
> > +	if (!reset_grp)
> > +		reset_grp = add_aio_group();
> > +	if (!reset_grp) {
> > +		LOG(1, "checker reset failed");
> > +		return 1;
> > +	}
> > +
> > +	list_for_each_entry_safe(aio_grp, tmp, &aio_grp_list, node) {
> > +		if (aio_grp != reset_grp)
> > +			remove_aio_group(aio_grp);
> > +	}
> > +	return 0;
> > +}
> >  
> >  int libcheck_init (struct checker * c)
> >  {
> >  	unsigned long pgsize = getpagesize();
> >  	struct directio_context * ct;
> > +	struct async_req *req = NULL;
> >  	long flags;
> >  
> >  	ct = malloc(sizeof(struct directio_context));
> > @@ -56,26 +201,31 @@ int libcheck_init (struct checker * c)
> >  		return 1;
> >  	memset(ct, 0, sizeof(struct directio_context));
> >  
> > -	if (io_setup(1, &ct->ioctx) != 0) {
> > -		condlog(1, "io_setup failed");
> > -		free(ct);
> > -		return 1;
> > +	if (set_aio_group(ct) < 0)
> > +		goto out;
> > +
> > +	req = malloc(sizeof(struct async_req));
> > +	if (!req) {
> > +		goto out;
> >  	}
> > +	memset(req, 0, sizeof(struct async_req));
> > +	INIT_LIST_HEAD(&req->node);
> >  
> > -	if (ioctl(c->fd, BLKBSZGET, &ct->blksize) < 0) {
> > +	if (ioctl(c->fd, BLKBSZGET, &req->blksize) < 0) {
> >  		c->msgid = MSG_DIRECTIO_BLOCKSIZE;
> > -		ct->blksize = 512;
> > +		req->blksize = 512;
> 
> You didn't change this, but I wonder if this is really a safe default.
> IIUC it's safe (although perhaps a bit slower) to read a multiple of
> the logical block size, but reading less than the logical block size
> might fail. Perhaps we should default to 4k?

Sure. I can add that to the follow-up patch.

> >  	}
> > -	if (ct->blksize > 4096) {
> > +	if (req->blksize > 4096) {
> >  		/*
> >  		 * Sanity check for DASD; BSZGET is broken
> >  		 */
> > -		ct->blksize = 4096;
> > +		req->blksize = 4096;
> >  	}
> > -	if (!ct->blksize)
> > +	if (!req->blksize)
> >  		goto out;
> > -	ct->buf = (unsigned char *)malloc(ct->blksize + pgsize);
> > -	if (!ct->buf)
> > +
> > +	req->buf = (unsigned char *)malloc(req->blksize + pgsize);
> 
> Why don't you simply use posix_memalign()?

I just reused the code that was already there to allocate the buffer.
Again, follow up patch.

> > +	if (!req->buf)
> >  		goto out;
> >  
> >  	flags = fcntl(c->fd, F_GETFL);
> > @@ -88,17 +238,22 @@ int libcheck_init (struct checker * c)
> >  		ct->reset_flags = 1;
> >  	}
> >  
> > -	ct->ptr = (unsigned char *) (((unsigned long)ct->buf + pgsize - 1) &
> > +	req->ptr = (unsigned char *) (((unsigned long)req->buf + pgsize - 1) &
> >  		  (~(pgsize - 1)));
> 
> See above.
> 
> >  
> >  	/* Successfully initialized, return the context. */
> > +	ct->req = req;
> >  	c->context = (void *) ct;
> >  	return 0;
> >  
> >  out:
> > -	if (ct->buf)
> > -		free(ct->buf);
> > -	io_destroy(ct->ioctx);
> > +	if (req) {
> > +		if (req->buf)
> > +			free(req->buf);
> > +		free(req);
> > +	}
> > +	if (ct->aio_grp)
> > +		ct->aio_grp->holders--;
> >  	free(ct);
> >  	return 1;
> >  }
> > @@ -106,6 +261,7 @@ out:
> >  void libcheck_free (struct checker * c)
> >  {
> >  	struct directio_context * ct = (struct directio_context *)c->context;
> > +	struct io_event event;
> >  	long flags;
> >  
> >  	if (!ct)
> > @@ -121,20 +277,72 @@ void libcheck_free (struct checker * c)
> >  		}
> >  	}
> >  
> > -	if (ct->buf)
> > -		free(ct->buf);
> > -	io_destroy(ct->ioctx);
> > +	if (ct->running &&
> > +	    (ct->req->state != PATH_PENDING ||
> > +	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))
> > +		ct->running = 0;
> > +	if (!ct->running) {
> > +		free(ct->req->buf);
> > +		free(ct->req);
> > +		ct->aio_grp->holders--;
> > +	} else {
> > +		ct->req->state = PATH_REMOVED;
> > +		list_add(&ct->req->node, &ct->aio_grp->orphans);
> > +		check_orphaned_group(ct->aio_grp);
> > +	}
> > +
> >  	free(ct);
> > +	c->context = NULL;
> > +}
> > +
> > +static int
> > +get_events(struct aio_group *aio_grp, struct timespec *timeout)
> > +{
> > +	struct io_event events[128];
> > +	int i, nr, got_events = 0;
> > +	struct timespec zero_timeout = {0};
> > +	struct timespec *timep = (timeout)? timeout : &zero_timeout;
> 
> This isn't wrong, but the semantics of the "timeout" parameter are a
> bit confusing, as io_getevents() would interpret a NULL timeout as
> "forever", and get_events is mostly a wrapper around io_getevents().

Sure. I can change that.

> > +
> > +	do {
> > +		errno = 0;
> > +		nr = io_getevents(aio_grp->ioctx, 1, 128, events, timep);
> > +		got_events |= (nr > 0);
> > +
> > +		for (i = 0; i < nr; i++) {
> > +			struct async_req *req = container_of(events[i].obj, struct async_req, io);
> > +
> > +			LOG(3, "io finished %lu/%lu", events[i].res,
> > +			    events[i].res2);
> > +
> > +			/* got an orphaned request */
> > +			if (req->state == PATH_REMOVED) {
> > +				list_del(&req->node);
> > +				free(req->buf);
> > +				free(req);
> > +				aio_grp->holders--;
> > +			} else
> > +				req->state = (events[i].res == req->blksize) ?
> > +					      PATH_UP : PATH_DOWN;
> > +		}
> > +		timep = &zero_timeout;
> > +	} while (nr == 128); /* assume there are more events and try again */
> > +
> > +	if (nr < 0)
> > +		LOG(3, "async io getevents returned %i (errno=%s)",
> > +		    nr, strerror(errno));
> > +
> > +	return got_events;
> >  }
> >  static int
> >  check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
> >  {
> >  	struct timespec	timeout = { .tv_nsec = 5 };
> 
> What's the purpose of these 5ns? Unless the device in question is an
> NVDIMM, I'd say 5ns is practically equivalent to 0.

again, I just kept this the same to keep the checker working the same as
it did before, but yes, this basically means that checker will basically
always return PATH_PENDING on the call where it issues the IO for NAS
storage.  I'm fine with changing this to 1 ms. 

> 
> > -	struct io_event event;
> >  	struct stat	sb;
> > -	int		rc = PATH_UNCHECKED;
> > +	int		rc;
> >  	long		r;
> > +	struct timespec currtime, endtime;
> > +	struct timespec *timep = &timeout;
> >  
> >  	if (fstat(fd, &sb) == 0) {
> >  		LOG(4, "called for %x", (unsigned) sb.st_rdev);
> > @@ -145,50 +353,60 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
> >  		timeout.tv_nsec = 0;
> >  	}
> >  
> > -	if (!ct->running) {
> > -		struct iocb *ios[1] = { &ct->io };
> > +	if (ct->running) {
> > +		if (ct->req->state != PATH_PENDING) {
> > +			ct->running = 0;
> > +			return ct->req->state;
> > +		}
> > +	} else {
> > +		struct iocb *ios[1] = { &ct->req->io };
> >  
> >  		LOG(3, "starting new request");
> > -		memset(&ct->io, 0, sizeof(struct iocb));
> > -		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
> > -		if (io_submit(ct->ioctx, 1, ios) != 1) {
> > +		memset(&ct->req->io, 0, sizeof(struct iocb));
> > +		io_prep_pread(&ct->req->io, fd, ct->req->ptr,
> > +			      ct->req->blksize, 0);
> > +		ct->req->state = PATH_PENDING;
> > +		if (io_submit(ct->aio_grp->ioctx, 1, ios) != 1) {
> >  			LOG(3, "io_submit error %i", errno);
> >  			return PATH_UNCHECKED;
> >  		}
> >  	}
> >  	ct->running++;
> 
> This looks to me as if in the case (ct->running && ct->req->state ==
> PATH_PENDING), ct->running could become > 1, even though you don't
> start a new IO. Is that intended? I don't think it matters because you
> never decrement, but it looks weird.

That's necessary for how the checker currently works. In async mode
checker doesn't actually wait for a specific number of seconds (and
didn't before my patch). It assumes 1 sec call times for pending paths,
and times out after ct->running > timeout_secs. That's why the unit
tests can get away with simply calling the checker repeatedly, without
waiting, to make it timeout. But I suppose that wait_for_pending_paths()
will also be making the checker time out quicker, so this should
probably be changed. However, since check_path won't set a paths state
to PATH_PENDING if it wasn't already, it's not really a very likely
issue to occur.
 
> >  
> > -	errno = 0;
> > -	r = io_getevents(ct->ioctx, 1L, 1L, &event, &timeout);
> > +	get_monotonic_time(&endtime);
> > +	endtime.tv_sec += timeout.tv_sec;
> > +	endtime.tv_nsec += timeout.tv_nsec;
> > +	normalize_timespec(&endtime);
> > +	while(1) {
> > +		r = get_events(ct->aio_grp, timep);
> >  
> > -	if (r < 0 ) {
> > -		LOG(3, "async io getevents returned %li (errno=%s)", r,
> > -		    strerror(errno));
> > -		ct->running = 0;
> > -		rc = PATH_UNCHECKED;
> > -	} else if (r < 1L) {
> > -		if (ct->running > timeout_secs || sync) {
> > -			struct iocb *ios[1] = { &ct->io };
> > -
> > -			LOG(3, "abort check on timeout");
> > -			r = io_cancel(ct->ioctx, ios[0], &event);
> > -			/*
> > -			 * Only reset ct->running if we really
> > -			 * could abort the pending I/O
> > -			 */
> > -			if (r)
> > -				LOG(3, "io_cancel error %i", errno);
> > -			else
> > -				ct->running = 0;
> > -			rc = PATH_DOWN;
> > -		} else {
> > -			LOG(3, "async io pending");
> > -			rc = PATH_PENDING;
> > -		}
> > +		if (ct->req->state != PATH_PENDING) {
> > +			ct->running = 0;
> > +			return ct->req->state;
> > +		} else if (r == 0 || !timep)
> > +			break;
> > +
> > +		get_monotonic_time(&currtime);
> > +		timespecsub(&endtime, &currtime, &timeout);
> > +		if (timeout.tv_sec < 0)
> > +			timep = NULL;
> 
> See comment for get_events() above. Why don't you simply do this?
> 
>     timeout.tv_sec = timeout.tv_nsec = 0;
> 

Sure.

So, If I will post a seperate patch that resolves these issues, can this
one have an ack?

-Ben

> 
> > +	}
> > +	if (ct->running > timeout_secs || sync) {
> > +		struct io_event event;
> > +
> > +		LOG(3, "abort check on timeout");
> > +
> > +		r = io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
> > +		/*
> > +		 * Only reset ct->running if we really
> > +		 * could abort the pending I/O
> 
> ... which will never happen ... but never mind.
> 
> > +		 */
> > +		if (!r)
> > +			ct->running = 0;
> > +		rc = PATH_DOWN;
> >  	} else {
> > -		LOG(3, "io finished %lu/%lu", event.res, event.res2);
> > -		ct->running = 0;
> > -		rc = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
> > +		LOG(3, "async io pending");
> > +		rc = PATH_PENDING;
> >  	}
> >  
> >  	return rc;
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index dc103fd8..05a5e8ff 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -494,9 +494,10 @@ Check the path state for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
> >  Series, and OEM arrays from IBM DELL SGI STK and SUN.
> >  .TP
> >  .I directio
> > -(Deprecated) Read the first sector with direct I/O. This checker is being
> > -deprecated, it could cause spurious path failures under high load.
> > -Please use \fItur\fR instead.
> > +(Deprecated) Read the first sector with direct I/O. If you have a large number
> > +of paths, or many AIO users on a system, you may need to use sysctl to
> > +increase fs.aio-max-nr. This checker is being deprecated, it could cause
> > +spurious path failures under high load. Please use \fItur\fR instead.
> >  .TP
> >  .I cciss_tur
> >  (Hardware-dependent)
> 
