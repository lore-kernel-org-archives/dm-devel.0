From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] dm path selector: Avoid that device
 removal triggers an infinite loop
Date: Thu, 1 Sep 2016 11:26:42 -0400
Message-ID: <20160901152641.GA65959@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<242bfdfc-1af1-014a-48c6-301598b8ad65@sandisk.com>
	<20160901024931.GA4741@redhat.com>
	<BLUPR02MB1683AC1B30C6E1EAE953C67081E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150642.GB11074@redhat.com>
	<bda2e9d3-69b9-671b-296b-3be7b5bc79cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <bda2e9d3-69b9-671b-296b-3be7b5bc79cf@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 01 2016 at 11:22P -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 09/01/2016 08:06 AM, Mike Snitzer wrote:
> >On Thu, Sep 01 2016 at 10:14am -0400,
> >Bart Van Assche <Bart.VanAssche@sandisk.com> wrote:
> >
> >>On 08/31/16 20:29, Mike Snitzer wrote:
> >>>On Wed, Aug 31 2016 at  6:18pm -0400,
> >>>Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >>>
> >>>>If pg_init_retries is set and a request is queued against a
> >>>>multipath device with all underlying block devices in the "dying"
> >>>>state then an infinite loop is triggered because activate_path()
> >>>>never succeeds and hence never calls pg_init_done(). Fix this by
> >>>>making ql_select_path() skip dying paths.
> >>>
> >>>Assuming DM multipath needs to be sprinkling these dying queue checks so
> >>>deep (which I'm not yet sold on):
> >>>
> >>>Same would be needed in service-time and round-robin right?
> >>
> >>Hello Mike,
> >>
> >>Before addressing service-time and round-robin path selectors I wanted
> >>to make sure that we reach agreement about how to fix the queue length
> >>path selector.
> >>
> >>Do you have a proposal for an alternative approach to fix the infinite
> >>loop that can be triggered during device removal?
> >
> >I'm going to look closer now.  But I'd prefer to see the "dying" state
> >check(s) elevated to DM multipath.  Really would rather the path
> >selectors not have to worry about this state.
> 
> Hello Mike,
> 
> How about making blk_cleanup_queue() invoke a callback function in dm or
> dm-mpath and to use that callback function to keep track of the number of
> paths that are not in the "dying" state? That would allow to detect in the
> dm or dm-mpath driver whether or not all paths are in the dying state
> without having to modify every path selector. This is just an idea - there
> might be better alternatives.

Even that seems like overkill.  What about this?  Any chance you could
try the linux-dm.git 'dm-4.9' branch with this patch ontop?

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ac734e5..15db5e9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1521,10 +1521,10 @@ static void activate_path(struct work_struct *work)
 {
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, activate_path.work);
+	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
 
-	if (pgpath->is_active)
-		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
-				 pg_init_done, pgpath);
+	if (pgpath->is_active && !blk_queue_dying(q))
+		scsi_dh_activate(q, pg_init_done, pgpath);
 	else
 		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
 }
