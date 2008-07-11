From: "Jim Lester" <Jim.Lester@compellent.com>
Subject: [PATCH] libmultipath/hwtable.c: Compellent Definition
Date: Fri, 11 Jul 2008 11:17:03 -0500
Message-ID: <A7519D7FDEF2A144BA6D40BDF13100FEA01806@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

The following is the patch to include a hardware definition for
Compellent's SAN. This is my first patch so hopefully I did everything
correctly. The definition in config form is below, if for some reason my
code doesn't match that, please inform me.

        device {
                vendor "COMPELNT"
                product "Compellent Vol"
                path_grouping_policy multibus
                path_checker tur
                checker tur
                failback immediate
                no_path_retry queue
        }

---
Jim Lester | Linux Product Specialist
Jim.Lester@Compellent.com
(o) 952.294.2802
(c) 763.218.6012
Compellent Technologies | www.compellent.com

--- multipath-tools/libmultipath/hwtable.c      2008-07-10
17:05:53.000000000 -0500
+++ multipath-tools.my/libmultipath/hwtable.c   2008-07-10
17:17:27.000000000 -0500
@@ -706,6 +706,27 @@
                .prio_name     =3D PRIO_RDAC,
        },
        /*
+        * Compellent Technologies, Inc.
+        *
+        * Maintainer : Jim Lester, Compellent
+        * Mail : jim.lester@compellent.com
+        */
+       {
+               .vendor        =3D "COMPELNT",
+               .product       =3D "Compellent Vol",
+               .getuid        =3D DEFAULT_GETUID,
+               .features      =3D DEFAULT_FEATURES,
+               .hwhandler     =3D DEFAULT_HWHANDLER,
+               .selector      =3D DEFAULT_SELECTOR,
+               .pgpolicy      =3D MULTIBUS,
+               .pgfailback    =3D -FAILBACK_IMMEDIATE,
+               .rr_weight     =3D RR_WEIGHT_NONE,
+               .no_path_retry =3D NO_PATH_RETRY_QUEUE,
+               .minio         =3D DEFAULT_MINIO,
+               .checker_name  =3D TUR,
+               .prio_name     =3D DEFAULT_PRIO,
+       },
+       /*
         * EOL
         */
        {
@@ -725,6 +746,7 @@
        },
 };

+
 extern int
 setup_default_hwtable (vector hw)
 {
