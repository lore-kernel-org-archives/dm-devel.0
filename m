From: Mike Snitzer <snitzer@redhat.com>
Subject: dm: disable WRITE SAME if it fails
Date: Mon, 2 Jun 2014 14:36:35 -0400
Message-ID: <20140602183635.GA1396@redhat.com>
References: <53042F91.4050201@huawei.com> <53899812.50403@huawei.com>
	<20140531150517.GJ29705@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140531150517.GJ29705@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex chen <alex.chen@huawei.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <asi@seznam.cz>, Mike Anderson <andmike@linux.vnet.ibm.com>, christophe varoqui <christophe.varoqui@free.fr>, dm-devel@redhat.com, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Joseph Qi <joseph.qi@huawei.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, May 31 2014 at 11:05am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sat, May 31, 2014 at 04:51:30PM +0800, alex chen wrote:
> > The original commit f84cb8a46a771f36a04a02c61ea635c968ed5f6a("dm mpath:
> > disable WRITE SAME if it fails") disables WRITE SAME in the DM multipath
> > device if it fails, but when the DM linear device stacks ontop of the
> > multipath device it doesn't help.
> > this patch adds DM linear end_io method to catch WRITE SAME errors and
> > disables WRITE SAME in the DM linear device's queue_limits if an
> > underlying device disables it.
> 
> How does your patch address striped targets?
>  
> Shouldn't this code be taken out of mpath and moved to dm.c and applied to all
> targets (both bio and rq-based, at least where WRITE SAME is supported)?

Alex,

I've implemented what Alasdair and I have been suggesting.
Can you please test this untested patch?

Thanks,
Mike

---
 drivers/md/dm-mpath.c |   11 +----------
 drivers/md/dm.c       |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index fa0f6cb..9eb6dfd 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1240,17 +1240,8 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (noretry_error(error)) {
-		if ((clone->cmd_flags & REQ_WRITE_SAME) &&
-		    !clone->q->limits.max_write_same_sectors) {
-			struct queue_limits *limits;
-
-			/* device doesn't really support WRITE SAME, disable it */
-			limits = dm_get_queue_limits(dm_table_get_md(m->ti->table));
-			limits->max_write_same_sectors = 0;
-		}
+	if (noretry_error(error))
 		return error;
-	}
 
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 97940fc..c37581c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -755,6 +755,14 @@ static void dec_pending(struct dm_io *io, int error)
 	}
 }
 
+static void disable_write_same(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support WRITE SAME, disable it */
+	limits->max_write_same_sectors = 0;
+}
+
 static void clone_endio(struct bio *bio, int error)
 {
 	int r = 0;
@@ -783,6 +791,10 @@ static void clone_endio(struct bio *bio, int error)
 		}
 	}
 
+	if (r < 0 && (bio->bi_rw & REQ_WRITE_SAME) &&
+	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+		disable_write_same(md);
+
 	free_tio(md, tio);
 	dec_pending(io, error);
 }
@@ -977,6 +989,10 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
+	if (r < 0 && (clone->cmd_flags & REQ_WRITE_SAME) &&
+	    !clone->q->limits.max_write_same_sectors)
+		disable_write_same(tio->md);
+
 	if (r <= 0)
 		/* The target wants to complete the I/O */
 		dm_end_request(clone, r);
