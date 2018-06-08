From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/28] kpartx: no need to use FREE_CONST
Date: Fri,  8 Jun 2018 12:20:14 +0200
Message-ID: <20180608102041.22904-2-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

A function that returns a result of strdup() doesn't need to declare that
result as const char*.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 8f68a246..f94d70e7 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -11,7 +11,6 @@
 #include <sys/sysmacros.h>
 #include "devmapper.h"
 
-#define FREE_CONST(p) do { free((void*)(long)p); p = NULL; } while(0)
 #define _UUID_PREFIX "part"
 #define UUID_PREFIX _UUID_PREFIX "%d-"
 #define _UUID_PREFIX_LEN (sizeof(_UUID_PREFIX) - 1)
@@ -252,10 +251,11 @@ out:
 	return r;
 }
 
-static const char *dm_find_uuid(const char *uuid)
+static char *dm_find_uuid(const char *uuid)
 {
 	struct dm_task *dmt;
-	const char *name = NULL, *tmp;
+	char *name = NULL;
+	const char *tmp;
 
 	if ((dmt = dm_task_create(DM_DEVICE_INFO)) == NULL)
 		return NULL;
@@ -642,7 +642,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 {
 	int r;
 	char params[PARAMS_SIZE];
-	const char *tmp;
+	char *tmp;
 	char *uuid;
 	int major, minor;
 	char dev_t[32];
@@ -696,7 +696,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	} else
 		*part_uuid = uuid;
 out:
-	FREE_CONST(tmp);
+	free(tmp);
 	return r;
 }
 
-- 
2.17.0
