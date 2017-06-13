From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/4] libmultipath/datacore: Remove dead code
Date: Tue, 13 Jun 2017 09:33:38 -0700
Message-ID: <20170613163339.23005-4-bart.vanassche@sandisk.com>
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

Remove those variables a value is assigned to but that are never
used. This patch avoids that gcc 7 reports the following warning:

datacore.c:98:22: warning: '
   ' directive output may be truncated writing 1 byte into a region of size between 0 and 8 [-Wformat-truncation=]
  snprintf(vendor, 8, "%.8s\n", inqBuffp + 8);

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/prioritizers/datacore.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 36465ac4..59c98164 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -35,10 +35,6 @@
 int datacore_prio (const char *dev, int sg_fd, char * args)
 {
 	int k;
-	char vendor[8];
-	char product[32];
-	char luname[32];
-	char wwpn[32];
 	char sdsname[32];
 	unsigned char inqCmdBlk[INQ_CMD_LEN] = { INQ_CMD_CODE, 0, 0, 0, INQ_REPLY_LEN, 0 };
 	unsigned char inqBuff[INQ_REPLY_LEN];
@@ -95,11 +91,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	if ((io_hdr.info & SG_INFO_OK_MASK) != SG_INFO_OK)
 		return 0;
 
-	snprintf(vendor, 8, "%.8s\n", inqBuffp + 8);
-	snprintf(product, 17, "%.16s", inqBuffp + 16);
-	snprintf(luname, 21, "%.19s", inqBuffp + 36);
-	snprintf(wwpn, 17, "%.16s", inqBuffp + 96);
-	snprintf(sdsname, 17, "%.16s", inqBuffp + 112);
+	snprintf(sdsname, sizeof(sdsname), "%.16s", inqBuffp + 112);
 
 	if (strstr(sdsname , preferredsds))
 		return 1;
-- 
2.12.2
