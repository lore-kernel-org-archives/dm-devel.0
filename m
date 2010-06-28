From: "Narendran Ganapathy" <Narendran_Ganapathy@Dell.com>
Subject: [PATCH 1/1] dm-mpath: Extend path selector interface for
	supporting Dell EqualLogic path selector
Date: Mon, 28 Jun 2010 09:53:20 -0400
Message-ID: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1135036683079930704=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
Cc: Parind Shah <Parind_Shah@Dell.com>, Jason Shamberger <Jason_Shamberger@Dell.com>, agk@redhat.com, Narendran Ganapathy <Narendran_Ganapathy@Dell.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1135036683079930704==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CB16C9.4477EEA8"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CB16C9.4477EEA8
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

This patch extends the dm-path-selector interface to allow path =
selectors to use extra information from the IO request when selecting a =
path.

Dell EqualLogic and other iSCSI storage arrays use a distributed =
frameless architecture.  In this architecture, the storage group =
consists of a number of distinct storage arrays ("members"), each having =
independent controllers, disk storage and network adapters.  When a LUN =
is created it is spread across multiple members.  The details of the =
distribution are hidden from initiators connected to this storage =
system.  The storage group exposes a single target discovery portal, no =
matter how many members are being used.  When iSCSI sessions are =
created, each session is connected to an eth port on a single member.  =
Data to a LUN can be sent on any iSCSI session, and if the blocks being =
accessed are stored on another member the IO will be forwarded as =
required.  This forwarding is invisible to the initiator.  The storage =
layout is also dynamic, and the blocks stored on disk may be moved from =
member to member as needed to balance the load.

This architecture simplifies the management and configuration of both =
the storage group and initiators.  In a multipathing configuration, it =
is possible to set up multiple iSCSI sessions to use multiple network =
interfaces on both the host and target to take advantage of the =
increased network bandwidth.  An initiator can use a simple round robin =
algorithm to send IO on all paths and let the storage array members =
forward it as necessary.  However, there is a performance advantage to =
sending data directly to the correct member.  At the same time, the =
existing techniques of building a separate priority group for paths to =
each controller does not fit this model, because the block ranges may be =
moved at any time from member to member, and it is also acceptable to =
send IO to any member in the group when no direct path exists or there =
is a path error.

We propose to develop a new path selector to perform this location-based =
routing.  The basic idea is to use knowledge about the current location =
of data to prefer paths directly to the owning member, but fall back to =
use any available path when no direct path is available.  This =
submission includes the necessary changes to the dm-path-selector =
interface.  In the current interface, the only information passed to the =
select_path routine is the path_selector struct and the number of bytes =
in the request.  To do location based routing, we need the address =
information of the request.

We propose to extend the path selector interface to pass the entire =
request pointer to the 'select_path' / 'start_io' /  'end_io' functions =
so that the path selector can use any information therein to route the =
I/O.

We also propose extending the dm_mpath_io structure used to hold =
information about each I/O to include extra fields for the path selector =
to store I/O specific flags and a timestamp, so the path selector can =
determine the latency of I/Os on different paths and that information is =
passed to the 'select_path' / 'start_io' /  'end_io' functions for path =
selector usage. These additions to the dm_mpath_io allow future =
flexibility in developing algorithms that route IO based on other =
information from the request in the future.


Signed-off-by: Narendran Ganapathy <Narendran_Ganapathy@dell.com>
Signed-off-by: Jason Shamberger <Jason_Shamberger@dell.com>
---
 drivers/md/dm-mpath.c         |   37 =
+++++++++++++++++--------------------
 drivers/md/dm-mpath.h         |   20 ++++++++++++++++++++
 drivers/md/dm-path-selector.h |    7 ++++---
 drivers/md/dm-queue-length.c  |    8 +++++---
 drivers/md/dm-round-robin.c   |    4 +++-
 drivers/md/dm-service-time.c  |   11 ++++++++---
 6 files changed, 57 insertions(+), 30 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 826bce7..cc45a99 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -98,14 +98,6 @@ struct multipath {
 	struct mutex work_mutex;
 };
