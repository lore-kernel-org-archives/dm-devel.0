From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 08/22] libmultipath/checkers: rdac: use
	message id
Date: Tue, 30 Oct 2018 22:06:39 +0100
Message-ID: <20181030210653.29677-9-mwilck@suse.com>
References: <20181030210653.29677-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030210653.29677-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/rdac.c | 64 +++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 5104e4e5..266f8e10 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -31,9 +31,7 @@
 #define CURRENT_PAGE_CODE_VALUES	0
 #define CHANGEABLE_PAGE_CODE_VALUES	1
 
-#define MSG_RDAC_UP    "rdac checker reports path is up"
-#define MSG_RDAC_DOWN  "rdac checker reports path is down"
-#define MSG_RDAC_GHOST "rdac checker reports path is ghost"
+#define MSG_RDAC_DOWN  " reports path is down"
 #define MSG_RDAC_DOWN_TYPE(STR) MSG_RDAC_DOWN": "STR
 
 #define RTPG_UNAVAILABLE	0x3
@@ -219,41 +217,69 @@ struct volume_access_inq
 	char dontcare1[34];
 };
 
-const char
-*checker_msg_string(struct volume_access_inq *inq)
+enum {
+	RDAC_MSGID_NOT_CONN = CHECKER_FIRST_MSGID,
+	RDAC_MSGID_IN_STARTUP,
+	RDAC_MSGID_NON_RESPONSIVE,
+	RDAC_MSGID_IN_RESET,
+	RDAC_MSGID_FW_DOWNLOADING,
+	RDAC_MSGID_QUIESCED,
+	RDAC_MSGID_SERVICE_MODE,
+	RDAC_MSGID_UNAVAILABLE,
+	RDAC_MSGID_INQUIRY_FAILED,
+};
+
+#define _IDX(x) (RDAC_MSGID_##x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[_IDX(NOT_CONN)] = MSG_RDAC_DOWN_TYPE("lun not connected"),
+	[_IDX(IN_STARTUP)] = MSG_RDAC_DOWN_TYPE("ctlr is in startup sequence"),
+	[_IDX(NON_RESPONSIVE)] =
+	MSG_RDAC_DOWN_TYPE("non-responsive to queries"),
+	[_IDX(IN_RESET)] = MSG_RDAC_DOWN_TYPE("ctlr held in reset"),
+	[_IDX(FW_DOWNLOADING)] =
+	MSG_RDAC_DOWN_TYPE("ctlr firmware downloading"),
+	[_IDX(QUIESCED)] = MSG_RDAC_DOWN_TYPE("ctlr quiesced by admin request"),
+	[_IDX(SERVICE_MODE)] = MSG_RDAC_DOWN_TYPE("ctlr is in service mode"),
+	[_IDX(UNAVAILABLE)] = MSG_RDAC_DOWN_TYPE("ctlr is unavailable"),
+	[_IDX(INQUIRY_FAILED)] = MSG_RDAC_DOWN_TYPE("inquiry failed"),
+	NULL,
+};
+
+static int
+checker_msg_string(const struct volume_access_inq *inq)
 {
 	/* lun not connected */
 	if (((inq->PQ_PDT & 0xE0) == 0x20) || (inq->PQ_PDT & 0x7f))
-		return MSG_RDAC_DOWN_TYPE("lun not connected");
+		return RDAC_MSGID_NOT_CONN;
 
 	/* if no tpg data is available, give the generic path down message */
 	if (!(inq->avtcvp & 0x10))
-		return MSG_RDAC_DOWN;
+		return CHECKER_MSGID_DOWN;
 
 	/* controller is booting up */
 	if (((inq->aas_cur & 0x0F) == RTPG_TRANSITIONING) &&
 		(inq->aas_alt & 0x0F) != RTPG_TRANSITIONING)
-		return MSG_RDAC_DOWN_TYPE("ctlr is in startup sequence");
+		return RDAC_MSGID_IN_STARTUP;
 
 	/* if not unavailable, give generic message */
 	if ((inq->aas_cur & 0x0F) != RTPG_UNAVAILABLE)
-		return MSG_RDAC_DOWN;
+		return CHECKER_MSGID_DOWN;
 
 	/* target port group unavailable */
 	switch (inq->vendor_specific_cur) {
 	case RTPG_UNAVAIL_NON_RESPONSIVE:
-		return MSG_RDAC_DOWN_TYPE("non-responsive to queries");
+		return RDAC_MSGID_NON_RESPONSIVE;
 	case RTPG_UNAVAIL_IN_RESET:
-		return MSG_RDAC_DOWN_TYPE("ctlr held in reset");
+		return RDAC_MSGID_IN_RESET;
 	case RTPG_UNAVAIL_CFW_DL1:
 	case RTPG_UNAVAIL_CFW_DL2:
-		return MSG_RDAC_DOWN_TYPE("ctlr firmware downloading");
+		return RDAC_MSGID_FW_DOWNLOADING;
 	case RTPG_UNAVAIL_QUIESCED:
-		return MSG_RDAC_DOWN_TYPE("ctlr quiesced by admin request");
+		return RDAC_MSGID_QUIESCED;
 	case RTPG_UNAVAIL_SERVICE_MODE:
-		return MSG_RDAC_DOWN_TYPE("ctlr is in service mode");
+		return RDAC_MSGID_SERVICE_MODE;
 	default:
-		return MSG_RDAC_DOWN_TYPE("ctlr is unavailable");
+		return RDAC_MSGID_UNAVAILABLE;
 	}
 }
 
@@ -307,14 +333,14 @@ int libcheck_check(struct checker * c)
 done:
 	switch (ret) {
 	case PATH_DOWN:
-		MSG(c, "%s", (inqfail) ? MSG_RDAC_DOWN_TYPE("inquiry failed") :
-			checker_msg_string(&inq));
+		c->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED :
+			    checker_msg_string(&inq));
 		break;
 	case PATH_UP:
-		MSG(c, MSG_RDAC_UP);
+		c->msgid = CHECKER_MSGID_UP;
 		break;
 	case PATH_GHOST:
-		MSG(c, MSG_RDAC_GHOST);
+		c->msgid = CHECKER_MSGID_GHOST;
 		break;
 	}
 
-- 
2.19.1
