From: "goggin, edward" <egoggin@emc.com>
Subject: panic in dm_pg_init_complete+0x10 (2nd post)
Date: Tue, 8 Mar 2005 21:15:16 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A809@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
List-Id: dm-devel.ids

Adding the patch contents this time for the panic in
dm_pg_init_complete+0x10.
The patch is based on linux-2.6.11-rc3-udm2.

*** drivers/md/dm-mpath.c.orig	2005-03-07 16:55:50.000000000 -0500
--- drivers/md/dm-mpath.c	2005-03-08 05:36:55.000000000 -0500
***************
*** 63,68 ****
--- 63,70 ----
  	unsigned nr_priority_groups;
  	struct list_head priority_groups;
  	unsigned pg_init_required;	/* pg_init needs calling? */
+ 	unsigned pg_init_in_progress;	/* only 1 outstanding */
+ 	wait_queue_head_t pg_init_wait;
  
  	unsigned nr_valid_paths;	/* Total number of usable paths */
  	struct pgpath *current_pgpath;
***************
*** 177,182 ****
--- 179,185 ----
  		m->queue_io = 1;
  		INIT_WORK(&m->process_queued_ios, process_queued_ios, m);
  		INIT_WORK(&m->trigger_event, trigger_event, m);
+ 		init_waitqueue_head(&m->pg_init_wait);
  		m->mpio_pool = mempool_create(MIN_IOS, mempool_alloc_slab,
  					      mempool_free_slab,
_mpio_cache);
  		if (!m->mpio_pool) {
***************
*** 394,406 ****
  		must_queue = 1;
  
  	init_required = m->pg_init_required;
! 	if (init_required)
  		m->pg_init_required = 0;
! 
! 	spin_unlock_irqrestore(&m->lock, flags);
! 
! 	if (init_required)
! 		hwh->type->pg_init(hwh, pgpath->pg->bypassed,
&pgpath->path);
  
  	if (!must_queue)
  		dispatch_queued_ios(m);
--- 397,414 ----
  		must_queue = 1;
  
  	init_required = m->pg_init_required;
! 	if (init_required) {
  		m->pg_init_required = 0;
! 		if (!m->pg_init_in_progress) {
! 			m->pg_init_in_progress = 1;
! 			spin_unlock_irqrestore(&m->lock, flags);
! 			hwh->type->pg_init(hwh, pgpath->pg->bypassed,
&pgpath->path);
! 		}
! 		else
! 			spin_unlock_irqrestore(&m->lock, flags);
! 	}
! 	else
! 		spin_unlock_irqrestore(&m->lock, flags);
  
  	if (!must_queue)
  		dispatch_queued_ios(m);
***************
*** 751,756 ****
--- 759,779 ----
  static void multipath_dtr(struct dm_target *ti)
  {
  	struct multipath *m = (struct multipath *) ti->private;
+ 	DECLARE_WAITQUEUE(wait, current);
+ 	unsigned long flags;
+ 
+ 	 // Wait for any outstanding pg_init request to complete.
+ 	spin_lock_irqsave(&m->lock, flags);
+ 	add_wait_queue(&m->pg_init_wait, &wait);
+ 	while (m->pg_init_in_progress) {
+ 		spin_unlock_irqrestore(&m->lock, flags);
+ 		io_schedule();
+ 		spin_lock_irqsave(&m->lock, flags);
+ 	}
+ 	spin_unlock_irqrestore(&m->lock, flags);
+ 	set_current_state(TASK_RUNNING);
+ 	remove_wait_queue(&m->pg_init_wait, &wait);
+ 
  	free_multipath(m);
  }
  
***************
*** 968,973 ****
--- 991,998 ----
  		m->current_pgpath = NULL;
  		m->current_pg = NULL;
  	}
+ 	m->pg_init_in_progress = 0;
+ 	wake_up(&m->pg_init_wait);
  	schedule_work(&m->process_queued_ios);
  	spin_unlock_irqrestore(&m->lock, flags);
  }
