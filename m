From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 46/72] libmultipath: parse_vpd_pg83(): sanitize
	indentation
Date: Sat, 12 Oct 2019 21:28:34 +0000
Message-ID: <20191012212703.12989-47-martin.wilck@suse.com>
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

This just moves a lot of code to the left. No functional change.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 174 ++++++++++++++++++++-------------------
 1 file changed, 88 insertions(+), 86 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c6c57430..0d0a6bc1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1045,100 +1045,102 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		}
 		d += d[3] + 4;
 	}
-	if (prio > 0) {
-		vpd_type = vpd[1] & 0xf;
-		vpd_len = vpd[3];
+
+	if (prio <= 0)
+		return -ENODATA;
+
+	vpd_type = vpd[1] & 0xf;
+	vpd_len = vpd[3];
+	vpd += 4;
+	if (vpd_type == 0x2 || vpd_type == 0x3) {
+		int i;
+
+		assert(out_len >= 2);
+		len = sprintf(out, "%d", vpd_type);
+		if (2 * vpd_len >= out_len - len) {
+			condlog(1, "%s: WWID overflow, type %d, %d/%lu bytes required",
+				__func__, vpd_type,
+				2 * vpd_len + len + 1, out_len);
+			vpd_len = (out_len - len - 1) / 2;
+		}
+		for (i = 0; i < vpd_len; i++)
+			len += sprintf(out + len,
+				       "%02x", vpd[i]);
+	} else if (vpd_type == 0x8) {
+		if (!memcmp("eui.", vpd, 4))
+			out[0] =  '2';
+		else if (!memcmp("naa.", vpd, 4))
+			out[0] = '3';
+		else
+			out[0] = '8';
+
 		vpd += 4;
-		if (vpd_type == 0x2 || vpd_type == 0x3) {
-			int i;
-
-			assert(out_len >= 2);
-			len = sprintf(out, "%d", vpd_type);
-			if (2 * vpd_len >= out_len - len) {
-				condlog(1, "%s: WWID overflow, type %d, %d/%lu bytes required",
-					__func__, vpd_type,
-					2 * vpd_len + len + 1, out_len);
-				vpd_len = (out_len - len - 1) / 2;
-			}
-			for (i = 0; i < vpd_len; i++)
-				len += sprintf(out + len,
-					       "%02x", vpd[i]);
-		} else if (vpd_type == 0x8) {
-			if (!memcmp("eui.", vpd, 4))
-				out[0] =  '2';
-			else if (!memcmp("naa.", vpd, 4))
-				out[0] = '3';
-			else
-				out[0] = '8';
-
-			vpd += 4;
-			len = vpd_len - 4;
-			while (len > 2 && vpd[len - 2] == '\0')
-				--len;
-			if (len > out_len - 1) {
-				condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
-					__func__, out[0], len + 1, out_len);
-				len = out_len - 1;
-			}
+		len = vpd_len - 4;
+		while (len > 2 && vpd[len - 2] == '\0')
+			--len;
+		if (len > out_len - 1) {
+			condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
+				__func__, out[0], len + 1, out_len);
+			len = out_len - 1;
+		}
 
-			if (out[0] == '8')
-				for (i = 0; i < len; ++i)
-					out[1 + i] = vpd[i];
-			else
-				for (i = 0; i < len; ++i)
-					out[1 + i] = tolower(vpd[i]);
+		if (out[0] == '8')
+			for (i = 0; i < len; ++i)
+				out[1 + i] = vpd[i];
+		else
+			for (i = 0; i < len; ++i)
+				out[1 + i] = tolower(vpd[i]);
 
-			/* designator should be 0-terminated, but let's make sure */
-			out[len] = '\0';
+		/* designator should be 0-terminated, but let's make sure */
+		out[len] = '\0';
 
-		} else if (vpd_type == 0x1) {
-			const unsigned char *p;
-			int p_len;
-
-			out[0] = '1';
-			len = 1;
-			p = vpd;
-			while ((p = memchr(vpd, ' ', vpd_len))) {
-				p_len = p - vpd;
-				if (len + p_len > out_len - 1) {
-					condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
-						__func__, len + p_len, out_len);
-					p_len = out_len - len - 1;
-				}
-				memcpy(out + len, vpd, p_len);
-				len += p_len;
-				if (len >= out_len - 1) {
-					out[len] = '\0';
-					break;
-				}
-				out[len] = '_';
-				len ++;
-				if (len >= out_len - 1) {
-					out[len] = '\0';
-					break;
-				}
-				vpd = p;
-				vpd_len -= p_len;
-				while (vpd && *vpd == ' ') {
-					vpd++;
-					vpd_len --;
-				}
+	} else if (vpd_type == 0x1) {
+		const unsigned char *p;
+		int p_len;
+
+		out[0] = '1';
+		len = 1;
+		p = vpd;
+		while ((p = memchr(vpd, ' ', vpd_len))) {
+			p_len = p - vpd;
+			if (len + p_len > out_len - 1) {
+				condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+					__func__, len + p_len, out_len);
+				p_len = out_len - len - 1;
 			}
-			p_len = vpd_len;
-			if (p_len > 0 && len < out_len - 1) {
-				if (len + p_len > out_len - 1) {
-					condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
-						__func__, len + p_len + 1, out_len);
-					p_len = out_len - len - 1;
-				}
-				memcpy(out + len, vpd, p_len);
-				len += p_len;
+			memcpy(out + len, vpd, p_len);
+			len += p_len;
+			if (len >= out_len - 1) {
 				out[len] = '\0';
+				break;
 			}
-			if (len > 1 && out[len - 1] == '_') {
-				out[len - 1] = '\0';
-				len--;
+			out[len] = '_';
+			len ++;
+			if (len >= out_len - 1) {
+				out[len] = '\0';
+				break;
 			}
+			vpd = p;
+			vpd_len -= p_len;
+			while (vpd && *vpd == ' ') {
+				vpd++;
+				vpd_len --;
+			}
+		}
+		p_len = vpd_len;
+		if (p_len > 0 && len < out_len - 1) {
+			if (len + p_len > out_len - 1) {
+				condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+					__func__, len + p_len + 1, out_len);
+				p_len = out_len - len - 1;
+			}
+			memcpy(out + len, vpd, p_len);
+			len += p_len;
+			out[len] = '\0';
+		}
+		if (len > 1 && out[len - 1] == '_') {
+			out[len - 1] = '\0';
+			len--;
 		}
 	}
 	return len;
-- 
2.23.0
