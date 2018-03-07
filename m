From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/8] libmultipath: Fix sgio_get_vpd()
Date: Thu,  8 Mar 2018 00:15:48 +0100
Message-ID: <20180307231551.15162-6-mwilck@suse.com>
References: <20180307231551.15162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231551.15162-1-mwilck@suse.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

From: Bart Van Assche <bart.vanassche@wdc.com>

Pass the VPD page number to sgio_get_vpd() such that the page needed
by the caller is queried instead of page 0x83. Fix the statement that
computes the length of the page returned by do_inq(). Fix the return
code check in the caller of sgio_get_vpd().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 71c75872c937..23e99f05b406 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -837,6 +837,8 @@ detect_alua(struct path * pp, struct config *conf)
 
 #define DEFAULT_SGIO_LEN 254
 
+/* Query VPD page @pg. Returns number of INQUIRY bytes
+   upon success and -1 upon failure. */
 static int
 sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 {
@@ -848,7 +850,7 @@ sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 	}
 retry:
 	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
-		len = buff[3] + (buff[2] << 8);
+		len = buff[3] + (buff[2] << 8) + 4;
 		if (len >= maxlen)
 			return len;
 		if (len > DEFAULT_SGIO_LEN)
@@ -1100,7 +1102,7 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 	unsigned char buff[4096];
 
 	memset(buff, 0x0, 4096);
-	if (sgio_get_vpd(buff, 4096, fd, pg) <= 0) {
+	if (sgio_get_vpd(buff, 4096, fd, pg) < 0) {
 		condlog(3, "failed to issue vpd inquiry for pg%02x",
 			pg);
 		return -errno;
-- 
2.16.1
