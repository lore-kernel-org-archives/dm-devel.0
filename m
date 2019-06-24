From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/30] libmultipath: parse_vpd_pg80: fix
	overflow output
Date: Mon, 24 Jun 2019 11:27:49 +0200
Message-ID: <20190624092756.7769-25-mwilck@suse.com>
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

"vpd pg80 overflow, 20/20 bytes required" looks weird. Make it clear
that actually 21 bytes are required in this case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index efcea468..931a676f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -912,7 +912,7 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 
 	if (len >= out_len) {
 		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
-			len, (int)out_len);
+			len + 1, (int)out_len);
 		len = out_len - 1;
 	}
 	if (len > 0) {
-- 
2.21.0
