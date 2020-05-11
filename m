From: mwilck@suse.com
Subject: [PATCH 05/11] libmultipath: discovery.c: use %z
	qualifier for size_t
Date: Tue, 12 May 2020 00:39:25 +0200
Message-ID: <20200511223931.18261-6-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

Otherwise compilation for 32bit targets spits out warnings.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ee3290cd..ffec5162 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -986,7 +986,7 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 	}
 
 	if (len >= out_len) {
-		condlog(2, "vpd pg80 overflow, %lu/%lu bytes required",
+		condlog(2, "vpd pg80 overflow, %zu/%zu bytes required",
 			len + 1, out_len);
 		len = out_len - 1;
 	}
@@ -1087,7 +1087,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 
 		len = sprintf(out, "%d", vpd_type);
 		if (2 * vpd_len >= out_len - len) {
-			condlog(1, "%s: WWID overflow, type %d, %lu/%lu bytes required",
+			condlog(1, "%s: WWID overflow, type %d, %zu/%zu bytes required",
 				__func__, vpd_type,
 				2 * vpd_len + len + 1, out_len);
 			vpd_len = (out_len - len - 1) / 2;
@@ -1096,7 +1096,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 			len += sprintf(out + len,
 				       "%02x", vpd[i]);
 	} else if (vpd_type == 0x8 && vpd_len < 4) {
-		condlog(1, "%s: VPD length %lu too small for designator type 8",
+		condlog(1, "%s: VPD length %zu too small for designator type 8",
 			__func__, vpd_len);
 		return -EINVAL;
 	} else if (vpd_type == 0x8) {
@@ -1112,7 +1112,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		while (len > 2 && vpd[len - 2] == '\0')
 			--len;
 		if (len > out_len - 1) {
-			condlog(1, "%s: WWID overflow, type 8/%c, %lu/%lu bytes required",
+			condlog(1, "%s: WWID overflow, type 8/%c, %zu/%zu bytes required",
 				__func__, out[0], len + 1, out_len);
 			len = out_len - 1;
 		}
@@ -1136,7 +1136,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		while ((p = memchr(vpd, ' ', vpd_len))) {
 			p_len = p - vpd;
 			if (len + p_len > out_len - 1) {
-				condlog(1, "%s: WWID overflow, type 1, %lu/%lu bytes required",
+				condlog(1, "%s: WWID overflow, type 1, %zu/%zu bytes required",
 					__func__, len + p_len, out_len);
 				p_len = out_len - len - 1;
 			}
@@ -1162,7 +1162,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		p_len = vpd_len;
 		if (p_len > 0 && len < out_len - 1) {
 			if (len + p_len > out_len - 1) {
-				condlog(1, "%s: WWID overflow, type 1, %lu/%lu bytes required",
+				condlog(1, "%s: WWID overflow, type 1, %zu/%zu bytes required",
 					__func__, len + p_len + 1, out_len);
 				p_len = out_len - len - 1;
 			}
@@ -1186,14 +1186,14 @@ parse_vpd_c0_hp3par(const unsigned char *in, size_t in_len,
 
 	memset(out, 0x0, out_len);
 	if (in_len <= 4 || (in[4] > 3 && in_len < 44)) {
-		condlog(3, "HP/3PAR vendor specific VPD page length too short: %lu", in_len);
+		condlog(3, "HP/3PAR vendor specific VPD page length too short: %zu", in_len);
 		return -EINVAL;
 	}
 	if (in[4] <= 3) /* revision must be > 3 to have Vomlume Name */
 		return -ENODATA;
 	len = get_unaligned_be32(&in[40]);
 	if (len > out_len || len + 44 > in_len) {
-		condlog(3, "HP/3PAR vendor specific Volume name too long: %lu",
+		condlog(3, "HP/3PAR vendor specific Volume name too long: %zu",
 			len);
 		return -EINVAL;
 	}
-- 
2.26.2
