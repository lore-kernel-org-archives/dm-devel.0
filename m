From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 18/72] libmultipath: replace_wwids(): fix
	possible fd leak
Date: Sat, 12 Oct 2019 21:27:59 +0000
Message-ID: <20191012212703.12989-19-martin.wilck@suse.com>
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

... in case the thread is cancelled.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index ef748125..f69ed6f5 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -7,6 +7,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 
+#include "util.h"
 #include "checkers.h"
 #include "vector.h"
 #include "structs.h"
@@ -87,7 +88,8 @@ write_out_wwid(int fd, char *wwid) {
 int
 replace_wwids(vector mp)
 {
-	int i, fd, can_write;
+	int i, can_write;
+	long fd;
 	struct multipath * mpp;
 	size_t len;
 	int ret = -1;
@@ -99,6 +101,8 @@ replace_wwids(vector mp)
 	pthread_cleanup_pop(1);
 	if (fd < 0)
 		goto out;
+
+	pthread_cleanup_push(close_fd, (void*)fd);
 	if (!can_write) {
 		condlog(0, "cannot replace wwids. wwids file is read-only");
 		goto out_file;
@@ -132,7 +136,7 @@ replace_wwids(vector mp)
 	}
 	ret = 0;
 out_file:
-	close(fd);
+	pthread_cleanup_pop(1);
 out:
 	return ret;
 }
-- 
2.23.0
