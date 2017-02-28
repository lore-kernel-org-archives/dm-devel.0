From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 33/33] Make libdmmp build optional
Date: Tue, 28 Feb 2017 17:23:29 +0100
Message-ID: <20170228162329.14517-34-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile     | 6 +++++-
 Makefile.inc | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9f8bf775..cfee0d07 100644
--- a/Makefile
+++ b/Makefile
@@ -30,12 +30,16 @@ BUILDDIRS = \
 	libmultipath/prioritizers \
 	libmultipath/checkers \
 	libmpathpersist \
-	libdmmp \
 	multipath \
 	multipathd \
 	mpathpersist \
 	kpartx
 
+ifneq ($(ENABLE_LIBDMMP),0)
+BUILDDIRS += \
+	libdmmp
+endif
+
 all: recurse
 
 recurse:
diff --git a/Makefile.inc b/Makefile.inc
index b5e910f9..740081e3 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -11,6 +11,9 @@
 #
 # Uncomment to disable RADOS support (e.g. if rados headers are missing).
 # ENABLE_RADOS = 0
+#
+# Uncomment to disable libdmmp support
+# ENABLE_LIBDMMP = 0
 
 ifeq ($(TOPDIR),)
 	TOPDIR	= ..
-- 
2.11.0
