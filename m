From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] dm-mpath.c trigger_event race
Date: Tue, 14 Jun 2005 11:13:19 +0200
Message-ID: <20050614091319.GF25295@marowsky-bree.de>
References: <20050613172851.GH17296@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050613172851.GH17296@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2005-06-13T19:28:51, Lars Marowsky-Bree <lmb@suse.de> wrote:

> Hi Alasdair, Ed, List,
>=20
> this patch addresses the bug Ed pointed out. The trigger_event queue
> might still hold a reference while dm_destroy kills the current mapping=
.
>=20
> However, this patch is unconvincing in the larger view of things. Yes,
> barring bugs, it should address the problem, but the real issue is -
> just like with still having pg_inits in-flight - that DM's reference
> counting isn't taking into account what we are doing internally, and
> that remains unsolved.
>=20
> Comments?

Second (public) revision. The wait_on_work() was no good. While it
considerably reduced the window for the race, it didn't entirely close
it (the flag is cleared prior to actually calling the handler).

The comment still remains: The layering in DM is sub-optimal, if not
wrong. I tried exporting dm_(inc|dec)_pending(struct mapped_device *md)
from dm.c, so as to be able to influence the reference counter for the
dm device when queuing / completing an internal event, but this is a
mess. Deep inside dm-mpath, I don't have a reference to that struct at
all.

This is actually the same problem which makes sane _logging_ in dm-mpath
a nightmare: No references to the name of the DM dev etc. This all
sucks(tm).

However, I needed a fix reasonably soon (as in, right now ;-) which is
somewhat easier to verify then revamping the full DM layering. Comments
on this approach are appreciated.

And yes, I know that the "looping" in free_multipath() sucks. See above
for the reason: It's easier to verify then the full answer.

A flush_workqueue(kmultipathd) is too large a hammer - given that other
tables might still be busy queuing events, re-queuing IO etc, that could
potentially block for much longer periods of time.

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Panic in dm-mpath.c:trigger_event()
References: 88635

If a dm mpath table was destroyed while events were still pending to be
delivered, the code could panic in trigger_event() trying to dereference
free'd memory.


Index: linux-2.6.5/drivers/md/dm-mpath.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.5.orig/drivers/md/dm-mpath.c	2005-06-13 18:14:58.555830390 =
+0200
+++ linux-2.6.5/drivers/md/dm-mpath.c	2005-06-14 10:57:44.879248517 +0200
@@ -80,6 +80,8 @@ struct multipath {
 	unsigned queue_size;
=20
 	struct work_struct trigger_event;
+	atomic_t trigger_event_pending; /* Reference count whether any trigger_=
event
+					   is outstanding */
=20
 	/*
 	 * We must use a mempool of mpath_io structs so that we
@@ -179,6 +180,7 @@ static struct multipath *alloc_multipath
 		m->queue_io =3D 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios, m);
 		INIT_WORK(&m->trigger_event, trigger_event, m);
+		atomic_set(&m->trigger_event_pending, 0);
 		m->mpio_pool =3D mempool_create(MIN_IOS, mempool_alloc_slab,
 					      mempool_free_slab, _mpio_cache);
 		if (!m->mpio_pool) {
@@ -195,6 +197,14 @@ static void free_multipath(struct multip
 	struct priority_group *pg, *tmp;
 	struct hw_handler *hwh =3D &m->hw_handler;
=20
+	/* TODO - Yes, I know:
+	 * It would be better if in fact pending trigger_events
+	 * were accounted for in the struct mapped_device * we belong
+	 * to. However, that is not exported to us, and that fix will
+	 * require slightly more rearchitecting then this bit. */
+	while (atomic_read(&m->trigger_event_pending))
+		schedule();
+=09
 	list_for_each_entry_safe (pg, tmp, &m->priority_groups, list) {
 		list_del(&pg->list);
 		free_priority_group(pg, m->ti);
@@ -421,6 +431,16 @@ static void trigger_event(void *data)
 	struct multipath *m =3D (struct multipath *) data;
=20
 	dm_table_event(m->ti->table);
+
+	spin_lock(&m->lock);
+	atomic_set(&m->trigger_event_pending, 0);
+	spin_unlock(&m->lock);
+}
+
+static void inline queue_trigger_event(struct multipath *m)
+{
+	atomic_set(&m->trigger_event_pending, 1);
+	queue_work(kmultipathd, &m->trigger_event);
 }
=20
 /*-----------------------------------------------------------------
@@ -818,7 +838,8 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath =3D=3D m->current_pgpath)
 		m->current_pgpath =3D NULL;
=20
-	queue_work(kmultipathd, &m->trigger_event);
+=09
+	queue_trigger_event(m);
=20
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -857,7 +878,7 @@ static int reinstate_path(struct pgpath=20
 	if (!m->nr_valid_paths++)
 		queue_work(kmultipathd, &m->process_queued_ios);
=20
-	queue_work(kmultipathd, &m->trigger_event);
+	queue_trigger_event(m);
=20
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -900,9 +921,10 @@ static void bypass_pg(struct multipath *
 	m->current_pgpath =3D NULL;
 	m->current_pg =3D NULL;
=20
+	queue_trigger_event(m);
+
 	spin_unlock_irqrestore(&m->lock, flags);
=20
-	queue_work(kmultipathd, &m->trigger_event);
 }
=20
 /*
@@ -930,9 +952,9 @@ static int switch_pg_num(struct multipat
 		m->current_pg =3D NULL;
 		m->next_pg =3D pg;
 	}
+	queue_trigger_event(m);
 	spin_unlock_irqrestore(&m->lock, flags);
=20
-	queue_work(kmultipathd, &m->trigger_event);
 	return 0;
 }
=20

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
