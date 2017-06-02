From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/5] libmultipath: change how RADOS checker is
	enabled
Date: Thu,  1 Jun 2017 22:09:09 -0500
Message-ID: <1496372952-27110-3-git-send-email-bmarzins@redhat.com>
References: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Instead of making the user call "make", "make install" and "make clean"
with ENABLE_RADOS set correctly, have the makefile check if
/usr/include/rados/librados.h exists, just like it checks if specific
functions exist in a file.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                   | 13 +++++++++++++
 libmultipath/checkers/Makefile |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 1815f9a..ec41dbf 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -109,5 +109,18 @@ check_func =								       \
 	echo "$$found"							       \
     )
 
+# Checker whether a file with name $1 exists
+check_file = $(shell	\
+	if [ -f "$1" ]; then \
+		found=1; \
+		status="yes"; \
+	else \
+		found=0; \
+		status="no"; \
+	fi; \
+	echo 1>&2 "Checking if $1 exists ... $$status"; \
+	echo "$$found" \
+	)
+
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 732ca9d..bce6b8b 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -14,7 +14,8 @@ LIBS= \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
 	libcheckrdac.so
-ifneq ($(ENABLE_RADOS),0)
+
+ifneq ($(call check_file,/usr/include/rados/librados.h),0)
 LIBS += libcheckrbd.so
 endif
 
-- 
2.7.4