=20
-/*
- * Context information attached to each bio we process.
- */
-struct dm_mpath_io {
-	struct pgpath *pgpath;
-	size_t nr_bytes;
-};
-
 typedef int (*action_fn) (struct pgpath *pgpath);
=20
 #define MIN_IOS 256	/* Mempool size */
@@ -267,11 +259,13 @@ static void __switch_pg(struct multipath *m, =
struct pgpath *pgpath)
 }
=20
 static int __choose_path_in_pg(struct multipath *m, struct =
priority_group *pg,
-			       size_t nr_bytes)
+				union dm_mpath_ps_io *psio,
+				struct request *clone)
 {
 	struct dm_path *path;
=20
-	path =3D pg->ps.type->select_path(&pg->ps, &m->repeat_count, =
nr_bytes);
+	path =3D pg->ps.type->select_path(&pg->ps, &m->repeat_count, psio,
+					clone);
 	if (!path)
 		return -ENXIO;
=20
@@ -283,7 +277,8 @@ static int __choose_path_in_pg(struct multipath *m, =
struct priority_group *pg,
 	return 0;
 }
=20
-static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
+static void __choose_pgpath(struct multipath *m, union dm_mpath_ps_io =
*psio,
+				struct request *clone)
 {
 	struct priority_group *pg;
 	unsigned bypassed =3D 1;
@@ -295,12 +290,13 @@ static void __choose_pgpath(struct multipath *m, =
size_t nr_bytes)
 	if (m->next_pg) {
 		pg =3D m->next_pg;
 		m->next_pg =3D NULL;
-		if (!__choose_path_in_pg(m, pg, nr_bytes))
+		if (!__choose_path_in_pg(m, pg, psio, clone))
 			return;
 	}
=20
 	/* Don't change PG until it has no remaining paths */
-	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, nr_bytes))
+	if (m->current_pg &&
+		!__choose_path_in_pg(m, m->current_pg, psio, clone))
 		return;
=20
 	/*
@@ -312,7 +308,7 @@ static void __choose_pgpath(struct multipath *m, =
size_t nr_bytes)
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed =3D=3D bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg, nr_bytes))
+			if (!__choose_path_in_pg(m, pg, psio, clone))
 				return;
 		}
 	} while (bypassed--);
@@ -350,10 +346,12 @@ static int map_io(struct multipath *m, struct =
request *clone,
=20
 	spin_lock_irqsave(&m->lock, flags);
=20
+	mpio->u.nr_bytes =3D nr_bytes;
+
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count =3D=3D 0)))
-		__choose_pgpath(m, nr_bytes);
+		__choose_pgpath(m, &mpio->u, clone);
=20
 	pgpath =3D m->current_pgpath;
=20
@@ -380,11 +378,10 @@ static int map_io(struct multipath *m, struct =
request *clone,
 		r =3D -EIO;	/* Failed */
=20
 	mpio->pgpath =3D pgpath;
-	mpio->nr_bytes =3D nr_bytes;
=20
 	if (r =3D=3D DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path,
-					      nr_bytes);
+					      &mpio->u, clone);
=20
 	spin_unlock_irqrestore(&m->lock, flags);
=20
@@ -464,7 +461,7 @@ static void process_queued_ios(struct work_struct =
*work)
 		goto out;
=20
 	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
+		__choose_pgpath(m, NULL, NULL);
=20
 	pgpath =3D m->current_pgpath;
=20
@@ -1295,7 +1292,7 @@ static int multipath_end_io(struct dm_target *ti, =
struct request *clone,
 	if (pgpath) {
 		ps =3D &pgpath->pg->ps;
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, &mpio->u, clone);
 	}
 	mempool_free(mpio, m->mpio_pool);
