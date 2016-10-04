From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 02/15] libmultipath/memory: Move an #include
	directive
Date: Tue, 4 Oct 2016 10:37:33 -0700
Message-ID: <4a207725-eb11-a7e1-9a64-c5b480308090@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Minimize the number of #include directives in libmultipath/memory.h
by moving #include <assert.h> into libmultipath/memory.c.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/memory.c | 1 +
 libmultipath/memory.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/memory.c b/libmultipath/memory.c
index 5441e6a..293a688 100644
--- a/libmultipath/memory.c
+++ b/libmultipath/memory.c
@@ -20,6 +20,7 @@
  * Copyright (C) 2001-2005 Alexandre Cassen, <acassen@linux-vs.org>
  */
 
+#include <assert.h>
 #include "memory.h"
 
 /*
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
index 29a75ed..a3c478e 100644
--- a/libmultipath/memory.h
+++ b/libmultipath/memory.h
@@ -27,7 +27,6 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
-#include <assert.h>
 
 /* Local defines */
 #ifdef _DEBUG_
-- 
2.10.0
