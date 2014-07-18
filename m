From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/5] libmultipath: Accept "*" as a valid regular
	expression
Date: Fri, 18 Jul 2014 14:54:52 +0200
Message-ID: <53C9191C.4070705@acm.org>
References: <53C91871.9070402@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C91871.9070402@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Inside libmultipath regcomp() is used to compile regular expressions
specified in /etc/multipath.conf. Many multipath.conf examples contain
'product_type "*"'. However, "*" is not a valid POSIX regular expression.
Hence this patch that changes the regular expression "*" into ".*".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/blacklist.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 651bd7e..e5c287e 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -63,6 +63,13 @@ alloc_ble_device (vector blist)
 	return 0;
 }
 
+static int lm_regcomp(regex_t *preg, const char *pattern, int cflags)
+{
+	if (strcmp(pattern, "*") == 0)
+		pattern = ".*";
+	return regcomp(preg, pattern, cflags);
+}
+
 extern int
 set_ble_device (vector blist, char * vendor, char * product, int origin)
 {
@@ -77,16 +84,16 @@ set_ble_device (vector blist, char * vendor, char * product, int origin)
 		return 1;
 
 	if (vendor) {
-		if (regcomp(&ble->vendor_reg, vendor,
-			    REG_EXTENDED|REG_NOSUB)) {
+		if (lm_regcomp(&ble->vendor_reg, vendor,
+			       REG_EXTENDED|REG_NOSUB)) {
 			FREE(vendor);
 			return 1;
 		}
 		ble->vendor = vendor;
 	}
 	if (product) {
-		if (regcomp(&ble->product_reg, product,
-			    REG_EXTENDED|REG_NOSUB)) {
+		if (lm_regcomp(&ble->product_reg, product,
+			       REG_EXTENDED|REG_NOSUB)) {
 			FREE(product);
 			return 1;
 		}
-- 
1.8.4.5
