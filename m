From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/21] libmultipath/checkers: cciss_tur: use
	message id
Date: Fri, 12 Oct 2018 00:26:50 +0200
Message-ID: <20181011222707.3631-5-mwilck@suse.com>
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
 libmultipath/checkers/cciss_tur.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index 1cab2015..ea843742 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -42,9 +42,6 @@
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
 
-#define MSG_CCISS_TUR_UP	"cciss_tur checker reports path is up"
-#define MSG_CCISS_TUR_DOWN	"cciss_tur checker reports path is down"
-
 struct cciss_tur_checker_context {
 	void * dummy;
 };
@@ -69,7 +66,7 @@ int libcheck_check(struct checker * c)
 	IOCTL_Command_struct cic;       // cciss ioctl command
 
 	if ((c->fd) < 0) {
-		MSG(c,"no usable fd");
+		c->msgid = CHECKER_MSGID_NO_FD;
 		ret = -1;
 		goto out;
 	}
@@ -79,7 +76,7 @@ int libcheck_check(struct checker * c)
 		perror("Error: ");
 		fprintf(stderr, "cciss TUR  failed in CCISS_GETLUNINFO: %s\n",
 			strerror(errno));
-		MSG(c,MSG_CCISS_TUR_DOWN);
+		c->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	} else {
@@ -106,18 +103,18 @@ int libcheck_check(struct checker * c)
 	if (rc < 0) {
 		fprintf(stderr, "cciss TUR  failed: %s\n",
 			strerror(errno));
-		MSG(c,MSG_CCISS_TUR_DOWN);
+		c->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	}
 
 	if ((cic.error_info.CommandStatus | cic.error_info.ScsiStatus )) {
-		MSG(c,MSG_CCISS_TUR_DOWN);
+		c->msgid = CHECKER_MSGID_DOWN;
 		ret = PATH_DOWN;
 		goto out;
 	}
 
-	MSG(c,MSG_CCISS_TUR_UP);
+	c->msgid = CHECKER_MSGID_UP;
 
 	ret = PATH_UP;
 out:
-- 
2.19.0
