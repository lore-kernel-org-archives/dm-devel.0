From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/7] request-based dm-multipath (v2)
Date: Fri, 24 Apr 2009 17:10:49 +0900
Message-ID: <49F17409.4060201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: Alasdair Kergon <agk@redhat.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

This patch-set is the updated version of request-based dm-multipath
for 2.6.30-rc3.
This patch-set doesn't have barrier support yet.  Barrier support
for request-based dm will be posted as separate patches in the future.

The patch-set has some cosmetic dependencies on the previously posted
dynamic load balancer patches:
    http://marc.info/?l=dm-devel&m=124056031408258&w=2
but no functional dependency on them.  (Actually, dynamic load
balancers rely on this patch-set for effectiveness.)

Some basic function/performance testings are done with NEC iStorage
(active-active multipath), and no problem was found.
Also heavy stress testing with a lot of path up/down and table
switching is done to check panic, stall and memory leak don't occur.
Please review and apply if no problem.


Summary of the patch-set
========================
  1/7: dm core: add core functions for request-based dm
  2/7: dm core: add integrity feature to request-based dm
  3/7: dm core: enable request-based dm
  4/7: dm core: don't set QUEUE_ORDERED_DRAIN for request-based dm
  5/7: dm core: reject I/O violating new queue limits
  6/7: dm core: disable interrupt when taking map_lock
  7/7: dm-mpath: convert to request-based

 drivers/md/dm-ioctl.c         |   13 
 drivers/md/dm-mpath.c         |  193 +++++---
 drivers/md/dm-table.c         |  127 +++++
 drivers/md/dm.c               |  978 ++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.h               |   22 
 include/linux/device-mapper.h |   10 
 6 files changed, 1242 insertions(+), 101 deletions(-)


CHANGES
=======
v2:
  - Rebased to 2.6.30-rc3

  - Fixed memory leak when bio_integrity_clone() fails (PATCH 2)
      * Added missing bio_free() when bio_integrity_clone() fails.

  - Added a patch not to set QUEUE_ORDERED_DRAIN for request-based dm
    (PATCH 4)
      * This version of request-based dm doesn't have barrier support
        yet.  So set QUEUE_ORDERED_DRAIN only for bio-based dm.
        Since the device type is decided at the first table binding
        time, the flag set is deferred until then.


