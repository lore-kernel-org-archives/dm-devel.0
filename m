From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 47/72] libmultipath: parse_vpd_pg83(): fix
 -Wsign-compare warnings
Date: Sat, 12 Oct 2019 21:28:35 +0000
Message-ID: <20191012212703.12989-48-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Most of this is trivial. Changes are: return early if there
is obviously not enough space. Check vpd_len for designator
type 8.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0d0a6bc1..6288c3e0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -978,7 +978,8 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 {
 	const unsigned char *d;
 	const unsigned char *vpd = NULL;
-	int len = -ENODATA, vpd_type, vpd_len, prio = -1, i, naa_prio;
+	size_t len, vpd_len, i;
+	int vpd_type, prio = -1, naa_prio;
 
 	d = in + 4;
 	while (d < in + in_len) {
@@ -1048,17 +1049,20 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 
 	if (prio <= 0)
 		return -ENODATA;
+	/* Need space at least for one digit */
+	else if (out_len <= 1)
+		return 0;
 
+	len = 0;
 	vpd_type = vpd[1] & 0xf;
 	vpd_len = vpd[3];
 	vpd += 4;
 	if (vpd_type == 0x2 || vpd_type == 0x3) {
-		int i;
+		size_t i;
 
-		assert(out_len >= 2);
 		len = sprintf(out, "%d", vpd_type);
 		if (2 * vpd_len >= out_len - len) {
-			condlog(1, "%s: WWID overflow, type %d, %d/%lu bytes required",
+			condlog(1, "%s: WWID overflow, type %d, %lu/%lu bytes required",
 				__func__, vpd_type,
 				2 * vpd_len + len + 1, out_len);
 			vpd_len = (out_len - len - 1) / 2;
@@ -1066,6 +1070,10 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		for (i = 0; i < vpd_len; i++)
 			len += sprintf(out + len,
 				       "%02x", vpd[i]);
+	} else if (vpd_type == 0x8 && vpd_len < 4) {
+		condlog(1, "%s: VPD length %lu too small for designator type 8",
+			__func__, vpd_len);
+		return -EINVAL;
 	} else if (vpd_type == 0x8) {
 		if (!memcmp("eui.", vpd, 4))
 			out[0] =  '2';
@@ -1079,7 +1087,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		while (len > 2 && vpd[len - 2] == '\0')
 			--len;
 		if (len > out_len - 1) {
-			condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+			condlog(1, "%s: WWID overflow, type 8/%c, %lu/%lu bytes required",
 				__func__, out[0], len + 1, out_len);
 			len = out_len - 1;
 		}
@@ -1096,15 +1104,14 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 
 	} else if (vpd_type == 0x1) {
 		const unsigned char *p;
-		int p_len;
+		size_t p_len;
 
 		out[0] = '1';
 		len = 1;
-		p = vpd;
 		while ((p = memchr(vpd, ' ', vpd_len))) {
 			p_len = p - vpd;
 			if (len + p_len > out_len - 1) {
-				condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+				condlog(1, "%s: WWID overflow, type 1, %lu/%lu bytes required",
 					__func__, len + p_len, out_len);
 				p_len = out_len - len - 1;
 			}
@@ -1130,7 +1137,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		p_len = vpd_len;
 		if (p_len > 0 && len < out_len - 1) {
 			if (len + p_len > out_len - 1) {
-				condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+				condlog(1, "%s: WWID overflow, type 1, %lu/%lu bytes required",
 					__func__, len + p_len + 1, out_len);
 				p_len = out_len - len - 1;
 			}
-- 
2.23.0
