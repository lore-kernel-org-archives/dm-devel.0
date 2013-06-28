From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 8/8] fix mutipath -W on empty wwids file
Date: Fri, 28 Jun 2013 18:26:21 -0500
Message-ID: <1372461981-6333-9-git-send-email-bmarzins@redhat.com>
References: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When multipath tries to open the wwids file and finds it empty or
missing, it writes the header to the file.  When it tried to wipe
the wwids from an empty or missing file, it didn't seek back to the
start of the file after truncating it.  This caused the the wwids
file to have a patch of zeroed bytes at the start. This patch fixes
this by always seeking back to the start of the file before rewriting
the header.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/wwids.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 91b07a7..eca1799 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
+#include <sys/types.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -100,6 +101,11 @@ replace_wwids(vector mp)
 		condlog(0, "cannot truncate wwids file : %s", strerror(errno));
 		goto out_file;
 	}
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		condlog(0, "cannot seek to the start of the file : %s",
+			strerror(errno));
+		goto out_file;
+	}
 	len = strlen(WWIDS_FILE_HEADER);
 	if (write_all(fd, WWIDS_FILE_HEADER, len) != len) {
 		condlog(0, "Can't write wwid file header : %s",
-- 
1.8.2
