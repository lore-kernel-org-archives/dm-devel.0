From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 32/33] libmultipath/checkers: make RADOS checker
	optional
Date: Tue, 28 Feb 2017 17:23:28 +0100
Message-ID: <20170228162329.14517-33-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

Some distros lack the rados header files. Use
"make ENABLE_RADOS=0" on such distributions to build
multipath-tools in such cases. The default (to enable RADOS
support) remains unchanged.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                   | 3 +++
 libmultipath/checkers/Makefile | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 93d8e340..b5e910f9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -8,6 +8,9 @@
 #
 # WITH_LOCAL_LIBDM	= 1
 # WITH_LOCAL_LIBSYSFS	= 1
+#
+# Uncomment to disable RADOS support (e.g. if rados headers are missing).
+# ENABLE_RADOS = 0
 
 ifeq ($(TOPDIR),)
 	TOPDIR	= ..
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 11ab76f6..4970fc07 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -13,8 +13,10 @@ LIBS= \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
-	libcheckrdac.so \
-	libcheckrbd.so
+	libcheckrdac.so
+ifneq ($(ENABLE_RADOS),0)
+LIBS += libcheckrbd.so
+endif
 
 all: $(LIBS)
 
-- 
2.11.0
