From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/7] libmpathpersist: Add two missing #include
	directives
Date: Wed, 17 May 2017 08:43:05 -0700
Message-ID: <20170517154309.17787-4-bart.vanassche@sandisk.com>
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

Make sure that including mpathpr.h as the first header file does not
fail. Since mpath_updatepr.c defines functions declared in mpathpr.h,
include that header file in that .c file such that the compiler can
check consistency of the .h and the .c file.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmpathpersist/mpath_updatepr.c | 1 +
 libmpathpersist/mpathpr.h        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 5af2e032..b3701b28 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -15,6 +15,7 @@
 #include "mpath_cmd.h"
 #include "uxsock.h"
 #include "memory.h"
+#include "mpathpr.h"
 
 
 int update_prflag(char * arg1, char * arg2, int noisy)
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index e6c2dedf..99e641b7 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -1,6 +1,8 @@
 #ifndef MPATHPR_H
 #define MPATHPR_H
 
+#include "structs.h" /* FILE_NAME_SIZE */
+
 struct prin_param {
 	char dev[FILE_NAME_SIZE];
 	int rq_servact;
-- 
2.12.2
