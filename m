From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 20/30] libmultipath: parse_vpd_pg83: common code
	for SCSI string parsing
Date: Fri,  7 Jun 2019 15:05:42 +0200
Message-ID: <20190607130552.13203-21-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The three cases for eui, naa, and iqn parsing share almost all code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 54 ++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e484ec8d..32e3f9d3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1023,43 +1023,31 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				len += sprintf(out + len,
 					       "%02x", vpd[i]);
 		} else if (vpd_type == 0x8) {
-			if (!memcmp("eui.", vpd, 4)) {
+			if (!memcmp("eui.", vpd, 4))
 				out[0] =  '2';
-				vpd += 4;
-				len = vpd_len - 4;
-				if (len > out_len - 1) {
-					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
-						__func__, out[0], len + 1, out_len);
-					len = out_len - 1;
-				}
-				for (i = 0; i < len; ++i)
-					out[1 + i] = tolower(vpd[i]);
-				/* designator should be 0-terminated, but let's make sure */
-				out[len] = '\0';
-			} else if (!memcmp("naa.", vpd, 4)) {
+			else if (!memcmp("naa.", vpd, 4))
 				out[0] = '3';
-				vpd += 4;
-				len = vpd_len - 4;
-				if (len > out_len - 1) {
-					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
-						__func__, out[0], len + 1, out_len);
-					len = out_len - 1;
-				}
-				for (i = 0; i < len; ++i)
-					out[1 + i] = tolower(vpd[i]);
-				out[len] = '\0';
-			} else {
+			else
 				out[0] = '8';
-				vpd += 4;
-				len = vpd_len - 4;
-				if (len > out_len - 1) {
-					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
-						__func__, out[0], len + 1, out_len);
-					len = out_len - 1;
-				}
-				memcpy(out + 1, vpd, len);
-				out[len] = '\0';
+
+			vpd += 4;
+			len = vpd_len - 4;
+			if (len > out_len - 1) {
+				condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+					__func__, out[0], len + 1, out_len);
+				len = out_len - 1;
 			}
+
+			if (out[0] == '8')
+				for (i = 0; i < len; ++i)
+					out[1 + i] = vpd[i];
+			else
+				for (i = 0; i < len; ++i)
+					out[1 + i] = tolower(vpd[i]);
+
+			/* designator should be 0-terminated, but let's make sure */
+			out[len] = '\0';
+
 		} else if (vpd_type == 0x1) {
 			const unsigned char *p;
 			int p_len;
-- 
2.21.0
