From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: memory.h is a local header in
	multipathd/uxclnt.c
Date: Tue, 19 Jul 2016 19:53:45 +0200
Message-ID: <1468950825-26402-1-git-send-email-xose.vazquez@gmail.com>
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

If it is removed, the compiler warns: "undefined reference to `FREE'"

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/uxclnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index a0d58c3..109a217 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -20,7 +20,7 @@
 
 #include "mpath_cmd.h"
 #include "uxsock.h"
-#include <memory.h>
+#include "memory.h"
 #include "defaults.h"
 
 #include "vector.h"
-- 
2.7.4