v1: (http://marc.info/?l=dm-devel&m=123736590931733&w=2)
  - Rebased to 2.6.29-rc8

  - Fixed oops on table swapping because of broken suspend (PATCH 1)
    http://marc.info/?l=dm-devel&m=123667308218868&w=2
      * dm_suspend() recognized that suspend completed while some
        clones were still in flight.  So swapping/freeing table
        was possible against the in-use table, and it caused oops
      * The problem was a race condition on in-flight checking:
        new I/O could become in-flight while suspend code found
        no I/O was in-flight and went on
      * Fixed it by protecting the in-flight counting and queue
        suspension with queue lock.  Also using q->in_flight
        instead of md->pending since it is straightforward to
        understand the meaning of the in-flight clones

  - Fixed NULL pointer reference when allocation for clone bio fails
    (From Hannes Reinecke) (PATCH 1)
    http://marc.info/?l=dm-devel&m=123666946315335&w=2
      * free_bio_clone() used clone->end_io_data to get md
      * But clone->end_io_data can be NULL when free_bio_clone()
        is called from error handling path in clone_request_bios()
      * Fixed it by passing md directly to free_bio_clone()
      * Removed the work around code to check bio->bi_private:
        http://marc.info/?l=dm-devel&m=123666946315335&w=2

  - Fixed unnecessary -EIO on table swapping by removing
    the map-existence check in dm_make_request() (PATCH 1)
    http://marc.info/?l=dm-devel&m=123322573410050&w=2
      * The check was there to reject BIOs until a table is loaded
        and the device and the queue are initialized correctly
      * But the check is not needed because BIOs are rejected
        in __generic_make_request() by device size checking
        until the device and the queue are initialized

  - Fixed freeing of in-use md (PATCH 1)
      * Upper layer can close the device just after all BIOs are
        completed by blk_update_request() or blk_end_request(),
        even if the request is still in the process of completion.
        It creates a small window where dm_put() can free the md
        which is needed for the process of completion
      * Fixed it by incrementing md->holders while I/O is in-flight

  - Fixed memory leak (missing unmap) on failure of dispatching
    a mapped clone (PATCH 1)
      * dm_kill_request() was used in dm_dispatch_request() when
        the dispatching fails
      * But dm_kill_requst() is for not-mapped clone, so target's
        rq_end_io() function is not called. This caused memory leak.
      * Fixed it by creating dm_complete_request() for mapped clone
        and calling it in dm_dispatch_request()

  - Changed exported function names to prevent misuse like above
    (PATCH 1, PATCH 3, PATCH 5)
      * dm_kill_request()    => dm_kill_unmapped_request()
      * dm_requeue_request() => dm_requeue_unmapped_request()

  - Removed the REQ_QUIET flag in dm_kill_unmapped_request(), since
    "I/O error" message is not printed for failed I/O (PATCH 1)

  - Removed 'inline' for simple static functions, since compiler
    will do inline anyway (PATCH 1)

  - Removed if-request-based check in dm_prep_fn(), since the device
    is always request-based when dm_prep_fn() is called (PATCH 1)
      * The check was for the case where the table is switched from
        request-based to bio-based.  But currently no plan to support
        such switching

  - Fixed the problem that switching device type is unexpectedly
    available on table swapping (PATCH 2)
      * table_load() checks md->map for the current table type
        to prevent the device type switching
      * But table_load() can run in parallel with dm_swap_table(),
        which has a small no-map window.
        So dm_init_md_mempool() in table_load() could switch
        the mempool type for an in-use device in this window
      * Fixed it by placing the pre-allocated mempools in table
        and binding them on resume.  The resume is rejected if
        the device is in-use with different type

  - Fixed the problem that BIO is submitted to a request-based device
    in which some settings may not be done yet (PATCH 2)
      * The QUEUE_FLAG_STACKABLE flag was set in the middle of
        dm_table_set_restrictions()
      * But the flag needs to be set after all queue settings are
        done and they become visible to other CPUs, because:
          o BIOs can be submitted during dm_table_set_restrictions()
          o Once the QUEUE_FLAG_STACKABLE flag is set in the queue,
            BIOs are passed to request-based dm and eventually to
            __make_request() where the queue settings are used
      * Fixed it by re-ordering the flag set and putting a barrier
        before the flag set.

  - Fixed lockdep warnings (From Christof Schmitt) (PATCH 4)
    http://marc.info/?l=dm-devel&m=123501258326935&w=2
      * lockdep warns some self-deadlock possibilities since:
          o map_lock is taken without disabling irq
          o request-based dm takes map_lock after taking
            queue_lock with disabling irq in dm_request_fn()
          o so logically a deadlock may happen:
              write_lock(map_lock)
              <interrupt>
              spin_lock_irqsave(queue_lock)
              dm_request_fn()
                  => dm_get_table()
                      => read_lock(map_lock)
      * dm_request_fn() is never called in interrupt context, so
        such self-deadlocks don't happen actually
      * But fixed the unneeded warnings by disabling irq when
        taking map_lock


Summary of the design and request-based dm-multipath are below.
(No changes since the previous post.)

BACKGROUND
==========
Currently, device-mapper (dm) is implemented as a stacking block device
at bio level.  This bio-based implementation has an issue below
on dm-multipath.

  Because hook for I/O mapping is above block layer __make_request(),
  contiguous bios can be mapped to different underlying devices
  and these bios aren't merged into a request.
  Dynamic load balancing could happen this situation, though
  it has not been implemented yet.
  Therefore, I/O mapping after bio merging is needed for better
  dynamic load balancing.

The basic idea to resolve the issue is to move multipathing layer
down below the I/O scheduler, and it was proposed from Mike Christie
as the block layer (request-based) multipath:
  http://marc.info/?l=linux-scsi&m=115520444515914&w=2

Mike's patch added new block layer device for multipath and didn't
have dm interface.  So I modified his patch to be used from dm.
It is request-based dm-multipath.


DESIGN OVERVIEW
===============
While currently dm and md stacks block devices at bio level,
request-based dm stacks at request level and submits/completes
struct request instead of struct bio.


Overview of the request-based dm patch:
  - Mapping is done in a unit of struct request, instead of struct bio
  - Hook for I/O mapping is at q->request_fn() after merging and
    sorting by I/O scheduler, instead of q->make_request_fn().
  - Hook for I/O completion is at bio->bi_end_io() and rq->end_io(),
    instead of only bio->bi_end_io()
                  bio-based (current)     request-based (this patch)
      ------------------------------------------------------------------
      submission  q->make_request_fn()    q->request_fn()
      completion  bio->bi_end_io()        bio->bi_end_io(), rq->end_io()
  - Whether the dm device is bio-based or request-based is determined
    at table loading time
  - Keep user interface same (table/message/status/ioctl)
  - Any bio-based devices (like dm/md) can be stacked on request-based
    dm device.
    Request-based dm device *cannot* be stacked on any bio-based device.


Expected benefit:
  - better load balancing


Additional explanations:

Why does request-based dm use bio->bi_end_io(), too?
Because:
  - dm needs to keep not only the request but also bios of the request,
    if dm target drivers want to retry or do something on the request.
    For example, dm-multipath has to check errors and retry with other
    paths if necessary before returning the I/O result to the upper layer.

  - But rq->end_io() is called at the very late stage of completion
    handling where all bios in the request have been completed and
    the I/O results are already visible to the upper layer.
So request-based dm hooks bio->bi_end_io() and doesn't complete the bio
in error cases, and gives over the error handling to rq->end_io() hook.


Thanks,
Kiyoshi Ueda
