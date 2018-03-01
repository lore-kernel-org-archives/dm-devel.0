From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 5/6] libmultipath: Fix sgio_get_vpd()
Date: Thu,  1 Mar 2018 11:29:34 -0800
Message-ID: <20180301192935.14643-6-bart.vanassche@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Pass the VPD page number to sgio_get_vpd() such that the page needed
by the caller is queried instead of page 0x83. Fix the statement that
computes the length of the page returned by do_inq(). Fix the return
code check in the caller of sgio_get_vpd().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 libmultipath/discovery.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d84715e15db1..780feb253797 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -836,8 +836,9 @@ detect_alua(struct path * pp, struct config *conf)
 
 #define DEFAULT_SGIO_LEN 254
 
+/* Query VPD page @pg. Returns 0 upon success and -1 upon failure. */
 static int
-sgio_get_vpd (unsigned char * buff, int maxlen, int fd)
+sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 {
 	int len = DEFAULT_SGIO_LEN;
 
@@ -846,8 +847,8 @@ sgio_get_vpd (unsigned char * buff, int maxlen, int fd)
 		return -1;
 	}
 retry:
-	if (0 == do_inq(fd, 0, 1, 0x83, buff, len)) {
-		len = buff[3] + (buff[2] << 8);
+	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
+		len = buff[3] + (buff[2] << 8) + 4;
 		if (len >= maxlen)
 			return len;
 		if (len > DEFAULT_SGIO_LEN)
@@ -1099,7 +1100,7 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 	unsigned char buff[4096];
 
 	memset(buff, 0x0, 4096);
-	if (sgio_get_vpd(buff, 4096, fd) <= 0) {
+	if (sgio_get_vpd(buff, 4096, fd, pg) < 0) {
 		condlog(3, "failed to issue vpd inquiry for pg%02x",
 			pg);
 		return -errno;
-- 
2.16.2
