From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 22/30] libmultipath: fix parsing of
	non-space-terminated T10 ID
Date: Mon, 24 Jun 2019 11:27:48 +0200
Message-ID: <20190624092756.7769-24-mwilck@suse.com>
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

If the T10 vendor specific ID doesn't end with spaces, the last
part won't be parsed. Fix it.

Fixes: 18176202e75c "Read wwid from sysfs vpg_pg83 attribute"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3558e559..efcea468 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1083,6 +1083,17 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 					vpd_len --;
 				}
 			}
+			p_len = vpd_len;
+			if (p_len > 0 && len < out_len - 1) {
+				if (len + p_len > out_len - 1) {
+					condlog(1, "%s: WWID overflow, type 1, %d/%lu bytes required",
+						__func__, len + p_len + 1, out_len);
+					p_len = out_len - len - 1;
+				}
+				memcpy(out + len, vpd, p_len);
+				len += p_len;
+				out[len] = '\0';
+			}
 			if (len > 1 && out[len - 1] == '_') {
 				out[len - 1] = '\0';
 				len--;
-- 
2.21.0
