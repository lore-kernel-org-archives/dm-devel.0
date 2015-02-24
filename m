From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 4/4 v2] dm: delay running the queue slightly
 during request completion
Date: Tue, 24 Feb 2015 12:22:59 -0500
Message-ID: <20150224172259.GA39226@redhat.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54ECAC08.7040603@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: jmoyer@redhat.com, dm-devel@redhat.com, shivakrishna.merla@netapp.com
List-Id: dm-devel.ids

On Tue, Feb 24 2015 at 11:51P -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 02/24/2015 08:44 AM, Mike Snitzer wrote:
> >On really fast storage it can be beneficial to delay running the
> >request_queue to allow the elevator more opportunity to merge requests.
> >
> >Otherwise, it has been observed that requests are being sent to
> >q->request_fn much quicker than is ideal on IOPS-bound backends.
> >
> >Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >---
> >  drivers/md/dm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> >index fc92899..92091e0 100644
> >--- a/drivers/md/dm.c
> >+++ b/drivers/md/dm.c
> >@@ -1034,7 +1034,7 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
> >  	 * queue lock again.
> >  	 */
> >  	if (run_queue)
> >-		blk_run_queue_async(md->queue);
> >+		blk_delay_queue(md->queue, HZ / 10);
> 
> This looks dangerous... How will this impact sync IO? Heuristics like this
> will always come back and bite you in the ass.
> 
> A slightly more friendly heuristic might be to delay running the queue, if
> you still have pending IO. That would give you a more sawtooth like queue
> depth management, so it would potentially slow down a bit, but the upside
> would be more efficient merging since it would allow some requests so sit a
> little bit before being dispatched.

OK, thanks for the suggestion, sending RFC patches FTW:

From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: delay running the queue slightly during request
 completion

On really fast storage it can be beneficial to delay running the
request_queue to allow the elevator more opportunity to merge requests.

Otherwise, it has been observed that requests are being sent to
q->request_fn much quicker than is ideal on IOPS-bound backends.

To avoid impacting sync IO, the delay when running the queue is only
used if there is pending IO.  As Jens put it when suggesting this
heuristic:
 "That would give you a more sawtooth like queue depth management, so it
 would potentially slow down a bit, but the upside would be more
 efficient merging since it would allow some requests to sit a little
 bit before being dispatched."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fc92899..85b8919 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1033,8 +1033,12 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * back into ->request_fn() could deadlock attempting to grab the
 	 * queue lock again.
 	 */
-	if (run_queue)
-		blk_run_queue_async(md->queue);
+	if (run_queue) {
+		if (md->queue->nr_pending)
+			blk_delay_queue(md->queue, HZ / 10);
+		else
+			blk_run_queue_async(md->queue);
+	}
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.9.3 (Apple Git-50)
