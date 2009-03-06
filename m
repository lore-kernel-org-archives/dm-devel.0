From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH]:[multipath-tools] Adding the hwtable for LSI
 generic rdac storage devices
Date: Fri, 6 Mar 2009 09:38:05 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46675B0E8@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


This patch adds the hwtable for LSI rdac generic storage. Also sets the f=
eature pg_init_retries to maximum(50).

Signed-off-by: Babu Moger <babu.moger@lsi.com>

---

--- multipath-tools/libmultipath/hwtable.c.orig	2009-03-04 14:33:11.00000=
0000 -0600
+++ multipath-tools/libmultipath/hwtable.c	2009-03-04 14:43:57.000000000 =
-0600
@@ -837,6 +837,22 @@ static struct hwentry default_hw[] =3D {
 		.checker_name  =3D RDAC,
 		.prio_name     =3D PRIO_RDAC,
 	},
+	/* LSI Generic rdac storage */
+	{
+		.vendor        =3D "(LSI|ENGENIO)",
+		.product       =3D "INF-01-00",
+		.getuid        =3D DEFAULT_GETUID,
+		.features      =3D "2 pg_init_retries 50",
+		.hwhandler     =3D "1 rdac",
+		.selector      =3D DEFAULT_SELECTOR,
+		.pgpolicy      =3D GROUP_BY_PRIO,
+		.pgfailback    =3D -FAILBACK_IMMEDIATE,
+		.rr_weight     =3D RR_WEIGHT_NONE,
+		.no_path_retry =3D 15,
+		.minio         =3D DEFAULT_MINIO,
+		.checker_name  =3D RDAC,
+		.prio_name     =3D PRIO_RDAC,
+	},
 	/*
 	 * EOL
 	 */
