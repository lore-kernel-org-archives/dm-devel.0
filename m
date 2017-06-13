From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/4] multipath: Fix a potential buffer overflow
Date: Tue, 13 Jun 2017 09:33:39 -0700
Message-ID: <20170613163339.23005-5-bart.vanassche@sandisk.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170613163339.23005-1-bart.vanassche@sandisk.com>
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

Avoid that gcc 7 reports the following warning:

cli_handlers.c:1340:18: warning: '%d' directive writing between 1 and 3 bytes into a region of size 2 [-Wformat-overflow=]
  sprintf(*reply,"%d",mpp->prflag);

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/cli_handlers.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 04c73866..460fea1f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1,6 +1,9 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
+
+#define _GNU_SOURCE
+
 #include "checkers.h"
 #include "memory.h"
 #include "vector.h"
@@ -1332,14 +1335,9 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
 
-	*reply =(char *)malloc(2);
-	*len = 2;
-	memset(*reply,0,2);
-
-
-	sprintf(*reply,"%d",mpp->prflag);
-	(*reply)[1]='\0';
-
+	*len = asprintf(reply, "%d", mpp->prflag);
+	if (*len < 0)
+		return 1;
 
 	condlog(3, "%s: reply = %s", param, *reply);
 
-- 
2.12.2
