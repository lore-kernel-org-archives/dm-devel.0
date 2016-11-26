From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix misspellings
Date: Sat, 26 Nov 2016 02:33:49 +0100
Message-ID: <20161126013349.10725-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Done with https://github.com/lucasdemarchi/codespell


multipath-tools/kpartx/dasd.c:263: formated  ==> formatted
multipath-tools/libmultipath/discovery.c:1808: unuseable  ==> unusable
multipath-tools/libmultipath/discovery.h:20: exerpt  ==> excerpt
multipath-tools/libmultipath/memory.c:150: formated  ==> formatted
multipath-tools/libmultipath/checkers/directio.c:84: Sucessfully  ==> Successfully
multipath-tools/libmultipath/prioritizers/hds.c:9: pathes  ==> paths
multipath-tools/libmultipath/prioritizers/hds.c:14: pathes  ==> paths
multipath-tools/libmultipath/prioritizers/ontap.c:119: Retuns  ==> Returns
multipath-tools/third-party/valgrind/valgrind.h:6828: arbitary  ==> arbitrary
multipath-tools/multipath/02_multipath:11: dynamicaly  ==> dynamically
multipath-tools/multipath/multipath.conf.5:793: remeber  ==> remember
multipath-tools/libmpathpersist/mpath_persist.h:15: lenght  ==> length

-------8<-------
SUMMARY:
arbitary      1
dynamicaly    1
exerpt        1
formated      2
lenght        1
pathes        2
remeber       1
retuns        1
sucessfully   1
unuseable     1

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/dasd.c                     | 2 +-
 libmpathpersist/mpath_persist.h   | 2 +-
 libmultipath/checkers/directio.c  | 2 +-
 libmultipath/discovery.c          | 2 +-
 libmultipath/discovery.h          | 2 +-
 libmultipath/memory.c             | 2 +-
 libmultipath/prioritizers/hds.c   | 4 ++--
 libmultipath/prioritizers/ontap.c | 2 +-
 multipath/02_multipath            | 2 +-
 multipath/multipath.conf.5        | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index faf5e2e..1206e45 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -261,7 +261,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 				fmt_size = sectors512(vlabel.formatted_blocks,
 						      blocksize);
 			} else if (!strcmp(info.type, "ECKD")) {
-				/* formated w/o large volume support */
+				/* formatted w/o large volume support */
 				fmt_size = geo.cylinders * geo.heads
 					* geo.sectors * (blocksize >> 9);
 			} else {
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index fde0416..79de5b5 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -13,7 +13,7 @@ extern "C" {
 #define MPATH_MAX_PARAM_LEN	8192
 
 #define MPATH_MX_TIDS		32	  /* Max number of transport ids"*/
-#define MPATH_MX_TID_LEN	256	  /* Max lenght of transport id */
+#define MPATH_MX_TID_LEN	256	  /* Max length of transport id */
 
 /* PRIN Service Actions */
 #define MPATH_PRIN_RKEY_SA	0x00	   /* READ KEYS SA*/
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index eec12d5..ce60e4c 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -82,7 +82,7 @@ int libcheck_init (struct checker * c)
 	ct->ptr = (unsigned char *) (((unsigned long)ct->buf + pgsize - 1) &
 		  (~(pgsize - 1)));
 
-	/* Sucessfully initialized, return the context. */
+	/* Successfully initialized, return the context. */
 	c->context = (void *) ct;
 	return 0;
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index aaa915c..0f912ba 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1806,7 +1806,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 				pp->state = PATH_DOWN;
 			if (pp->state == PATH_UP && !pp->size) {
 				condlog(3, "%s: device size is 0, "
-					"path unuseable", pp->dev);
+					"path unusable", pp->dev);
 				pp->state = PATH_GHOST;
 			}
 		} else {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 97e5a32..3039268 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -18,7 +18,7 @@
 #endif
 
 /*
- * exerpt from sg_err.h
+ * excerpt from sg_err.h
  */
 #define SCSI_CHECK_CONDITION    0x2
 #define SCSI_COMMAND_TERMINATED 0x22
diff --git a/libmultipath/memory.c b/libmultipath/memory.c
index 293a688..ff5a030 100644
--- a/libmultipath/memory.c
+++ b/libmultipath/memory.c
@@ -148,7 +148,7 @@ dbg_strdup(char *str, char *file, char *function, int line)
 
 
 
-/* Display a buffer into a HEXA formated output */
+/* Display a buffer into a HEXA formatted output */
 static void
 dump_buffer(char *buff, int count)
 {
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index d161e68..70fb5d1 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -7,12 +7,12 @@
  * Prioritizer for Device Mapper Multipath and HDS Storage
  *
  * Hitachis Modular Storage contains two controllers for redundancy. The
- * Storage internal LUN (LDEV) will normally allocated via two pathes to the
+ * Storage internal LUN (LDEV) will normally allocated via two paths to the
  * server (one path per controller). For performance reasons should the server
  * access to a LDEV only via one controller. The other path to the other
  * controller is stand-by. It is also possible to allocate more as one path
  * for a LDEV per controller. Here is active/active access allowed. The other
- * pathes via the other controller are stand-by.
+ * paths via the other controller are stand-by.
  *
  * This prioritizer checks with inquiry command the represented LDEV and
  * Controller number and gives back a priority followed by this scheme:
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 38495cd..ca06d6c 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -117,7 +117,7 @@ out:
 }
 
 /*
- * Retuns:
+ * Returns:
  * -1: Unable to obtain proxy info
  *  0: Device _not_ proxy path
  *  1: Device _is_ proxy path
diff --git a/multipath/02_multipath b/multipath/02_multipath
index 523f0ef..de6e247 100755
--- a/multipath/02_multipath
+++ b/multipath/02_multipath
@@ -9,7 +9,7 @@ cp /sbin/kpartx $INITRDDIR/sbin
 
 #
 # feed the dependencies too
-# scsi_id is dynamicaly linked, so store the libs too
+# scsi_id is dynamically linked, so store the libs too
 #
 cp /lib/udev/scsi_id $INITRDDIR/lib/udev/
 cp /bin/mountpoint $INITRDDIR/bin
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8f5447d..c272dd6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -791,7 +791,7 @@ a path has the same WWID as a multipath device that was previously created
 while find_multipaths was set (even if that multipath device doesn't currently
 exist).
 Whenever a multipath device is created with find_multipaths set, multipath will
-remeber the WWID of the device, so that it will automatically create the
+remember the WWID of the device, so that it will automatically create the
 device again, as soon as it sees a path with that WWID. This should allow most
 users to have multipath automatically choose the correct paths to make into
 multipath devices, without having to edit the blacklist.
-- 
2.10.2
