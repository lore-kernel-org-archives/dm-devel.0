From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 04/72] libmultipath: alias.c: use strlcpy(),
	and 2 minor fixes
Date: Sat, 12 Oct 2019 21:27:41 +0000
Message-ID: <20191012212703.12989-5-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 5b05ff69..412ab5b4 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -10,6 +10,7 @@
 #include <stdio.h>
 
 #include "debug.h"
+#include "util.h"
 #include "uxsock.h"
 #include "alias.h"
 #include "file.h"
@@ -189,8 +190,7 @@ rlookup_binding(FILE *f, char *buff, const char *map_alias, const char *prefix)
 		if (strcmp(alias, map_alias) == 0){
 			condlog(3, "Found matching alias [%s] in bindings file."
 				"\nSetting wwid to %s", alias, wwid);
-			strncpy(buff, wwid, WWID_SIZE);
-			buff[WWID_SIZE - 1] = '\0';
+			strlcpy(buff, wwid, WWID_SIZE);
 			return 0;
 		}
 	}
@@ -214,7 +214,7 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 
 	i = format_devname(buf, id, LINE_MAX, prefix);
 	c = buf + i;
-	snprintf(c,LINE_MAX - i, " %s\n", wwid);
+	snprintf(c, LINE_MAX - i, " %s\n", wwid);
 	buf[LINE_MAX - 1] = '\0';
 
 	offset = lseek(fd, 0, SEEK_END);
@@ -265,7 +265,7 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 		close(fd);
 		return NULL;
 	}
-	/* lookup the binding. if it exsists, the wwid will be in buff
+	/* lookup the binding. if it exists, the wwid will be in buff
 	 * either way, id contains the id for the alias
 	 */
 	rlookup_binding(f, buff, alias_old, prefix);
-- 
2.23.0
