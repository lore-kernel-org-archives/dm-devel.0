From: "goggin, edward" <egoggin@emc.com>
Subject: RE: curious why waitevent sets event_nr field of event
	_thread struct every time
Date: Tue, 5 Apr 2005 12:56:07 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A8B8@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Wed, 30 Mar 2005 00:31:11 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote
> Have you tried your suggested design ?
> Is there a regression at first glance ?

I've tried it.  The code only blindly sets the event_nr from
the kernel the first time through.  Otherwise, if the kernel's copy
and the pthread's copy are different the code (1) logs a msg,
(2) sets the pthread copy from the kernel copy, and (3) goes to a
new label "out2" to fail the paths and invoke multipath.

I ran three to four times and saw log messages indicating that
several events had the potential of being lost.  Overall, while
this seems to be the right thing to do -- proving that events
would actually be lost is a different thing all together.  I did
not even attempt to do that.

I've included below a patch for multipathd/main.c based on version
0.4.4-pre7 of multipath-tools.
-----------------------------------------------------------------
*** multipath-tools-0.4.4-pre7/multipathd/main.c.orig	2005-04-05
04:46:30.000000000 -0400
--- multipath-tools-0.4.4-pre7/multipathd/main.c	2005-04-05
04:51:03.000000000 -0400
***************
*** 88,93 ****
--- 88,94 ----
  	int event_nr;
  	char mapname[WWID_SIZE];
  	struct paths *allpaths;
+ 	int firstTime;
  };
  
  /*
***************
*** 245,250 ****
--- 246,252 ----
  	char buff[1];
  	char cmd[CMDSIZE];
  	struct dm_task *dmt;
+ 	int event_nr;
  
  	mlockall(MCL_CURRENT | MCL_FUTURE);
  	waiter = (struct event_thread *)et;
***************
*** 256,262 ****
  	}
  	pthread_mutex_lock (waiter->waiter_lock);
  
! 	waiter->event_nr = dm_geteventnr (waiter->mapname);
  	log_safe(LOG_DEBUG, "waiter->event_nr = %i", waiter->event_nr);
  
  	if (!(dmt = dm_task_create(DM_DEVICE_WAITEVENT)))
--- 258,274 ----
  	}
  	pthread_mutex_lock (waiter->waiter_lock);
  
! 	event_nr = dm_geteventnr (waiter->mapname);
! 	if (waiter->firstTime) {
! 		waiter->event_nr = event_nr;
! 		waiter->firstTime = 0;
! 	}
! 	else if (waiter->event_nr != event_nr) {
! 		log_safe(LOG_NOTICE, "event_nr = %i, waiter->event_nr = %i:
avoiding 0x%x lost events on map %s", event_nr, waiter->event_nr, event_nr -
waiter->event_nr, waiter->mapname);
! 		waiter->event_nr = event_nr;
! 		goto out2;
! 	}
! 	//waiter->event_nr = dm_geteventnr (waiter->mapname);
  	log_safe(LOG_DEBUG, "waiter->event_nr = %i", waiter->event_nr);
  
  	if (!(dmt = dm_task_create(DM_DEVICE_WAITEVENT)))
***************
*** 274,280 ****
  
  out:
  	dm_task_destroy(dmt);
! 
  	log_safe(LOG_DEBUG, "%s", cmd);
  	log_safe(LOG_NOTICE, "devmap event on %s", waiter->mapname);
  	mark_failed_path(waiter->allpaths, waiter->mapname);
--- 286,292 ----
  
  out:
  	dm_task_destroy(dmt);
! out2:
  	log_safe(LOG_DEBUG, "%s", cmd);
  	log_safe(LOG_NOTICE, "devmap event on %s", waiter->mapname);
  	mark_failed_path(waiter->allpaths, waiter->mapname);
***************
*** 379,384 ****
--- 391,397 ----
  					MALLOC (sizeof (pthread_mutex_t));
  				pthread_mutex_init (wp->waiter_lock, NULL);
  				wp->allpaths = allpaths;
+ 				wp->firstTime = 1;
  				vector_alloc_slot (waiters);
  				vector_set_slot (waiters, wp);
  			}
