From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC][PATCH 2/2] dm: establish queue limits just
	before table resume
Date: Mon, 15 Jun 2009 13:37:46 -0400
Message-ID: <20090615173745.GA19901@redhat.com>
References: <1244935542-18919-1-git-send-email-snitzer@redhat.com>
	<1244935542-18919-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1244935542-18919-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Sat, Jun 13 2009 at  7:25pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Initialization and validation of a DM device's queue_limits is now done
> just before dm_swap_table() discards the previous table.  Doing so
> allows for the limits to be properly calculated (relative to other DM
> tables that may have also been loaded in the same transaction).  This
> eliminates a restriction that was inadvertantly introduced on userspace
> (e.g. LVM2) relative to having to resume devices that a new device was
> dependent on for it's table load.
> 
> The 'limits' (struct queue_limits) member has been removed from both the
> dm_table and dm_target structures (reducing DM's memory consumption).
> 
> The dm-log.c changes highlight the somewhat awkward nature of not having
> queue_limits be a member of 'struct dm_target'.  The same pattern,
> recalculating the target's queue_limits, is also used in various places
> in dm-table.c.
> 
> dm-table.c:dm_set_device_limits now passes the 'start' of the device's
> data area (aka pe_start) as the 'offset' to blk_stack_limits().
> 
> init_valid_queue_limits() was removed in favor of Martin Petersen's
> pending blk_set_default_limits().
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: agk@redhat.com
> Cc: martin.petersen@oracle.com
> ---
>  drivers/md/dm-log.c           |   12 ++
>  drivers/md/dm-table.c         |  188 +++++++++++++++++++++++-------------------
>  drivers/md/dm.c               |   12 ++
>  drivers/md/dm.h               |    4 
>  include/linux/device-mapper.h |    9 --
>  5 files changed, 130 insertions(+), 95 deletions(-)


Alasdair,

I've tested the patches to work as expected _after_ applying the
following small fixup patch.  I'll hold off on sending out updated
"final" patches until share how you think things look.  In the meantime
I'll work on implementing .iterate_devices for all the other targets.

Mike


diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8a9abb5..2b0cb51 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -889,7 +889,6 @@ int dm_set_limits(struct dm_table *table, struct queue_limits *limits)
 
        while (i < dm_table_get_num_targets(table)) {
                struct queue_limits ti_limits;
-               blk_set_default_limits(&ti_limits);
 
                ti = dm_table_get_target(table, i++);
 
@@ -906,8 +905,8 @@ int dm_set_limits(struct dm_table *table, struct queue_limits *limits)
                 * the top-level limits because they are needed
                 * to validate the target's device area
                 */
-               if (ti->type->iterate_devices(ti, device_area_is_valid,
-                                             &ti_limits) != 0)
+               if (!ti->type->iterate_devices(ti, device_area_is_valid,
+                                              &ti_limits))
                        goto out;
 
                /* combine target's limits into table's limits */
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 044f0ba..fa533f3 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -163,7 +163,6 @@ struct dm_target {
        sector_t begin;
        sector_t len;
 
-       /* FIXME: turn this into a mask, and merge with queue_limits */
        /* Always a power of 2 */
        sector_t split_io;
