From: "goggin, edward" <egoggin@emc.com>
Subject: RE: panic in dm_pg_init_complete+0x10
Date: Tue, 15 Mar 2005 20:04:34 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A82B@SRMANNING.eng.emc.com>
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
To: 'Alasdair G Kergon' <agk@redhat.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thursday, Mar 010, 2005 at 17:29 UTC, Kergon, Alasdair wrote:
> > Looks to me like two issues here -- (1) probably should not allow
> > concurrent pg_init i/os for the same multipath and 
> 
> Some statements that the code should be checked against.
> 
> Only one pg_init can happen at once.
>   - enforced by pg_init_required only getting set to 1 in one place,
>     then set to 0 when the init is issued.

Yes.  I misread this code.  I agree it is solid.

>   - BUG? it looks possible for __switch_pg to get called 
>     while there's still a pg_init outstanding.
>

Yes, during recent testing I trapped a __switch_pg() while a previously
initiated pg_init request was still outstanding.  Not clear how to fix
this scenario -- (1) fail subsequent pg_inits if one is outstanding,
(2) serialize the pg_inits in __switch_pg(), or (3) allow multiple
pg_inits to be outstanding.  The patch I sent before was an attempt
at (3).  Overall, I think option (2) is best, but this would likely
require blocking and releasing the multipath spin lock in __switch_pg()
and having to revalidate the multipath state already acquired in map_io().
The included patch does __NOT__ include a fix for this problem.
 
> Suspend cannot complete until there is no I/O outstanding, including
> any pg_init I/O.
>   - queueing is disabled while suspended
>   - the last I/O through cannot complete with an error until the last 
>     path has failed, which can't happen until the pg_init for its PG
>     has completed.
>

I disagree with your last assertion.  I think there are two other
use cases besides the __switch_pg() case described above whereby
a pg_init i/o can be left outstanding after its multipath structure's
memory is freed.  I have definitely caught the first case below with
traps.  I forget whether I've actually seen the 2nd case though :((

First, the most common case -- it is possible for an uncompleted PG
switch to be pending with no i/os queued to the multipath
when a dev_suspend initiated i/o suspension followed by table swap
occurs.  process_queued_ios() when called by multipath_presuspend(),
will initiate a pg_init even though there are no queued user i/os.
Because there are no i/os queued, the suspend will not block
waiting for the pg_init to complete.  If the dm_table_put() call
on the old table frees the multipath structure memory before the
pg_init i/o completes (likely case), the problem occurs.  This case
can be prevented simply by having process_queued_ios() not initiate
a pg_init i/o if there are no queued i/os pended on the multipath
structure.  The included patch includes this fix.

Second, a somewhat less common case -- a pg_init i/o is outstanding when
a dev_suspend() call is made on a multipath for which the kernel thinks
it currently has no valid paths.  I think the sequence of events for the
use case is as enumerated below.   I think this case can be prevented
by not calling dispatch_queued_ios() if there is a oustanding pg_init.
This state is detected by the conditional logic 

	(m->queue_io && !m->pg_init_required)

In this case, any queued i/os will be dispatched only after the
outstanding pg_init i/o completes via the call to process_queued_io()
from dm_pg_init_complete().  dm_pg_init_complete() must also be
changed to reset the queue_io flag if the suspended flag is set
even in the case of an error on the pg_init i/o, otherwise the
i/os would never be dispatched in the "all-paths-down" use case.
The included patch includes this fix.

(1)	pg_init i/o is sent and causes queuing of one or more user i/os
(2)	all paths are detected as failed in kernel
(3)	multipath reloads new table causing via dev_suspend() ioctl causing
	i/o suspend followed by table swap
	(a)	pre-suspend causes even the last i/o to fail on
		the last path -- even before the pg_init for its
		PG has completed

> multipath_dtr can only be called when there is no I/O in-flight
>   - dm_swap_table checks the device is suspended before 
> calling __unbind
>   - BUG? dm_put only calls pre/post suspend but fails to wait 
> for I/O to clear

