From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/30] libmultipath: fix parsing of VPD 83
	type 1 (T10 vendor ID)
Date: Mon, 24 Jun 2019 11:27:40 +0200
Message-ID: <20190624092756.7769-16-mwilck@suse.com>
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

In the buffer overflow case, the code would set p_len = out_len - len - 2,
then len = len + plen = out_len - 2, and check if len >= out_len - 1,
which is never the case. Rather, set p_len = out_len - len -1, and
check the length again before appending the underscore.

Fixes: 18176202e75c "Read wwid from sysfs vpg_pg83 attribute"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 407e64a0..f360e306 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1065,8 +1065,11 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 			p = vpd;
 			while ((p = memchr(vpd, ' ', vpd_len))) {
 				p_len = p - vpd;
-				if (len + p_len > out_len - 1)
-					p_len = out_len - len - 2;
+				if (len + p_len > out_len - 1) {
+					condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+						__func__, len + p_len, out_len);
+					p_len = out_len - len - 1;
+				}
 				memcpy(out + len, vpd, p_len);
 				len += p_len;
 				if (len >= out_len - 1) {
@@ -1075,6 +1078,10 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				}
 				out[len] = '_';
 				len ++;
+				if (len >= out_len - 1) {
+					out[len] = '\0';
+					break;
+				}
 				vpd = p;
 				vpd_len -= p_len;
 				while (vpd && *vpd == ' ') {
-- 
2.21.0
