From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Fri, 20 Feb 2009 10:33:47 +0530
Message-ID: <200902201033.48806.knikanth@suse.de>
References: <200902171917.38252.knikanth@suse.de>
	<200902191240.22577.knikanth@suse.de>
	<1235090729.9614.8.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1235090729.9614.8.camel@chandra-ubuntu>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, sekharan@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Friday 20 February 2009 06:15:29 Chandra Seetharaman wrote:
> On Thu, 2009-02-19 at 12:40 +0530, Nikanth Karthikesan wrote:
>
> <snip>
>
> > @@ -431,6 +432,7 @@ static void process_queued_ios(struct work_struct
> > *work) struct pgpath *pgpath =3D NULL;
> >  	unsigned init_required =3D 0, must_queue =3D 1;
> >  	unsigned long flags;
> > +	unsigned long delay =3D 0;
>
> I do not see the reason for this variable, you can as well put the dela=
y
> in pg_init_delay and use it directly (and set it to zero after using
> it) ?
>

I missed resetting pg_init_delay to zero after using it. I have attached =
the
corrected patch with this. This variable keeps the code cleaner(avoids ta=
king
m->lock). Also having only a boolean in struct multipath keeps it a bit
smaller.

off-topic:
I think struct multipath can be shrunk even further by making various fla=
gs
like pg_init_required, pg_init_in_progress, queue_io, queue_if_no_path,
saved_queue_if_no_path in to a single variable. Thoughts?

<snip>

> > @@ -1060,6 +1064,7 @@ static void pg_init_done(struct dm_path *path, =
int
> > errors) struct priority_group *pg =3D pgpath->pg;
> >  	struct multipath *m =3D pg->m;
> >  	unsigned long flags;
> > +	unsigned delay =3D 0;
>
> You can get rid of this variable also and set it directly under
> SCSI_DH_RETRY.
>

pg_init_delay is protected by the m->lock. And this variable helps in kee=
ping
the code cleaner.

<snip>

I am attaching the fixed patch(resetting pg_init_delay to zero after usin=
g
it).

Thanks
Nikanth

SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
immediately and SCSI_DH_RETRY in cases where it is better to retry
after some delay.

Currently we retry immediately irrespective of SCSI_DH_IMM_RETRY and
SCSI_DH_RETRY.  This patch adds a 2 second delay before retrying to
activate a device, if it returns SCSI_DH_RETRY.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..7ddf775 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -65,12 +65,13 @@ struct multipath {
 	spinlock_t lock;
=20
 	const char *hw_handler_name;
-	struct work_struct activate_path;
+	struct delayed_work activate_path;
 	struct pgpath *pgpath_to_activate;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
+	unsigned pg_init_delay;		/* delay required before retry? */
=20
 	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
@@ -203,7 +204,7 @@ static struct multipath *alloc_multipath(struct dm_ta=
rget *ti)
 		m->queue_io =3D 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
-		INIT_WORK(&m->activate_path, activate_path);
+		INIT_DELAYED_WORK(&m->activate_path, activate_path);
 		m->mpio_pool =3D mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -431,6 +432,7 @@ static void process_queued_ios(struct work_struct *wo=
rk)
 	struct pgpath *pgpath =3D NULL;
 	unsigned init_required =3D 0, must_queue =3D 1;
 	unsigned long flags;
+	unsigned long delay =3D 0;
=20
 	spin_lock_irqsave(&m->lock, flags);
=20
@@ -452,13 +454,17 @@ static void process_queued_ios(struct work_struct *=
work)
 		m->pg_init_required =3D 0;
 		m->pg_init_in_progress =3D 1;
 		init_required =3D 1;
+		if (m->pg_init_delay) {
+			delay =3D SCSI_DH_RETRY_DELAY;
+			m->pg_init_delay =3D 0;
+		}
 	}
=20
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
=20
 	if (init_required)
-		queue_work(kmpath_handlerd, &m->activate_path);
+		queue_delayed_work(kmpath_handlerd, &m->activate_path, delay);
=20
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -1060,6 +1066,7 @@ static void pg_init_done(struct dm_path *path, int =
errors)
 	struct priority_group *pg =3D pgpath->pg;
 	struct multipath *m =3D pg->m;
 	unsigned long flags;
+	unsigned delay =3D 0;
=20
 	/* device or driver problems */
 	switch (errors) {
@@ -1084,8 +1091,11 @@ static void pg_init_done(struct dm_path *path, int=
 errors)
 		 */
 		bypass_pg(m, pg, 1);
 		break;
-	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
+	/*
+	 * For SCSI_DH_RETRY we wait before retrying.
+	 */
 	case SCSI_DH_RETRY:
+		delay =3D 1;
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
 		if (pg_init_limit_reached(m, pgpath))
@@ -1112,6 +1122,7 @@ static void pg_init_done(struct dm_path *path, int =
errors)
 	}
=20
 	m->pg_init_in_progress =3D 0;
+	m->pg_init_delay =3D delay;
 	queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
@@ -1120,7 +1131,7 @@ static void activate_path(struct work_struct *work)
 {
 	int ret;
 	struct multipath *m =3D
-		container_of(work, struct multipath, activate_path);
+		container_of(work, struct multipath, activate_path.work);
 	struct dm_path *path;
 	unsigned long flags;
=20
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 33efce2..f099d86 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -55,6 +55,10 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
+
+/* Time to wait before retry in case of SCSI_DH_RETRY */
+#define SCSI_DH_RETRY_DELAY ((HZ * 2))
+
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
=00