----------------------------------PATCH -------------------------------
*** drivers/md/dm-mpath.c.orig	2005-03-15 06:19:06.000000000 -0500
--- drivers/md/dm-mpath.c.patched	2005-03-15 14:34:36.000000000 -0500
***************
*** 374,385 ****
  	}
  }
  
  static void process_queued_ios(void *data)
  {
  	struct multipath *m = (struct multipath *) data;
  	struct hw_handler *hwh = &m->hw_handler;
  	struct pgpath *pgpath;
! 	unsigned init_required, must_queue = 0;
  	unsigned long flags;
  
  	spin_lock_irqsave(&m->lock, flags);
--- 374,387 ----
  	}
  }
  
+ #define	PG_INIT_OUTSTANDING(qio, init_required)	(qio &&
!init_required)
+ 
  static void process_queued_ios(void *data)
  {
  	struct multipath *m = (struct multipath *) data;
  	struct hw_handler *hwh = &m->hw_handler;
  	struct pgpath *pgpath;
! 	unsigned init_required, must_queue = 0, qio;
  	unsigned long flags;
  
  	spin_lock_irqsave(&m->lock, flags);
***************
*** 389,394 ****
--- 391,398 ----
  
  	pgpath = m->current_pgpath;
  
+ 	qio = m->queue_io;
+ 
  	if ((pgpath && m->queue_io) ||
  	    (!pgpath && m->queue_if_no_path && !m->suspended))
  		must_queue = 1;
***************
*** 397,408 ****
  	if (init_required)
  		m->pg_init_required = 0;
  
! 	spin_unlock_irqrestore(&m->lock, flags);
! 
! 	if (init_required)
! 		hwh->type->pg_init(hwh, pgpath->pg->bypassed,
&pgpath->path);
  
! 	if (!must_queue)
  		dispatch_queued_ios(m);
  }
  
--- 401,425 ----
  	if (init_required)
  		m->pg_init_required = 0;
  
! 	if (init_required) {
! 		// only send pg_init if there are queued i/os, otherwise the
! 		// pg_init i/o is not accounted for during i/o suspension
! 		if (m->queue_size == 0) {
! 			spin_unlock_irqrestore(&m->lock, flags);
! 			hwh->type->pg_init(hwh, pgpath->pg->bypassed,
! 					   &pgpath->path);
! 			init_required = 0;
! 		}
! 		else {
! 			m->pg_init_required = 1;
! 			spin_unlock_irqrestore(&m->lock, flags);
! 		}
! 	}
! 	else
! 		spin_unlock_irqrestore(&m->lock, flags);
  
! 	// must not dispatch i/os if there is a pg_init outstanding
! 	if (!must_queue && !PG_INIT_OUTSTANDING(qio, init_required))
  		dispatch_queued_ios(m);
  }
  
***************
*** 751,756 ****
--- 768,775 ----
  static void multipath_dtr(struct dm_target *ti)
  {
  	struct multipath *m = (struct multipath *) ti->private;
+ 
+ 	flush_scheduled_work();
  	free_multipath(m);
  }
  
***************
*** 965,970 ****
--- 984,992 ----
  	if (!err_flags)
  		m->queue_io = 0;
  	else {
+ 		// reset queue_io in order to dispatch queued i/os if
suspended
+ 		if (m->suspended)
+ 			m->queue_io = 0;
  		m->current_pgpath = NULL;
  		m->current_pg = NULL;
  	}
***************
*** 986,992 ****
  
  	spin_lock(&m->lock);
  	if (!m->nr_valid_paths) {
! 		if (!m->queue_if_no_path) {
  			spin_unlock(&m->lock);
  			return -EIO;
  		} else {
--- 1008,1014 ----
  
  	spin_lock(&m->lock);
  	if (!m->nr_valid_paths) {
! 		if (!m->queue_if_no_path || m->suspended) {
  			spin_unlock(&m->lock);
  			return -EIO;
  		} else {
