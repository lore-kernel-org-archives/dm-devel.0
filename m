From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [patch] dm-mpath.c trigger_event race
Date: Mon, 13 Jun 2005 19:28:51 +0200
Message-ID: <20050613172851.GH17296@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair, Ed, List,

this patch addresses the bug Ed pointed out. The trigger_event queue
might still hold a reference while dm_destroy kills the current mapping.

However, this patch is unconvincing in the larger view of things. Yes,
barring bugs, it should address the problem, but the real issue is -
just like with still having pg_inits in-flight - that DM's reference
counting isn't taking into account what we are doing internally, and
that remains unsolved.

Comments?


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
+++ linux-2.6.5/drivers/md/dm-mpath.c	2005-06-13 19:23:17.521458595 +0200
@@ -74,6 +74,7 @@ struct multipath {
 	unsigned queue_io;		/* Must we queue all I/O? */
 	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
 	unsigned suspended;		/* Has dm core suspended our I/O? */
+	unsigned dieing;		/* Whether we're busy cleaning up */
=20
 	struct work_struct process_queued_ios;
 	struct bio_list queued_ios;
@@ -195,6 +196,12 @@ static void free_multipath(struct multip
 	struct priority_group *pg, *tmp;
 	struct hw_handler *hwh =3D &m->hw_handler;
=20
+	/* Make sure events have been delivered first */
+	spin_lock(&m->lock);
+	m->dieing =3D 1;=20
+	spin_unlock(&m->lock);
+	wait_on_work(&m->trigger_event);
+=09
 	list_for_each_entry_safe (pg, tmp, &m->priority_groups, list) {
 		list_del(&pg->list);
 		free_priority_group(pg, m->ti);
@@ -818,7 +825,8 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath =3D=3D m->current_pgpath)
 		m->current_pgpath =3D NULL;
=20
-	queue_work(kmultipathd, &m->trigger_event);
+	if (!m->dieing)
+		queue_work(kmultipathd, &m->trigger_event);
=20
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -857,7 +865,8 @@ static int reinstate_path(struct pgpath=20
 	if (!m->nr_valid_paths++)
 		queue_work(kmultipathd, &m->process_queued_ios);
=20
-	queue_work(kmultipathd, &m->trigger_event);
+	if (!m->dieing)
+		queue_work(kmultipathd, &m->trigger_event);
=20
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -900,9 +909,10 @@ static void bypass_pg(struct multipath *
 	m->current_pgpath =3D NULL;
 	m->current_pg =3D NULL;
=20
-	spin_unlock_irqrestore(&m->lock, flags);
+	if (!m->dieing)
+		queue_work(kmultipathd, &m->trigger_event);
=20
-	queue_work(kmultipathd, &m->trigger_event);
+	spin_unlock_irqrestore(&m->lock, flags);
 }
=20
 /*
@@ -930,9 +940,11 @@ static int switch_pg_num(struct multipat
 		m->current_pg =3D NULL;
 		m->next_pg =3D pg;
 	}
+	if (!m->dieing)
+		queue_work(kmultipathd, &m->trigger_event);
+
 	spin_unlock_irqrestore(&m->lock, flags);
=20
-	queue_work(kmultipathd, &m->trigger_event);
 	return 0;
 }
=20
Index: linux-2.6.5/include/linux/workqueue.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.5.orig/include/linux/workqueue.h	2005-06-13 18:15:04.838897=
616 +0200
+++ linux-2.6.5/include/linux/workqueue.h	2005-06-13 19:21:38.925094100 +=
0200
@@ -78,6 +78,12 @@ static inline int cancel_delayed_work(st
 	return del_timer_sync(&work->timer);
 }
=20
+static inline void wait_on_work(struct work_struct *work)
+{
+	while (test_bit(0, &work->pending))
+		schedule();
+}
+
 extern void dump_clear_workqueue(void);
 extern void dump_run_workqueue(void);



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
