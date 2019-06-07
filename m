From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/30] libmultipath: add consistent WWID overflow
	logging in parse_vpd_pg83
Date: Fri,  7 Jun 2019 15:05:41 +0200
Message-ID: <20190607130552.13203-20-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 49 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 45c2931e..e484ec8d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1011,38 +1011,53 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		if (vpd_type == 0x2 || vpd_type == 0x3) {
 			int i;
 
+			assert(out_len >= 2);
 			len = sprintf(out, "%d", vpd_type);
-			for (i = 0; i < vpd_len && len < out_len - 2; i++) {
+			if (2 * vpd_len >= out_len - len) {
+				condlog(1, "%s: WWID overflow, type %d, %d/%lu bytes required",
+					__func__, vpd_type,
+					2 * vpd_len + len + 1, out_len);
+				vpd_len = (out_len - len - 1) / 2;
+			}
+			for (i = 0; i < vpd_len; i++)
 				len += sprintf(out + len,
 					       "%02x", vpd[i]);
-			}
 		} else if (vpd_type == 0x8) {
 			if (!memcmp("eui.", vpd, 4)) {
 				out[0] =  '2';
-				len = 1;
 				vpd += 4;
-				vpd_len -= 4;
-				for (i = 0; i < vpd_len && len < out_len - 1; i++) {
-					len += sprintf(out + len, "%c",
-						       tolower(vpd[i]));
+				len = vpd_len - 4;
+				if (len > out_len - 1) {
+					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+						__func__, out[0], len + 1, out_len);
+					len = out_len - 1;
 				}
+				for (i = 0; i < len; ++i)
+					out[1 + i] = tolower(vpd[i]);
+				/* designator should be 0-terminated, but let's make sure */
+				out[len] = '\0';
 			} else if (!memcmp("naa.", vpd, 4)) {
 				out[0] = '3';
-				len = 1;
 				vpd += 4;
-				vpd_len -= 4;
-				for (i = 0; i < vpd_len && len < out_len - 1; i++) {
-					len += sprintf(out + len, "%c",
-						       tolower(vpd[i]));
+				len = vpd_len - 4;
+				if (len > out_len - 1) {
+					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+						__func__, out[0], len + 1, out_len);
+					len = out_len - 1;
 				}
+				for (i = 0; i < len; ++i)
+					out[1 + i] = tolower(vpd[i]);
+				out[len] = '\0';
 			} else {
 				out[0] = '8';
 				vpd += 4;
-				vpd_len -= 4;
-				if (vpd_len > out_len - 2)
-					vpd_len = out_len - 2;
-				memcpy(out + 1, vpd, vpd_len);
-				len = vpd_len + 1;
+				len = vpd_len - 4;
+				if (len > out_len - 1) {
+					condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+						__func__, out[0], len + 1, out_len);
+					len = out_len - 1;
+				}
+				memcpy(out + 1, vpd, len);
 				out[len] = '\0';
 			}
 		} else if (vpd_type == 0x1) {
-- 
2.21.0
