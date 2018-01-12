From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/14] libmultipath: sgio_get_vpd: add page
	argument
Date: Fri, 12 Jan 2018 23:07:36 +0100
Message-ID: <20180112220743.11513-8-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

get_vpd_sgio() assumes to be able to send different VPD inquires.
This requires passing the pg argument to sgio_get_vpd().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index da7bf5652a53..cb7fbb54883e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -837,7 +837,7 @@ detect_alua(struct path * pp, struct config *conf)
 #define DEFAULT_SGIO_LEN 254
 
 static int
-sgio_get_vpd (unsigned char * buff, int maxlen, int fd)
+sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 {
 	int len = DEFAULT_SGIO_LEN;
 
@@ -846,7 +846,7 @@ sgio_get_vpd (unsigned char * buff, int maxlen, int fd)
 		return -1;
 	}
 retry:
-	if (0 == do_inq(fd, 0, 1, 0x83, buff, len)) {
+	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
 		len = buff[3] + (buff[2] << 8);
 		if (len >= maxlen)
 			return len;
@@ -1099,7 +1099,7 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 	unsigned char buff[4096];
 
 	memset(buff, 0x0, 4096);
-	if (sgio_get_vpd(buff, 4096, fd) <= 0) {
+	if (sgio_get_vpd(buff, 4096, fd, pg) <= 0) {
 		condlog(3, "failed to issue vpd inquiry for pg%02x",
 			pg);
 		return -errno;
-- 
2.15.1
