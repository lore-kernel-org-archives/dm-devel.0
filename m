From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/7] Makefile: Remove assignments to unused
	variables
Date: Wed, 17 May 2017 08:43:03 -0700
Message-ID: <20170517154309.17787-2-bart.vanassche@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

No multipath-tools source file or Makefile imports anything directly
from the kernel source tree. Hence remove the variables that refer to
the kernel tree.

Since the $(VERSION) Makefile macro is not used, remove it. Note:
the version number is defined as a macro in libmultipath/version.h.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 Makefile | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/Makefile b/Makefile
index cfee0d07..bfb168fb 100644
--- a/Makefile
+++ b/Makefile
@@ -2,28 +2,6 @@
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 
-#
-# Try to supply the linux kernel headers.
-#
-ifeq ($(KRNLSRC),)
-	KRNLLIB = /lib/modules/$(shell uname -r)
-	ifeq ($(shell test -r $(KRNLLIB)/source && echo 1),1)
-		KRNLSRC = $(KRNLLIB)/source
-		KRNLOBJ = $(KRNLLIB)/build
-	else
-		KRNLSRC = $(KRNLLIB)/build
-		KRNLOBJ = $(KRNLLIB)/build
-	endif
-	export KRNLSRC
-	export KRNLOBJ
-endif
-
-ifeq ($(MULTIPATH_VERSION),)
-	VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
-else
-	VERSION = $(MULTIPATH_VERSION)
-endif
-
 BUILDDIRS = \
 	libmpathcmd \
 	libmultipath \
@@ -43,10 +21,7 @@ endif
 all: recurse
 
 recurse:
-	@for dir in $(BUILDDIRS); do \
-	$(MAKE) -C $$dir VERSION=$(VERSION) \
-		KRNLSRC=$(KRNLSRC) KRNLOBJ=$(KRNLOBJ) || exit $?; \
-	done
+	@for dir in $(BUILDDIRS); do $(MAKE) -C $$dir || exit $?; done
 
 recurse_clean:
 	@for dir in $(BUILDDIRS); do \
-- 
2.12.2
