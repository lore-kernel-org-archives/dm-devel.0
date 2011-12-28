From: Oren Held <orenhe@il.ibm.com>
Subject: [PATCH] Add default values for IBM XIV Storage System.
Date: Wed, 28 Dec 2011 19:59:20 +0200
Message-ID: <20111228175920.GA29764@orenhe-laptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Transfer-Encoding: 8bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii; format=fixed
Content-Disposition: inline


Signed-off-by: Oren Held <orenhe@il.ibm.com>
---
 libmultipath/hwtable.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)


--WIyZ46R2i8wDzkSu
Content-Type: text/x-patch; charset=us-ascii;
	name="0001-Add-default-values-for-IBM-XIV-Storage-System.patch"
Content-Disposition: attachment;
	filename="0001-Add-default-values-for-IBM-XIV-Storage-System.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7697883..8dceaba 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -771,6 +771,24 @@ static struct hwentry default=5Fhw[] =3D {
 		.prio=5Fname     =3D PRIO=5FALUA,
 		.prio=5Fargs     =3D NULL,
 	},
+        {
+                /* IBM XIV Storage System */
+                .vendor        =3D "IBM",
+                .product       =3D "2810XIV",
+                .getuid        =3D DEFAULT=5FGETUID,
+                .features      =3D "1 queue=5Fif=5Fno=5Fpath",
+                .hwhandler     =3D DEFAULT=5FHWHANDLER,
+                .selector      =3D DEFAULT=5FSELECTOR,
+                .pgpolicy      =3D MULTIBUS,
+                .pgfailback    =3D 15,
+                .rr=5Fweight     =3D RR=5FWEIGHT=5FNONE,
+                .no=5Fpath=5Fretry =3D NO=5FPATH=5FRETRY=5FUNDEF,
+                .minio         =3D 15,
+                .minio=5Frq      =3D DEFAULT=5FMINIO=5FRQ,
+                .checker=5Fname  =3D TUR,
+                .prio=5Fname     =3D DEFAULT=5FPRIO,
+                .prio=5Fargs     =3D NULL,
+        },
 	/*
 	 * IBM Power Virtual SCSI Devices
 	 *
=

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--WIyZ46R2i8wDzkSu--
