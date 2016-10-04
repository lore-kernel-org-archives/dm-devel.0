From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/15] libmultipath/prioritizers/ontap: Remove an
 unused #include directive
Date: Tue, 4 Oct 2016 10:36:59 -0700
Message-ID: <05acce93-153f-4735-44f7-4a74c8522f9a@sandisk.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/prioritizers/ontap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 4084c65..38495cd 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -17,7 +17,6 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <errno.h>
-#include <assert.h>
 
 #include "sg_include.h"
 #include "debug.h"
-- 
2.10.0
