From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/21] libmultipath/checkers: directio: use
	message id
Date: Fri, 12 Oct 2018 00:26:51 +0200
Message-ID: <20181011222707.3631-6-mwilck@suse.com>
References: <20181011222707.3631-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181011222707.3631-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index a80848d4..c4a0712e 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -18,10 +18,19 @@
 #include "checkers.h"
 #include "../libmultipath/debug.h"
 
-#define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
-#define MSG_DIRECTIO_UP		"directio checker reports path is up"
-#define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
-#define MSG_DIRECTIO_PENDING	"directio checker is waiting on aio"
+enum {
+	MSG_DIRECTIO_UNKNOWN = CHECKER_FIRST_MSGID,
+	MSG_DIRECTIO_PENDING,
+	MSG_DIRECTIO_BLOCKSIZE,
+};
+
+#define _IDX(x) (MSG_DIRECTIO_##x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[_IDX(UNKNOWN)] = " is not available",
+	[_IDX(PENDING)] = " is waiting on aio",
+	[_IDX(BLOCKSIZE)] = " cannot get blocksize, set default",
+	NULL,
+};
 
 #define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt, ##args)
 
@@ -54,7 +63,7 @@ int libcheck_init (struct checker * c)
 	}
 
 	if (ioctl(c->fd, BLKBSZGET, &ct->blksize) < 0) {
-		MSG(c, "cannot get blocksize, set default");
+		c->msgid = MSG_DIRECTIO_BLOCKSIZE;
 		ct->blksize = 512;
 	}
 	if (ct->blksize > 4096) {
@@ -198,16 +207,16 @@ int libcheck_check (struct checker * c)
 	switch (ret)
 	{
 	case PATH_UNCHECKED:
-		MSG(c, MSG_DIRECTIO_UNKNOWN);
+		c->msgid = MSG_DIRECTIO_UNKNOWN;
 		break;
 	case PATH_DOWN:
-		MSG(c, MSG_DIRECTIO_DOWN);
+		c->msgid = CHECKER_MSGID_DOWN;
 		break;
 	case PATH_UP:
-		MSG(c, MSG_DIRECTIO_UP);
+		c->msgid = CHECKER_MSGID_UP;
 		break;
 	case PATH_PENDING:
-		MSG(c, MSG_DIRECTIO_PENDING);
+		c->msgid = MSG_DIRECTIO_PENDING;
 		break;
 	default:
 		break;
-- 
2.19.0
