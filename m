From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/12] kpartx: relax and improve UUID check in
	dm_compare_uuid
Date: Mon, 15 May 2017 17:37:14 +0200
Message-ID: <20170515153722.11508-5-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

It is wrong to assume that UUIDs of parent devices always contain
"mpath". Fix that, and make the check for the kpartx-specific prefix
"part%d-" stricter and more explicit.

Moreover, avoid duplication of string constants and properly express
the dependencies of the various constants.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 8aca9592..8b125be5 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -10,8 +10,10 @@
 #include <errno.h>
 #include "devmapper.h"
 
-#define UUID_PREFIX "part%d-"
-#define MAX_PREFIX_LEN 8
+#define _UUID_PREFIX "part"
+#define UUID_PREFIX _UUID_PREFIX "%d-"
+#define _UUID_PREFIX_LEN (sizeof(_UUID_PREFIX) - 1)
+#define MAX_PREFIX_LEN (_UUID_PREFIX_LEN + 4)
 #define PARAMS_SIZE 1024
 
 int dm_prereq(char * str, int x, int y, int z)
@@ -417,9 +419,13 @@ dm_compare_uuid(const char *mapuuid, const char *partname)
 	if (!partuuid)
 		return 1;
 
-	if (!strncmp(partuuid, "part", 4)) {
-		char *p = strstr(partuuid, "mpath-");
-		if (p && !strcmp(mapuuid, p))
+	if (!strncmp(partuuid, _UUID_PREFIX, _UUID_PREFIX_LEN)) {
+		char *p = partuuid + _UUID_PREFIX_LEN;
+		/* skip partition number */
+		while (isdigit(*p))
+			p++;
+		if (p != partuuid + _UUID_PREFIX_LEN && *p == '-' &&
+		    !strcmp(mapuuid, p + 1))
 			r = 0;
 	}
 	free(partuuid);
-- 
2.12.2
