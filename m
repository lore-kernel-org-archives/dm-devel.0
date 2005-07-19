From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: map removal and multipathd
Date: Tue, 19 Jul 2005 12:17:24 -0500
Message-ID: <20050719171724.GA30565@phlogiston.msp.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AB75@SRMANNING.eng.emc.com>
	<1121469010.26998.145.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1121469010.26998.145.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 16, 2005 at 01:10:10AM +0200, christophe varoqui wrote:
> Nice hunt, applied.
> Glad to see this long standing issue get the attention it deserved :)
> 
> I suspect this patch will also plugs an annoying memory leak I spotted
> recently. Will check.
> 
> Regards,
> cvaroqui

It is sort of late in the game for redhat to be making kernel patches for the
next release, so here is an alternate way of getting to break out of the
waitevent pthread.  I don't really care if you include this, Christophe. We
need it so that we can avoid adding another kernel patch for this release,
but in the future, I don't see a problem with using Ed's kernel patch.
I just wanted to post this in case anyone else found it useful.  If you do
take this, feel free to switch the signal if you had other uses in mind for
SIGHUP.

Oh, and since multipathd doesn't ever do pthread_joins, I made the threads
be detached, so that they can completely clean up once they exit. This
probably should get included, to plug a small memory leak.

Enjoy,
Ben

 
> On ven, 2005-07-15 at 11:08 -0400, goggin, edward wrote:
> > I've found the removal of a multipath map (or all of them for that matter)
> > to be troublesome
> > for multipathd, particularly its waitevent pthreads.  The dm driver in the
> > kernel was not waking
> > up the dm event waiters so they stayed in the kernel where each one held a
> > reference on the
> > mapped device and its table.  This held reference prevented the multipathd
> > from receiving either
> > a uevent or a hotplug event for the removal of the multipath block device --
> > since it is not removed
> > in this case.
> > 
> > --- drivers/md/dm-ioctl.c.orig	2005-07-14 13:33:56.000000000 -0500
> > +++ drivers/md/dm-ioctl.c	2005-07-14 22:01:04.000000000 -0500
> > @@ -226,10 +226,22 @@
> >  
> >  static void __hash_remove(struct hash_cell *hc)
> >  {
> > +	struct dm_table *table;
> > +
> >  	/* remove from the dev hash */
> >  	list_del(&hc->uuid_list);
> >  	list_del(&hc->name_list);
> >  	unregister_with_devfs(hc);
> > +
> > +	/*
> > +	 * Wakeup any dm event waiters.
> > +	 */
> > +	table = dm_get_table(hc->md);
> > +	if (table) {
> > +		dm_table_event(table);
> > +		dm_table_put(table);
> > +	}
> > +
> >  	dm_put(hc->md);
> >  	if (hc->new_map)
> >  		dm_table_put(hc->new_map);
> > 
> > With dm-ioctl.c patched to wake up waiting dm event threads when a mapped
> > device is removed,
> > multipathd has issues.  Fixed 3 bugs
> > 
> > 	(1) update_multipath wasn't dealing with an error from
> > setup_multipath.  Setup_multipath
> > 	error path involved the call chain
> > update_multipath_strings->update_multipath_table->
> > 	dm_get_map->dm_task_run->ioctl.  Since the mpp structure for a block
> > device could be
> > 	deallocated in setup_multipath, the multipathd could SIGSEGV when it
> > referenced the
> > 	deallocated mpp memory in update_multipath.
> > 
> > 	(2) The waitevent pthread's dm task structure memory was getting
> > destroyed twice if
> > 	it ever broke out of its waitevent loop due to the call to
> > waiteventloop returning < 0.  I
> > 	set wp->dmt to null after waiteventloop called dm_task_destroy to
> > prevent free_waiter
> > 	from doing likewise.
> > 
> > 	(3) setup_multipath was not removing the mpp ptr from the
> > allpaths->mpvec vector if it
> > 	deallocated the mpp structure memory due to the error occurrence
> > mentioned in (1).
> > 	This omission would cause multipathd mpvec_garbage_collector to
> > SIGSEGV.
> > 	Fixed uev_add_map since it had the same issue.
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -207,6 +207,7 @@ static int
> >  setup_multipath (struct paths * allpaths, struct multipath * mpp)
> >  {
> >  	char * wwid;
> > +	int i;
> >  
> >  	wwid = get_mpe_wwid(mpp->alias);
> >  
> > @@ -227,6 +228,12 @@ setup_multipath (struct paths * allpaths
> >  
> >  	return 0;
> >  out:
> > +	/*
> > +	 * purge the multipath vector
> > +	 */
> > +	if ((i = find_slot(allpaths->mpvec, (void *)mpp)) != -1)
> > +		vector_del_slot(allpaths->mpvec, i);
> > +
> >  	free_multipath(mpp, KEEP_PATHS);
> >  	condlog(0, "failed to setup multipath");
> >  	return 1;
> > @@ -275,7 +282,8 @@ update_multipath (struct paths *allpaths
> >  	free_pgvec(mpp->pg, KEEP_PATHS);
> >  	mpp->pg = NULL;
> >  
> > -	setup_multipath(allpaths, mpp);
> > +	if (setup_multipath(allpaths, mpp))
> > +		goto out; /* mpp freed in setup_multipath */
> >  
> >  	/*
> >  	 * compare checkers states with DM states
> > @@ -311,7 +319,8 @@ free_waiter (void * data)
> >  {
> >  	struct event_thread * wp = (struct event_thread *)data;
> >  
> > -	dm_task_destroy(wp->dmt);
> > +	if (wp->dmt)
> > +		dm_task_destroy(wp->dmt);
> >  	FREE(wp);
> >  }
> >  
> > @@ -344,6 +353,7 @@ waiteventloop (struct event_thread * wai
> >  	dm_task_run(waiter->dmt);
> >  	pthread_testcancel();
> >  	dm_task_destroy(waiter->dmt);
> > +	waiter->dmt = NULL;
> >  
> >  	waiter->event_nr++;
> >  
> > @@ -509,7 +519,7 @@ remove_maps (struct paths * allpaths)
> >  int
> >  uev_add_map (char * devname, struct paths * allpaths)
> >  {
> > -	int major, minor;
> > +	int major, minor, i;
> >  	char dev_t[BLK_DEV_SIZE];
> >  	char * alias;
> >  	struct multipath * mpp;
> > @@ -570,6 +580,12 @@ uev_add_map (char * devname, struct path
> >  	return 0;
> >  out:
> >  	condlog(2, "add %s devmap failed", mpp->alias);
> > +	/*
> > +	 * purge the multipath vector
> > +	 */
> > +	if ((i = find_slot(allpaths->mpvec, (void *)mpp)) != -1)
> > +		vector_del_slot(allpaths->mpvec, i);
> > +
> >  	free_multipath(mpp, KEEP_PATHS);
> >  	return 1;
> >  }
> > @@ -874,7 +890,8 @@ get_dm_mpvec (struct paths * allpaths)
> >  		return 1;
> >  
> >  	vector_foreach_slot (allpaths->mpvec, mpp, i) {
> > -		setup_multipath(allpaths, mpp);
> > +		if (setup_multipath(allpaths, mpp))
> > +			return 1;
> >  		mpp->minor = dm_get_minor(mpp->alias);
> >  		start_waiter_thread(mpp, allpaths);
> >  	}
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> -- 
> christophe varoqui <christophe.varoqui@free.fr>
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="breakout.patch"

diff -urpN mp-devel/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel/multipathd/main.c	2005-07-19 12:13:20.848661856 -0500
+++ mp-devel-patched/multipathd/main.c	2005-07-19 12:13:47.646587952 -0500
@@ -325,6 +325,16 @@ free_waiter (void * data)
 	FREE(wp);
 }
 
+static sigset_t unblock_sighup(void)
+{
+	sigset_t set, old;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGHUP);
+	pthread_sigmask(SIG_UNBLOCK, &set, &old);
+	return old;
+}
+
 /*
  * returns the reschedule delay
  * negative means *stop*
@@ -332,6 +342,7 @@ free_waiter (void * data)
 static int
 waiteventloop (struct event_thread * waiter)
 {
+	sigset_t set;
 	int event_nr;
 	int r;
 
@@ -350,7 +361,9 @@ waiteventloop (struct event_thread * wai
 
 	dm_task_no_open_count(waiter->dmt);
 
+	set = unblock_sighup();
 	dm_task_run(waiter->dmt);
+	pthread_sigmask(SIG_SETMASK, &set, NULL);
 	pthread_testcancel();
 	dm_task_destroy(waiter->dmt);
 	waiter->dmt = NULL;
@@ -424,13 +437,18 @@ static int
 stop_waiter_thread (struct multipath * mpp, struct paths * allpaths)
 {
 	struct event_thread * wp = (struct event_thread *)mpp->waiter;
+	pthread_t thread = wp->thread;
+	int r;
 
 	if (!wp)
 		return 1;
 
 	condlog(2, "%s: reap event checker", wp->mapname);
 
-	return pthread_cancel(wp->thread);
+	if ((r = pthread_cancel(thread)))
+		return r;
+	pthread_kill(thread, SIGHUP);
+	return 0;
 }
 
 static int
@@ -446,6 +464,7 @@ start_waiter_thread (struct multipath * 
 		goto out;
 
 	pthread_attr_setstacksize(&attr, 32 * 1024);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 	wp = alloc_waiter();
 
 	if (!wp)
@@ -1408,6 +1427,7 @@ child (void * param)
 	 */
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 64 * 1024);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 	
 	pthread_create(&check_thr, &attr, checkerloop, allpaths);
 	pthread_create(&uevent_thr, &attr, ueventloop, allpaths);

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--oyUTqETQ0mS9luUI--
