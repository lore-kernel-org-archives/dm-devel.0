From: Hannes Reinecke <hare@suse.de>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 10:06:14 +0200
Message-ID: <52453C76.6060403@suse.de>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com> <524520B0.6010003@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010802070009000005020402"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <524520B0.6010003@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010802070009000005020402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id r8R86ZAj026896

On 09/27/2013 08:07 AM, Hannes Reinecke wrote:
> On 09/27/2013 01:49 AM, Mike Snitzer wrote:
>> On Thu, Sep 26 2013 at  7:22pm -0400,
>> Alasdair G Kergon <agk@redhat.com> wrote:
>>
>>> On Thu, Sep 26, 2013 at 10:47:13AM -0700, Frank Mayhar wrote:
>>>> Launching it from ramdisk won't help, particularly, since it still g=
oes
>>>> through the block layer.  The other stuff won't help if a (potential=
ly
>>>> unrelated) bug in the daemon happens to be being tickled at the same
>>>> time, or if some dependency happens to be broken and _that's_ what's
>>>> preventing the daemon from making progress.
>>> =20
>>> Then put more effort into debugging your daemon so it doesn't have
>>> bugs that make it die?  Implement the timeout in a robust independent
>>> daemon if it's other code there that's unreliable?
>>>
>>>> And as far as lvm2 and multipath-tools, yeah, they cope okay in the =
kind
>>>> of environments most people have, but that's not the kind of environ=
ment
>>>> (or scale) we have to deal with.
>>>
>>> In what way are your requirements so different that a locked-into-mem=
ory
>>> monitoring daemon cannot implement this timeout?
>>
>> Frank, I had a look at your patch.  It leaves a lot to be desired, I w=
as
>> starting to clean it up but ultimately found myself agreeing with
>> Alasdair's original point: that this policy should be implemented in t=
he
>> userspace daemon.
>>
> _Actually_ there is a way how this could be implemented properly:
> implement a blk_timeout function.
>=20
> Thing is, every request_queue might have a timeout function
> implemented, whose goal is to abort requests which are beyond that
> timeout. EG SCSI uses that for the dev_loss_tmo mechanism.
>=20
> Multipath what with it being request-based could easily implement
> the same mechanism, namely have to blk_timeout function which would
> just re-arm the timeout in the default case, but abort any queued
> I/O (after a timeout) if all paths are down.
>=20
> Hmm. I see to draft up a PoC.
>=20
And indeed, here it is.

Completely untested, just to give you an idea what I was going on
about. Let's see if I can put this to test somewhere...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------010802070009000005020402
Content-Type: text/x-patch;
 name="dm-mpath-no-path-timeout.patch"
Content-Disposition: attachment;
 filename="dm-mpath-no-path-timeout.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5adede1..6801ac3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -444,6 +444,61 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 	return 0;
 }
 
+/*
+ * Block timeout callback, called from the block layer
+ *
+ * request_queue lock is held on entry.
+ *
+ * Return values:
+ * BLK_EH_RESET_TIMER if the request should be left running
+ * BLK_EH_NOT_HANDLED if the request is handled or terminated
+ *                    by the driver.
+ */
+enum blk_eh_timer_return abort_if_no_path(struct request *req)
+{
+	union map_info *info;
+	struct dm_mpath_io *mpio;
+	struct multipath *m;
+	unsigned long flags;
+	int rc = BLK_EH_RESET_TIMER;
+	int flush_ios = 0;
+
+	info = dm_get_rq_mapinfo(req);
+	if (!info || !info->ptr)
+		return BLK_EH_NOT_HANDLED;
+
+	mpio = info->ptr;
+	m = mpio->pgpath->pg->m;
+	/*
+	 * Only abort request if:
+	 * - queued_ios is not empty
+	 *   (protect against races with process_queued_ios)
+	 * - queue_io is not set
+	 * - no valid paths are found
+	 */
+	spin_lock_irqsave(&m->lock, flags);
+	if (!list_empty(&m->queued_ios) &&
+	    !m->queue_io &&
+	    !m->nr_valid_paths) {
+		list_del_init(&req->queuelist);
+		m->queue_size--;
+		m->queue_if_no_path = 0;
+		if (m->queue_size)
+			flush_ios = 1;
+		rc = BLK_EH_NOT_HANDLED;
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	if (rc == BLK_EH_NOT_HANDLED) {
+		mempool_free(mpio, m->mpio_pool);
+		dm_kill_unmapped_request(clone, -ETIMEOUT);
+	}
+	if (flush_ios)
+		queue_work(kmultipathd, &m->process_queue_ios);
+
+	return rc;
+}
+
 /*-----------------------------------------------------------------
  * The multipath daemon is responsible for resubmitting queued ios.
  *---------------------------------------------------------------*/
@@ -790,6 +845,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
+		{0, 65535, "no_path_timeout must be between 0 and 65535"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -827,6 +883,13 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "no_path_timeout") &&
+		    (argc >= 1)) {
+			r = dm_read_arg(_args + 3, as, &m->no_path_timeout, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -905,6 +968,12 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 		goto bad;
 	}
 
+	if (m->no_path_timeout)
+		dm_set_queue_timeout(ti, abort_if_no_path,
+				     m->no_path_timeout * HZ);
+	else
+		dm_set_queue_timeout(ti, NULL, 0)
+
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e39d2b..26bfad6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1881,6 +1881,16 @@ static void dm_init_md_queue(struct mapped_device *md)
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 }
 
+static void dm_set_md_timeout(struct mapped_device *md,
+			      rq_timed_out_fn *fn, unsigned int timeout)
+{
+	if (dm_get_md_type(md) != DM_TYPE_REQUEST_BASED)
+		return;
+
+	blk_queue_rq_timed_out(md->queue, fn);
+	blk_queue_rq_timeout(md->queue, timeout);
+}
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -2790,6 +2800,13 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
+int dm_set_queue_timeout(struct dm_target *ti, rq_timed_out_fn *fn,
+			 unsigned int timeout)
+{
+	return dm_set_md_timeout(dm_table_get_md(ti->table), fn, timeout);
+}
+EXPORT_SYMBOL_GPL(dm_set_queue_timeout);
+
 struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_bio_data_size)
 {
 	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 45b97da..c8df1ef 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -80,6 +80,8 @@ void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
+void dm_set_queue_timeout(struct dm_table *t, rq_timed_out_fn *fn,
+			  unsigned int timeout);
 
 int dm_setup_md_queue(struct mapped_device *md);
 

--------------010802070009000005020402
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------010802070009000005020402--
