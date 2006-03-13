From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath-tools: fix minor compilation issues
Date: Mon, 13 Mar 2006 13:27:40 +0100
Message-ID: <4415653C.4050702@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050401070904020507060105"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.
--------------050401070904020507060105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

our checker found some minor issues:

- refwwid in libmultipath/configure.c:get_refwwid() might be used
  uninitialized. As dev_type is a simple 'int' there is nothing which
  prevents the unsuspecting user to call it with an unhandled value.
  We shoud rather use an enum and set refwwid to NULL to be on the safe
  side.
- attr in libmultipath/discovery.c:devt2devname() might be used
  uninitialized. Quite unlikely, but might happen in principle.
  So better have it initialized.
- r in multipath/main.c:main() might be used uninitialized.
  True. So have it initialized.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050401070904020507060105
Content-Type: text/x-patch;
 name="multipath-tools-compile-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-compile-fixes.patch"

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 6e5633a..43282fe 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -48,7 +48,7 @@ struct config {
 	int with_sysfs;
 	int pgpolicy;
 	struct checker * checker;
-	int dev_type;
+	enum devtypes dev_type;
 	int minio;
 	int checkint;
 	int max_checkint;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1ba4356..7285617 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -547,11 +547,11 @@ coalesce_paths (struct vectors * vecs, v
 }
 
 extern char *
-get_refwwid (char * dev, int dev_type, vector pathvec)
+get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
 {
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
-	char * refwwid;
+	char * refwwid = NULL;
 
 	if (dev_type == DEV_NONE)
 		return NULL;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 42ee9b0..1cbbe82 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -25,5 +25,5 @@ int setup_map (struct multipath * mpp);
 int domap (struct multipath * mpp);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid);
-char * get_refwwid (char * dev, int dev_type, vector pathvec);
+char * get_refwwid (char * dev, enum devtypes dev_type, vector pathvec);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cf8289c..0b8095c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -237,7 +237,7 @@ devt2devname (char *devname, char *devt)
 	struct dlist * ls;
 	char attr_path[FILE_NAME_SIZE];
 	char block_path[FILE_NAME_SIZE];
-	struct sysfs_attribute * attr;
+	struct sysfs_attribute * attr = NULL;
 	struct sysfs_class * class;
 	struct sysfs_class_device * dev;
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 6cc63e2..2c44122 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -13,8 +13,8 @@
 #include "structs_vec.h"
 #include "print.h"
 #include "dmparser.h"
-#include "configure.h"
 #include "config.h"
+#include "configure.h"
 #include "pgpolicies.h"
 #include "defaults.h"
 #include "parser.h"
diff --git a/multipath/main.c b/multipath/main.c
index 98f7207..931b137 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -305,7 +305,7 @@ main (int argc, char *argv[])
 	int arg;
 	extern char *optarg;
 	extern int optind;
-	int i, r;
+	int i, r = 1;
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");

--------------050401070904020507060105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050401070904020507060105--
