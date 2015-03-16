From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 69/78] Separate out vpd parsing functions
Date: Mon, 16 Mar 2015 13:36:56 +0100
Message-ID: <1426509425-15978-70-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 367 +++++++++++++++++++++++++----------------------
 1 file changed, 193 insertions(+), 174 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8e6b228..50444db 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -811,9 +811,196 @@ get_geometry(struct path *pp)
 }
 
 static int
+parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
+{
+	char *p = NULL;
+	int len = in[3] + (in[2] << 8);
+
+	if (len >= out_len) {
+		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
+			len, (int)out_len);
+		len = out_len;
+	}
+	if (len > 0) {
+		memcpy(out, in + 4, len);
+		out[len] = '\0';
+	}
+	/*
+	 * Strip trailing whitspaces
+	 */
+	p = out + len - 1;
+	while (p > out && *p == ' ') {
+		*p = '\0';
+		p--;
+		len --;
+	}
+	return len;
+}
+
+static int
+parse_vpd_pg83(const unsigned char *in, size_t in_len,
+	       char *out, size_t out_len)
+{
+	unsigned char *d;
+	unsigned char *vpd = NULL;
+	int len = -ENODATA, vpd_type, vpd_len, prio = -1, i, naa_prio;
+
+	d = (unsigned char *)in + 4;
+	while (d < (unsigned char *)in + in_len) {
+		/* Select 'association: LUN' */
+		if ((d[1] & 0x30) != 0) {
+			d += d[3] + 4;
+			continue;
+		}
+		switch (d[1] & 0xf) {
+		case 0x3:
+			/* NAA: Prio 5 */
+			switch (d[4] >> 4) {
+			case 6:
+				/* IEEE Registered Extended: Prio 8 */
+				naa_prio = 8;
+				break;
+			case 5:
+				/* IEEE Registered: Prio 7 */
+				naa_prio = 7;
+				break;
+			case 2:
+				/* IEEE Extended: Prio 6 */
+				naa_prio = 6;
+				break;
+			case 3:
+				/* IEEE Locally assigned: Prio 1 */
+				naa_prio = 1;
+				break;
+			default:
+				/* Default: no priority */
+				naa_prio = -1;
+				break;
+			}
+			if (prio < naa_prio) {
+				prio = naa_prio;
+				vpd = d;
+			}
+			break;
+		case 0x8:
+			/* SCSI Name: Prio 4 */
+			if (memcmp(d + 4, "eui.", 4) &&
+			    memcmp(d + 4, "naa.", 4) &&
+			    memcmp(d + 4, "iqn.", 4))
+				continue;
+			if (prio < 4) {
+				prio = 4;
+				vpd = d;
+			}
+			break;
+		case 0x2:
+			/* EUI-64: Prio 3 */
+			if (prio < 3) {
+				prio = 3;
+				vpd = d;
+			}
+			break;
+		case 0x1:
+			/* T-10 Vendor ID: Prio 2 */
+			if (prio < 2) {
+				prio = 2;
+				vpd = d;
+			}
+			break;
+		}
+		d += d[3] + 4;
+	}
+	if (prio > 0) {
+		vpd_type = vpd[1] & 0xf;
+		vpd_len = vpd[3];
+		vpd += 4;
+		if (vpd_type == 0x2 || vpd_type == 0x3) {
+			int i;
+
+			len = sprintf(out, "%d", vpd_type);
+			for (i = 0; i < vpd_len; i++) {
+				len += sprintf(out + len,
+					       "%02x", vpd[i]);
+				if (len >= out_len)
+					break;
+			}
+		} else if (vpd_type == 0x8) {
+			if (!memcmp("eui.", vpd, 4)) {
+				out[0] =  '2';
+				len = 1;
+				vpd += 4;
+				vpd_len -= 4;
+				for (i = 0; i < vpd_len; i++) {
+					len += sprintf(out + len, "%c",
+						       tolower(vpd[i]));
+					if (len >= out_len)
+						break;
+				}
+				len = vpd_len + 1;
+				out[len] = '\0';
+			} else if (!memcmp("naa.", vpd, 4)) {
+				out[0] = '3';
+				len = 1;
+				vpd += 4;
+				vpd_len -= 4;
+				for (i = 0; i < vpd_len; i++) {
+					len += sprintf(out + len, "%c",
+						       tolower(vpd[i]));
+					if (len >= out_len)
+						break;
+				}
+				len = vpd_len + 1;
+				out[len] = '\0';
+			} else {
+				out[0] = '8';
+				len = 1;
+				vpd += 4;
+				vpd_len -= 4;
+				if (vpd_len > out_len + 2)
+					vpd_len = out_len - 2;
+				memcpy(out, vpd, vpd_len);
+				len = vpd_len + 1;
+				out[len] = '\0';
+			}
+		} else if (vpd_type == 0x1) {
+			unsigned char *p;
+			int p_len;
+
+			out[0] = '1';
+			len = 1;
+			p = vpd;
+			while ((p = memchr(vpd, ' ', vpd_len))) {
+				p_len = p - vpd;
+				if (len + p_len > out_len - 1)
+					p_len = out_len - len - 2;
+				memcpy(out + len, vpd, p_len);
+				len += p_len;
+				if (len >= out_len - 1) {
+					out[len] = '\0';
+					break;
+				}
+				out[len] = '_';
+				len ++;
+				vpd = p;
+				vpd_len -= p_len;
+				while (vpd && *vpd == ' ') {
+					vpd++;
+					vpd_len --;
+				}
+			}
+			if (len > 1 && out[len - 1] == '_') {
+				out[len - 1] = '\0';
+				len--;
+			}
+		}
+	}
+	return len;
+}
+
+static int
 get_vpd (struct udev_device *parent, int fd, int pg, char * str, int maxlen)
 {
-	int len = -ENODATA, buff_len;
+	int len, buff_len;
 	unsigned char buff[4096];
 
 	memset(buff, 0x0, 4096);
@@ -835,179 +1022,11 @@ get_vpd (struct udev_device *parent, int fd, int pg, char * str, int maxlen)
 	if (buff_len > 4096)
 		condlog(3, "vpd pg%02x page truncated", pg);
 
-	if (pg == 0x80) {
-		char *p = NULL;
-		len = buff[3] + (buff[2] << 8);
-		if (len >= maxlen) {
-			condlog(3, "vpd pg%02x overflow, %d/%d bytes required",
-				pg, len, maxlen);
-			return -EINVAL;
-		}
-		if (len > 0) {
-			memcpy(str, buff + 4, len);
-			str[len] = '\0';
-		}
-		p = str + len - 1;
-		while (p > str && *p == ' ') {
-			*p = '\0';
-			p--;
-			len --;
-		}
-	} else if (pg == 0x83) {
-		unsigned char *d;
-		unsigned char *vpd = NULL;
-		int vpd_type, vpd_len, prio = -1, i, naa_prio;
-
-		d = (unsigned char *)buff + 4;
-		while (d < (unsigned char *)buff + buff_len) {
-			/* Select 'association: LUN' */
-			if ((d[1] & 0x30) != 0) {
-				d += d[3] + 4;
-				continue;
-			}
-			switch (d[1] & 0xf) {
-			case 0x3:
-				/* NAA: Prio 5 */
-				switch (d[4] >> 4) {
-				case 6:
-					/* IEEE Registered Extended: Prio 8 */
-					naa_prio = 8;
-					break;
-				case 5:
-					/* IEEE Registered: Prio 7 */
-					naa_prio = 7;
-					break;
-				case 2:
-					/* IEEE Extended: Prio 6 */
-					naa_prio = 6;
-					break;
-				case 3:
-					/* IEEE Locally assigned: Prio 1 */
-					naa_prio = 1;
-					break;
-				default:
-					/* Default: no priority */
-					naa_prio = -1;
-					break;
-				}
-				if (prio < naa_prio) {
-					prio = naa_prio;
-					vpd = d;
-				}
-				break;
-			case 0x8:
-				/* SCSI Name: Prio 4 */
-				if (memcmp(d + 4, "eui.", 4) &&
-				    memcmp(d + 4, "naa.", 4) &&
-				    memcmp(d + 4, "iqn.", 4))
-					continue;
-				if (prio < 4) {
-					prio = 4;
-					vpd = d;
-				}
-				break;
-			case 0x2:
-				/* EUI-64: Prio 3 */
-				if (prio < 3) {
-					prio = 3;
-					vpd = d;
-				}
-				break;
-			case 0x1:
-				/* T-10 Vendor ID: Prio 2 */
-				if (prio < 2) {
-					prio = 2;
-					vpd = d;
-				}
-				break;
-			}
-			d += d[3] + 4;
-		}
-		if (prio > 0) {
-			vpd_type = vpd[1] & 0xf;
-			vpd_len = vpd[3];
-			vpd += 4;
-			if (vpd_type == 0x2 || vpd_type == 0x3) {
-				int i;
-
-				len = sprintf(str, "%d", vpd_type);
-				for (i = 0; i < vpd_len; i++) {
-					len += sprintf(str + len,
-						       "%02x", vpd[i]);
-					if (len >= maxlen)
-						break;
-				}
-			} else if (vpd_type == 0x8) {
-				if (!memcmp("eui.", vpd, 4)) {
-					str[0] =  '2';
-					len = 1;
-					vpd += 4;
-					vpd_len -= 4;
-					for (i = 0; i < vpd_len; i++) {
-						len += sprintf(str + len, "%c",
-							       tolower(vpd[i]));
-						if (len >= maxlen)
-							break;
-					}
-					len = vpd_len + 1;
-					str[len] = '\0';
-				} else if (!memcmp("naa.", vpd, 4)) {
-					str[0] = '3';
-					len = 1;
-					vpd += 4;
-					vpd_len -= 4;
-					for (i = 0; i < vpd_len; i++) {
-						len += sprintf(str + len, "%c",
-							       tolower(vpd[i]));
-						if (len >= maxlen)
-							break;
-					}
-					len = vpd_len + 1;
-					str[len] = '\0';
-				} else {
-					str[0] = '8';
-					len = 1;
-					vpd += 4;
-					vpd_len -= 4;
-					if (vpd_len > maxlen + 2)
-						vpd_len = maxlen - 2;
-					memcpy(str, vpd, vpd_len);
-					len = vpd_len + 1;
-					str[len] = '\0';
-				}
-			} else if (vpd_type == 0x1) {
-				unsigned char *p;
-				int p_len;
-
-				str[0] = '1';
-				len = 1;
-				p = vpd;
-				while ((p = memchr(vpd, ' ', vpd_len))) {
-					p_len = p - vpd;
-					if (len + p_len > maxlen - 1)
-						p_len = maxlen - len - 2;
-					memcpy(str + len, vpd, p_len);
-					len += p_len;
-					if (len >= maxlen - 1) {
-						str[len] = '\0';
-						break;
-					}
-					str[len] = '_';
-					len ++;
-					vpd = p;
-					vpd_len -= p_len;
-					while (vpd && *vpd == ' ') {
-						vpd++;
-						vpd_len --;
-					}
-				}
-				if (len > 1 && str[len - 1] == '_') {
-					str[len - 1] = '\0';
-					len--;
-				}
-			}
-		}
-	} else
+	if (pg == 0x80)
+		len = parse_vpd_pg80(buff, str, maxlen);
+	else if (pg == 0x83)
+		len = parse_vpd_pg83(buff, buff_len, str, maxlen);
+	else
 		len = -ENOSYS;
 
 	return len;
-- 
1.8.4.5
