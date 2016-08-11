From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 06/11] multipath-tools: request to update man
	pages if the code is changed
Date: Thu, 11 Aug 2016 20:32:22 +0200
Message-ID: <1470940345-4441-6-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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

Please, document the changes.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers/Makefile     | 1 +
 libmultipath/defaults.h            | 4 ++++
 libmultipath/dict.c                | 3 +++
 libmultipath/prioritizers/Makefile | 1 +
 4 files changed, 9 insertions(+)

diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index e46192c..11ab76f 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -5,6 +5,7 @@ include ../../Makefile.inc
 
 CFLAGS += -I..
 
+# If you add or remove a checker also update multipath/multipath.conf.5
 LIBS= \
 	libcheckcciss_tur.so \
 	libcheckreadsector0.so \
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index dd6a24b..3af85eb 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,3 +1,7 @@
+/*
+ * If you add or modify a value also update multipath/multipath.conf.5
+ * and the TEMPLATE in libmultipath/hwtable.c
+ */
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1933b6d..e8c6804 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1329,6 +1329,9 @@ snprint_deprecated (struct config *conf, char * buff, int len, void * data)
 
 #define __deprecated
 
+/*
+ * If you add or remove a keywork also update multipath/multipath.conf.5
+ */
 void
 init_keywords(vector keywords)
 {
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index eff5fc1..36b42e4 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -5,6 +5,7 @@ include ../../Makefile.inc
 
 CFLAGS += -I..
 
+# If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
 	libprioalua.so \
 	libprioconst.so \
-- 
2.7.4
