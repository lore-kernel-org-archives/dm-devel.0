From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 10/11] multipath-tools: move code up in Makefile
Date: Thu, 11 Aug 2016 20:33:37 +0200
Message-ID: <1470940418-4604-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 7786c83..95c7dfb 100644
--- a/Makefile
+++ b/Makefile
@@ -16,6 +16,12 @@ ifeq ($(KRNLSRC),)
 	endif
 endif
 
+ifeq ($(MULTIPATH_VERSION),)
+	VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
+else
+	VERSION = $(MULTIPATH_VERSION)
+endif
+
 export KRNLSRC
 export KRNLOBJ
 
@@ -30,12 +36,6 @@ BUILDDIRS = \
 	mpathpersist \
 	kpartx
 
-ifeq ($(MULTIPATH_VERSION),)
-	VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
-else
-	VERSION = $(MULTIPATH_VERSION)
-endif
-
 all: recurse
 
 recurse:
-- 
2.7.4
