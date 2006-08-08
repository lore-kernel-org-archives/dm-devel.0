From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] multipath_ctr() and friends - parameter cleanup
Date: Tue, 8 Aug 2006 13:46:50 +0200
Message-ID: <20060808114650.GA9486@rere.qmqm.pl>
References: <20060808113227.GA26434@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060808113227.GA26434@rere.qmqm.pl>
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

After initialising m->ti, there's no need to pass it in subsequent calls
to static functions used for parsing parameters.

This patch depends on "BUG/OOPS fix" patch.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

diff -urN linux-2.6.17.8-routes-esfq/drivers/md/dm-mpath.c linux-2.6.17.8=
-routes-esfq-mq/drivers/md/dm-mpath.c
--- linux-2.6.17.8-routes-esfq/drivers/md/dm-mpath.c	2006-07-05 18:29:10.=
000000000 +0200
+++ linux-2.6.17.8-routes-esfq-mq/drivers/md/dm-mpath.c	2006-08-07 15:25:=
07.000000000 +0200
@@ -558,8 +558,7 @@
 }
=20
 static struct priority_group *parse_priority_group(struct arg_set *as,
-						   struct multipath *m,
-						   struct dm_target *ti)
+						   struct multipath *m)
 {
 	static struct param _params[] =3D {
 		{1, 1024, ESTR("invalid number of paths")},
@@ -569,6 +568,7 @@
 	int r;
 	unsigned i, nr_selector_args, nr_params;
 	struct priority_group *pg;
+	struct dm_target *ti =3D m->ti;
=20
 	if (as->argc < 2) {
 		as->argc =3D 0;
@@ -625,12 +625,12 @@
 	return NULL;
 }
=20
-static int parse_hw_handler(struct arg_set *as, struct multipath *m,
-			    struct dm_target *ti)
+static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
 	int r;
 	struct hw_handler_type *hwht;
 	unsigned hw_argc;
+	struct dm_target *ti =3D m->ti;
=20
 	static struct param _params[] =3D {
 		{0, 1024, ESTR("invalid number of hardware handler args")},
@@ -662,11 +662,11 @@
 	return 0;
 }
=20
-static int parse_features(struct arg_set *as, struct multipath *m,
-			  struct dm_target *ti)
+static int parse_features(struct arg_set *as, struct multipath *m)
 {
 	int r;
 	unsigned argc;
+	struct dm_target *ti =3D m->ti;
=20
 	static struct param _params[] =3D {
 		{0, 1, ESTR("invalid number of feature args")},
@@ -713,11 +713,11 @@
=20
 	m->ti =3D ti;
=20
-	r =3D parse_features(&as, m, ti);
+	r =3D parse_features(&as, m);
 	if (r)
 		goto bad;
=20
-	r =3D parse_hw_handler(&as, m, ti);
+	r =3D parse_hw_handler(&as, m);
 	if (r)
 		goto bad;
=20
@@ -733,7 +733,7 @@
 	while (as.argc) {
 		struct priority_group *pg;
=20
-		pg =3D parse_priority_group(&as, m, ti);
+		pg =3D parse_priority_group(&as, m);
 		if (!pg) {
 			r =3D -EINVAL;
 			goto bad;
