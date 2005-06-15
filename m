From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [patch] dm-mpath pg_init could race with destructor
Date: Wed, 15 Jun 2005 09:19:46 +0200
Message-ID: <20050615071946.GA765@marowsky-bree.de>
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

This patch addresses a race found by Ed.

From his description:

(1) This use case involves a call to switch_pg_num() before an io
suspend.  The path group switch is delayed.  When multipath_presuspend()
is called as part of the io suspend, the call to queue_work(kmultipathd,
&m->process_queued_ios) from multipath_presuspend() can cause a pg_init
io to be sent even if there are no other ios involved.

Why send a pg_init request at this point if there are no queued ios?
This was in fact my solution, to only send a pg_init io if there are
queued ios.

(2) This use case involves already having a pg_init io outstanding (and
one or more queued ios) at the time an io suspend occurs.  Assume
further that (1) all paths are down to the device and (2) the device's
multipath configuration includes the "queue_if_no_path" feature.  The
call to queue_work(kmultipathd, &m->process_queued_ios) will lead to
process_queued_ios() dispatching any/all queued ios -- even though the
pg_init request is still outstanding for the device.  If all of these
ios complete before the pg_init io completes, it is possible that the
multipath destructor is called as part of either swapping the device's
old map or closing the mapped device.

A (3) safety check was added by myself: No point in issueing a pg_init
if we don't have a valid path. Where would we sent it to? This shouldn't
occur, because __switch_pg() (which is the only place which can set
m->pg_init_required) is only called if we do have a valid path. However,
could user-space with bad timing intervene and fail that path before we
have run pg_init - in which case pg_init_required would still be 1, but,
we don't have a valid path -> the dereferencing pgpath might not be
smart.

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: dm-mpath calling pg_init could race with destructor
References: 88654

Need to make sure no pg_init is in-flight before the destructor is
called.

Index: linux-2.6.5/drivers/md/dm-mpath.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.5.orig/drivers/md/dm-mpath.c	2005-06-14 21:36:12.514021267 =
+0200
+++ linux-2.6.5/drivers/md/dm-mpath.c	2005-06-15 09:07:57.556654693 +0200
@@ -388,6 +388,7 @@ static void process_queued_ios(void *dat
 	struct pgpath *pgpath;
 	unsigned init_required, must_queue =3D 0;
 	unsigned long flags;
+	unsigned queue_size;
=20
 	spin_lock_irqsave(&m->lock, flags);
=20
@@ -400,15 +401,30 @@ static void process_queued_ios(void *dat
 	    (!pgpath && m->queue_if_no_path && !m->suspended))
 		must_queue =3D 1;
=20
-	if (m->pg_init_required && !m->pg_init_in_progress) {
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
 		m->pg_init_required =3D 0;
 		m->pg_init_in_progress =3D 1;
 		init_required =3D 1;
 	} else
 		init_required =3D 0;
+
+	if (m->pg_init_in_progress)
+		must_queue =3D 1;
+
+	/* No point in doing anything if we don't have any queued IO.
+	 * This also closes a race: As our internal pg_init is not
+	 * accounted for in the DM pending count, we need to make sure
+	 * we only issue it if we know the pending > 0, or else
+	 * the destructor might be called and dm_pg_init_complete()
+	 * might panic.
+	 */
+	queue_size =3D m->queue_size;
 =09
 	spin_unlock_irqrestore(&m->lock, flags);
=20
+	if (queue_size =3D=3D 0)
+		return;
+
 	if (init_required)
 		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
=20

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
