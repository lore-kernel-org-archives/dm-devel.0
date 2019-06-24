From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/30] libmultipath: fix possible WWID
	overflow in parse_vpd_pg83()
Date: Mon, 24 Jun 2019 11:27:42 +0200
Message-ID: <20190624092756.7769-18-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We have to check the remaining length before printing to the
output buffer, not afterwards.

Fixes: 18176202e75c "Read wwid from sysfs vpg_pg83 attribute"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 89c4d2ad..eed35284 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1012,11 +1012,9 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 			int i;
 
 			len = sprintf(out, "%d", vpd_type);
-			for (i = 0; i < vpd_len; i++) {
+			for (i = 0; i < vpd_len && len < out_len - 2; i++) {
 				len += sprintf(out + len,
 					       "%02x", vpd[i]);
-				if (len >= out_len)
-					break;
 			}
 		} else if (vpd_type == 0x8) {
 			if (!memcmp("eui.", vpd, 4)) {
@@ -1024,27 +1022,19 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				len = 1;
 				vpd += 4;
 				vpd_len -= 4;
-				for (i = 0; i < vpd_len; i++) {
+				for (i = 0; i < vpd_len && len < out_len - 1; i++) {
 					len += sprintf(out + len, "%c",
 						       tolower(vpd[i]));
-					if (len >= out_len)
-						break;
 				}
-				len = vpd_len + 1;
-				out[len] = '\0';
 			} else if (!memcmp("naa.", vpd, 4)) {
 				out[0] = '3';
 				len = 1;
 				vpd += 4;
 				vpd_len -= 4;
-				for (i = 0; i < vpd_len; i++) {
+				for (i = 0; i < vpd_len && len < out_len - 1; i++) {
 					len += sprintf(out + len, "%c",
 						       tolower(vpd[i]));
-					if (len >= out_len)
-						break;
 				}
-				len = vpd_len + 1;
-				out[len] = '\0';
 			} else {
 				out[0] = '8';
 				len = 1;
-- 
2.21.0
