From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: housekeeping at prioritizers
Date: Sun, 12 Jun 2016 00:14:41 +0200
Message-ID: <1465683281-21755-2-git-send-email-xose.vazquez@gmail.com>
References: <1465683281-21755-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465683281-21755-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

add PRIO_IET to libmultipath/prio.h and sort them alphabetically.


"datacore" and "iet" are missing in multipath.conf.5 !!!


Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prio.h                | 21 +++++++++++----------
 libmultipath/prioritizers/Makefile | 16 ++++++++--------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 495688f..258dee7 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -19,16 +19,17 @@ struct path;
 /*
  * Known prioritizers for use in hwtable.c
  */
-#define PRIO_ALUA "alua"
-#define PRIO_CONST "const"
-#define PRIO_EMC "emc"
-#define PRIO_HDS "hds"
-#define PRIO_HP_SW "hp_sw"
-#define PRIO_ONTAP "ontap"
-#define PRIO_RANDOM "random"
-#define PRIO_RDAC "rdac"
-#define PRIO_DATACORE "datacore"
-#define PRIO_WEIGHTED_PATH "weightedpath"
+#define PRIO_ALUA		"alua"
+#define PRIO_CONST		"const"
+#define PRIO_DATACORE		"datacore"
+#define PRIO_EMC		"emc"
+#define PRIO_HDS		"hds"
+#define PRIO_HP_SW		"hp_sw"
+#define PRIO_IET		"iet"
+#define PRIO_ONTAP		"ontap"
+#define PRIO_RANDOM		"random"
+#define PRIO_RDAC		"rdac"
+#define PRIO_WEIGHTED_PATH	"weightedpath"
 
 /*
  * Value used to mark the fact prio was not defined
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 6cfac88..ca7b85c 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -5,17 +5,17 @@
 include ../../Makefile.inc
 
 LIBS = \
-	libpriorandom.so \
-	libprioconst.so \
-	libpriohp_sw.so \
-	libprioemc.so \
-	libpriordac.so \
 	libprioalua.so \
-	libprioontap.so \
+	libprioconst.so \
 	libpriodatacore.so \
+	libprioemc.so \
 	libpriohds.so \
-	libprioweightedpath.so \
-	libprioiet.so
+	libpriohp_sw.so \
+	libprioiet.so \
+	libprioontap.so \
+	libpriorandom.so \
+	libpriordac.so \
+	libprioweightedpath.so
 
 CFLAGS += -I..
 
-- 
2.5.5
