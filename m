From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] dm-mpath: kmalloc+memset -> kzalloc
Date: Wed, 9 Aug 2006 17:17:46 +0200
Message-ID: <20060809151746.GA31694@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Use kzalloc() instead of kmalloc() + memset().

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

diff -urN linux-2.6.17.8-routes-esfq-mq/drivers/md/dm-mpath.c linux-fixes=
/drivers/md/dm-mpath.c
--- linux-2.6.17.8-routes-esfq-mq/drivers/md/dm-mpath.c	2006-08-07 15:25:=
07.000000000 +0200
+++ linux-fixes/drivers/md/dm-mpath.c	2006-08-09 17:05:48.000000000 +0200
@@ -113,12 +113,10 @@
=20
 static struct pgpath *alloc_pgpath(void)
 {
-	struct pgpath *pgpath =3D kmalloc(sizeof(*pgpath), GFP_KERNEL);
+	struct pgpath *pgpath =3D kzalloc(sizeof(*pgpath), GFP_KERNEL);
=20
-	if (pgpath) {
-		memset(pgpath, 0, sizeof(*pgpath));
+	if (pgpath)
 		pgpath->path.is_active =3D 1;
-	}
=20
 	return pgpath;
 }
@@ -132,12 +130,10 @@
 {
 	struct priority_group *pg;
=20
-	pg =3D kmalloc(sizeof(*pg), GFP_KERNEL);
-	if (!pg)
-		return NULL;
+	pg =3D kzalloc(sizeof(*pg), GFP_KERNEL);
=20
-	memset(pg, 0, sizeof(*pg));
-	INIT_LIST_HEAD(&pg->pgpaths);
+	if (pg)
+		INIT_LIST_HEAD(&pg->pgpaths);
=20
 	return pg;
 }
@@ -171,9 +167,8 @@
 {
 	struct multipath *m;
=20
-	m =3D kmalloc(sizeof(*m), GFP_KERNEL);
+	m =3D kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
-		memset(m, 0, sizeof(*m));
 		INIT_LIST_HEAD(&m->priority_groups);
 		spin_lock_init(&m->lock);
 		m->queue_io =3D 1;