=20
@@ -1533,7 +1530,7 @@ static int multipath_ioctl(struct dm_target *ti, =
unsigned int cmd,
 	spin_lock_irqsave(&m->lock, flags);
=20
 	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
+		__choose_pgpath(m, NULL, NULL);
=20
 	if (m->current_pgpath) {
 		bdev =3D m->current_pgpath->path.dev->bdev;
diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index e230f71..45e9c58 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -16,6 +16,26 @@ struct dm_path {
 	void *pscontext;	/* For path-selector use */
 };
=20
+
+/*
+ * Context information attached to each bio we process.
+ */
+struct dm_ps_io_ctx {
+	uint32_t flags;
+	unsigned long iotime;
+};
+
+union dm_mpath_ps_io {
+	size_t nr_bytes;
+	struct dm_ps_io_ctx ps_ctx;
+};
+
+struct dm_mpath_io {
+	struct pgpath *pgpath;
+	union dm_mpath_ps_io u;
+};
+
+
 /* Callback for hwh_pg_init_fn to use when complete */
 void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
=20
diff --git a/drivers/md/dm-path-selector.h =
b/drivers/md/dm-path-selector.h
index e7d1fa8..cff8ca5 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -57,7 +57,8 @@ struct path_selector_type {
 	 */
 	struct dm_path *(*select_path) (struct path_selector *ps,
 					unsigned *repeat_count,
-					size_t nr_bytes);
+					union dm_mpath_ps_io *psio,
+					struct request *clone);
=20
 	/*
 	 * Notify the selector that a path has failed.
@@ -77,9 +78,9 @@ struct path_selector_type {
 		       status_type_t type, char *result, unsigned int maxlen);
=20
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
-			 size_t nr_bytes);
+			 union dm_mpath_ps_io *psio, struct request *clone);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+			 union dm_mpath_ps_io *psio, struct request *clone);
 };
=20
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index f92b6ce..f4d9b47 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -168,7 +168,9 @@ static int ql_reinstate_path(struct path_selector =
*ps, struct dm_path *path)
  * Select a path having the minimum number of in-flight I/Os
  */
 static struct dm_path *ql_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+					unsigned *repeat_count,
+					union dm_mpath_ps_io *psio,
+					struct request *clone)
 {
 	struct selector *s =3D ps->context;
 	struct path_info *pi =3D NULL, *best =3D NULL;
@@ -197,7 +199,7 @@ static struct dm_path *ql_select_path(struct =
path_selector *ps,
 }
=20
 static int ql_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       union dm_mpath_ps_io *psio, struct request *clone)
 {
 	struct path_info *pi =3D path->pscontext;
=20
@@ -207,7 +209,7 @@ static int ql_start_io(struct path_selector *ps, =
struct dm_path *path,
 }
=20
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     union dm_mpath_ps_io *psio, struct request *clone)
 {
 	struct path_info *pi =3D path->pscontext;
=20
diff --git a/drivers/md/dm-round-robin.c b/drivers/md/dm-round-robin.c
index 24752f4..ecbde5f 100644
--- a/drivers/md/dm-round-robin.c
+++ b/drivers/md/dm-round-robin.c
@@ -161,7 +161,9 @@ static int rr_reinstate_path(struct path_selector =
*ps, struct dm_path *p)
 }
=20
 static struct dm_path *rr_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+					unsigned *repeat_count,
+					union dm_mpath_ps_io *psio,
+					struct request *clone)
 {
 	struct selector *s =3D (struct selector *) ps->context;
 	struct path_info *pi =3D NULL;
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index 9c6c2e4..83f7534 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -254,10 +254,13 @@ static int st_compare_load(struct path_info *pi1, =
struct path_info *pi2,
 }
=20
 static struct dm_path *st_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+					unsigned *repeat_count,
+					union dm_mpath_ps_io *psio,
+					struct request *clone)
 {
 	struct selector *s =3D ps->context;
 	struct path_info *pi =3D NULL, *best =3D NULL;
+	size_t nr_bytes =3D psio ? psio->nr_bytes : 0 ;
=20
 	if (list_empty(&s->valid_paths))
 		return NULL;
@@ -278,9 +281,10 @@ static struct dm_path *st_select_path(struct =
path_selector *ps,
 }
=20
 static int st_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       union dm_mpath_ps_io *psio, struct request *clone)
 {
 	struct path_info *pi =3D path->pscontext;
+	size_t nr_bytes =3D psio ? psio->nr_bytes : 0 ;
=20
 	atomic_add(nr_bytes, &pi->in_flight_size);
=20
@@ -288,9 +292,10 @@ static int st_start_io(struct path_selector *ps, =
struct dm_path *path,
 }
=20
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		       union dm_mpath_ps_io *psio, struct request *clone)
 {
 	struct path_info *pi =3D path->pscontext;
+	size_t nr_bytes =3D psio ? psio->nr_bytes : 0 ;
=20
 	atomic_sub(nr_bytes, &pi->in_flight_size);
=20
--=20
1.6.5.2


------_=_NextPart_001_01CB16C9.4477EEA8
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7654.12">
<TITLE>[PATCH 1/1] dm-mpath: Extend path selector interface for =
supporting Dell EqualLogic path selector</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>This patch extends the dm-path-selector interface to =
allow path selectors to use extra information from the IO request when =
selecting a path.<BR>
<BR>
Dell EqualLogic and other iSCSI storage arrays use a distributed =
frameless architecture.&nbsp; In this architecture, the storage group =
consists of a number of distinct storage arrays (&quot;members&quot;), =
each having independent controllers, disk storage and network =
adapters.&nbsp; When a LUN is created it is spread across multiple =
members.&nbsp; The details of the distribution are hidden from =
initiators connected to this storage system.&nbsp; The storage group =
exposes a single target discovery portal, no matter how many members are =
being used.&nbsp; When iSCSI sessions are created, each session is =
connected to an eth port on a single member.&nbsp; Data to a LUN can be =
sent on any iSCSI session, and if the blocks being accessed are stored =
on another member the IO will be forwarded as required.&nbsp; This =
forwarding is invisible to the initiator.&nbsp; The storage layout is =
also dynamic, and the blocks stored on disk may be moved from member to =
member as needed to balance the load.<BR>
<BR>
This architecture simplifies the management and configuration of both =
the storage group and initiators.&nbsp; In a multipathing configuration, =
it is possible to set up multiple iSCSI sessions to use multiple network =
interfaces on both the host and target to take advantage of the =
increased network bandwidth.&nbsp; An initiator can use a simple round =
robin algorithm to send IO on all paths and let the storage array =
members forward it as necessary.&nbsp; However, there is a performance =
advantage to sending data directly to the correct member.&nbsp; At the =
same time, the existing techniques of building a separate priority group =
for paths to each controller does not fit this model, because the block =
ranges may be moved at any time from member to member, and it is also =
acceptable to send IO to any member in the group when no direct path =
exists or there is a path error.<BR>
<BR>
We propose to develop a new path selector to perform this location-based =
routing.&nbsp; The basic idea is to use knowledge about the current =
location of data to prefer paths directly to the owning member, but fall =
back to use any available path when no direct path is available.&nbsp; =
This submission includes the necessary changes to the dm-path-selector =
interface.&nbsp; In the current interface, the only information passed =
to the select_path routine is the path_selector struct and the number of =
bytes in the request.&nbsp; To do location based routing, we need the =
address information of the request.<BR>
<BR>
We propose to extend the path selector interface to pass the entire =
request pointer to the 'select_path' / 'start_io' /&nbsp; 'end_io' =
functions so that the path selector can use any information therein to =
route the I/O.<BR>
<BR>
We also propose extending the dm_mpath_io structure used to hold =
information about each I/O to include extra fields for the path selector =
to store I/O specific flags and a timestamp, so the path selector can =
determine the latency of I/Os on different paths and that information is =
passed to the 'select_path' / 'start_io' /&nbsp; 'end_io' functions for =
path selector usage. These additions to the dm_mpath_io allow future =
flexibility in developing algorithms that route IO based on other =
information from the request in the future.<BR>
<BR>
<BR>
Signed-off-by: Narendran Ganapathy =
&lt;Narendran_Ganapathy@dell.com&gt;<BR>
Signed-off-by: Jason Shamberger &lt;Jason_Shamberger@dell.com&gt;<BR>
---<BR>
&nbsp;drivers/md/dm-mpath.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; |&nbsp;&nbsp; 37 +++++++++++++++++--------------------<BR>
&nbsp;drivers/md/dm-mpath.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; |&nbsp;&nbsp; 20 ++++++++++++++++++++<BR>
&nbsp;drivers/md/dm-path-selector.h |&nbsp;&nbsp;&nbsp; 7 ++++---<BR>
&nbsp;drivers/md/dm-queue-length.c&nbsp; |&nbsp;&nbsp;&nbsp; 8 =
+++++---<BR>
&nbsp;drivers/md/dm-round-robin.c&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; 4 =
+++-<BR>
&nbsp;drivers/md/dm-service-time.c&nbsp; |&nbsp;&nbsp; 11 =
++++++++---<BR>
&nbsp;6 files changed, 57 insertions(+), 30 deletions(-)<BR>
<BR>
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c<BR>
index 826bce7..cc45a99 100644<BR>
--- a/drivers/md/dm-mpath.c<BR>
+++ b/drivers/md/dm-mpath.c<BR>
@@ -98,14 +98,6 @@ struct multipath {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mutex work_mutex;<BR>
&nbsp;};<BR>
<BR>
-/*<BR>
- * Context information attached to each bio we process.<BR>
- */<BR>
-struct dm_mpath_io {<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pgpath *pgpath;<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes;<BR>
-};<BR>
-<BR>
&nbsp;typedef int (*action_fn) (struct pgpath *pgpath);<BR>
<BR>
&nbsp;#define MIN_IOS 256&nbsp;&nbsp;&nbsp; /* Mempool size */<BR>
@@ -267,11 +259,13 @@ static void __switch_pg(struct multipath *m, =
struct pgpath *pgpath)<BR>
&nbsp;}<BR>
<BR>
&nbsp;static int __choose_path_in_pg(struct multipath *m, struct =
priority_group *pg,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dm_path *path;<BR>
<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path =3D =
pg-&gt;ps.type-&gt;select_path(&amp;pg-&gt;ps, &amp;m-&gt;repeat_count, =
nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path =3D =
pg-&gt;ps.type-&gt;select_path(&amp;pg-&gt;ps, &amp;m-&gt;repeat_count, =
psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; clone);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!path)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -ENXIO;<BR>
<BR>
@@ -283,7 +277,8 @@ static int __choose_path_in_pg(struct multipath *m, =
struct priority_group *pg,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;}<BR>
<BR>
-static void __choose_pgpath(struct multipath *m, size_t nr_bytes)<BR>
+static void __choose_pgpath(struct multipath *m, union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct priority_group =
*pg;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned bypassed =3D 1;<BR>
@@ -295,12 +290,13 @@ static void __choose_pgpath(struct multipath *m, =
size_t nr_bytes)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (m-&gt;next_pg) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pg =3D m-&gt;next_pg;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; m-&gt;next_pg =3D NULL;<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!__choose_path_in_pg(m, =
pg, nr_bytes))<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!__choose_path_in_pg(m, =
pg, psio, clone))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Don't change PG until it =
has no remaining paths */<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (m-&gt;current_pg &amp;&amp; =
!__choose_path_in_pg(m, m-&gt;current_pg, nr_bytes))<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (m-&gt;current_pg =
&amp;&amp;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; !__choose_path_in_pg(m, =
m-&gt;current_pg, psio, clone))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
@@ -312,7 +308,7 @@ static void __choose_pgpath(struct multipath *m, =
size_t nr_bytes)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_for_each_entry(pg, =
&amp;m-&gt;priority_groups, list) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pg-&gt;bypassed =3D=3D =
bypassed)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!__choose_path_in_pg(m, =
pg, nr_bytes))<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!__choose_path_in_pg(m, =
pg, psio, clone))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } while (bypassed--);<BR>
@@ -350,10 +346,12 @@ static int map_io(struct multipath *m, struct =
request *clone,<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;m-&gt;lock, flags);<BR>
<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpio-&gt;u.nr_bytes =3D =
nr_bytes;<BR>
+<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Do we need to select a new =
pgpath? */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!m-&gt;current_pgpath =
||<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
(!m-&gt;queue_io &amp;&amp; (m-&gt;repeat_count &amp;&amp; =
--m-&gt;repeat_count =3D=3D 0)))<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, =
nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, =
&amp;mpio-&gt;u, clone);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pgpath =3D =
m-&gt;current_pgpath;<BR>
<BR>
@@ -380,11 +378,10 @@ static int map_io(struct multipath *m, struct =
request *clone,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
-EIO;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Failed */<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpio-&gt;pgpath =3D =
pgpath;<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpio-&gt;nr_bytes =3D =
nr_bytes;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r =3D=3D =
DM_MAPIO_REMAPPED &amp;&amp; pgpath-&gt;pg-&gt;ps.type-&gt;start_io)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pgpath-&gt;pg-&gt;ps.type-&gt;start_io(&amp;pgpath-&gt;pg-&gt;ps, =
&amp;pgpath-&gt;path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;mpio-&gt;u, clone);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;m-&gt;lock, flags);<BR>
<BR>
@@ -464,7 +461,7 @@ static void process_queued_ios(struct work_struct =
*work)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto out;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(!m-&gt;current_pgpath)<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, 0);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, NULL, =
NULL);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pgpath =3D =
m-&gt;current_pgpath;<BR>
<BR>
@@ -1295,7 +1292,7 @@ static int multipath_end_io(struct dm_target *ti, =
struct request *clone,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pgpath) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ps =3D =
&amp;pgpath-&gt;pg-&gt;ps;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(ps-&gt;type-&gt;end_io)<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ps-&gt;type-&gt;end_io(ps, =
&amp;pgpath-&gt;path, mpio-&gt;nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ps-&gt;type-&gt;end_io(ps, =
&amp;pgpath-&gt;path, &amp;mpio-&gt;u, clone);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mempool_free(mpio, =
m-&gt;mpio_pool);<BR>
<BR>
@@ -1533,7 +1530,7 @@ static int multipath_ioctl(struct dm_target *ti, =
unsigned int cmd,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;m-&gt;lock, flags);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(!m-&gt;current_pgpath)<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, 0);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __choose_pgpath(m, NULL, =
NULL);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (m-&gt;current_pgpath) =
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bdev =3D =
m-&gt;current_pgpath-&gt;path.dev-&gt;bdev;<BR>
diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h<BR>
index e230f71..45e9c58 100644<BR>
--- a/drivers/md/dm-mpath.h<BR>
+++ b/drivers/md/dm-mpath.h<BR>
@@ -16,6 +16,26 @@ struct dm_path {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; void =
*pscontext;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* For =
path-selector use */<BR>
&nbsp;};<BR>
<BR>
+<BR>
+/*<BR>
+ * Context information attached to each bio we process.<BR>
+ */<BR>
+struct dm_ps_io_ctx {<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t flags;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long iotime;<BR>
+};<BR>
+<BR>
+union dm_mpath_ps_io {<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dm_ps_io_ctx ps_ctx;<BR>
+};<BR>
+<BR>
+struct dm_mpath_io {<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pgpath *pgpath;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io u;<BR>
+};<BR>
+<BR>
+<BR>
&nbsp;/* Callback for hwh_pg_init_fn to use when complete */<BR>
&nbsp;void dm_pg_init_complete(struct dm_path *path, unsigned =
err_flags);<BR>
<BR>
diff --git a/drivers/md/dm-path-selector.h =
b/drivers/md/dm-path-selector.h<BR>
index e7d1fa8..cff8ca5 100644<BR>
--- a/drivers/md/dm-path-selector.h<BR>
+++ b/drivers/md/dm-path-selector.h<BR>
@@ -57,7 +57,8 @@ struct path_selector_type {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dm_path =
*(*select_path) (struct path_selector *ps,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Notify the selector =
that a path has failed.<BR>
@@ -77,9 +78,9 @@ struct path_selector_type {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status_type_t type, char *result, =
unsigned int maxlen);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int (*start_io) (struct =
path_selector *ps, struct dm_path *path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio, struct request *clone);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int (*end_io) (struct =
path_selector *ps, struct dm_path *path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes);<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio, struct request *clone);<BR>
&nbsp;};<BR>
<BR>
&nbsp;/* Register a path selector */<BR>
diff --git a/drivers/md/dm-queue-length.c =
b/drivers/md/dm-queue-length.c<BR>
index f92b6ce..f4d9b47 100644<BR>
--- a/drivers/md/dm-queue-length.c<BR>
+++ b/drivers/md/dm-queue-length.c<BR>
@@ -168,7 +168,9 @@ static int ql_reinstate_path(struct path_selector =
*ps, struct dm_path *path)<BR>
&nbsp; * Select a path having the minimum number of in-flight I/Os<BR>
&nbsp; */<BR>
&nbsp;static struct dm_path *ql_select_path(struct path_selector =
*ps,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count, size_t =
nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct selector *s =3D =
ps-&gt;context;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
NULL, *best =3D NULL;<BR>
@@ -197,7 +199,7 @@ static struct dm_path *ql_select_path(struct =
path_selector *ps,<BR>
&nbsp;}<BR>
<BR>
&nbsp;static int ql_start_io(struct path_selector *ps, struct dm_path =
*path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io *psio, struct =
request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
path-&gt;pscontext;<BR>
<BR>
@@ -207,7 +209,7 @@ static int ql_start_io(struct path_selector *ps, =
struct dm_path *path,<BR>
&nbsp;}<BR>
<BR>
&nbsp;static int ql_end_io(struct path_selector *ps, struct dm_path =
*path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; =
size_t nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; =
union dm_mpath_ps_io *psio, struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
path-&gt;pscontext;<BR>
<BR>
diff --git a/drivers/md/dm-round-robin.c =
b/drivers/md/dm-round-robin.c<BR>
index 24752f4..ecbde5f 100644<BR>
--- a/drivers/md/dm-round-robin.c<BR>
+++ b/drivers/md/dm-round-robin.c<BR>
@@ -161,7 +161,9 @@ static int rr_reinstate_path(struct path_selector =
*ps, struct dm_path *p)<BR>
&nbsp;}<BR>
<BR>
&nbsp;static struct dm_path *rr_select_path(struct path_selector =
*ps,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count, size_t =
nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct selector *s =3D =
(struct selector *) ps-&gt;context;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
NULL;<BR>
diff --git a/drivers/md/dm-service-time.c =
b/drivers/md/dm-service-time.c<BR>
index 9c6c2e4..83f7534 100644<BR>
--- a/drivers/md/dm-service-time.c<BR>
+++ b/drivers/md/dm-service-time.c<BR>
@@ -254,10 +254,13 @@ static int st_compare_load(struct path_info *pi1, =
struct path_info *pi2,<BR>
&nbsp;}<BR>
<BR>
&nbsp;static struct dm_path *st_select_path(struct path_selector =
*ps,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count, size_t =
nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned *repeat_count,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io =
*psio,<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct selector *s =3D =
ps-&gt;context;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
NULL, *best =3D NULL;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes =3D psio ? =
psio-&gt;nr_bytes : 0 ;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(list_empty(&amp;s-&gt;valid_paths))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<BR>
@@ -278,9 +281,10 @@ static struct dm_path *st_select_path(struct =
path_selector *ps,<BR>
&nbsp;}<BR>
<BR>
&nbsp;static int st_start_io(struct path_selector *ps, struct dm_path =
*path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io *psio, struct =
request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
path-&gt;pscontext;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes =3D psio ? =
psio-&gt;nr_bytes : 0 ;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; atomic_add(nr_bytes, =
&amp;pi-&gt;in_flight_size);<BR>
<BR>
@@ -288,9 +292,10 @@ static int st_start_io(struct path_selector *ps, =
struct dm_path *path,<BR>
&nbsp;}<BR>
<BR>
&nbsp;static int st_end_io(struct path_selector *ps, struct dm_path =
*path,<BR>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; =
size_t nr_bytes)<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union dm_mpath_ps_io *psio, struct =
request *clone)<BR>
&nbsp;{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct path_info *pi =3D =
path-&gt;pscontext;<BR>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t nr_bytes =3D psio ? =
psio-&gt;nr_bytes : 0 ;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; atomic_sub(nr_bytes, =
&amp;pi-&gt;in_flight_size);<BR>
<BR>
--<BR>
1.6.5.2<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01CB16C9.4477EEA8--


--===============1135036683079930704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1135036683079930704==--
