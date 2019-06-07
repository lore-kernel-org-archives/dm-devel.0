From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 15/30] libmultipath: Fix buffer overflow in
	parse_vpd_pg80()
Date: Fri,  7 Jun 2019 15:05:37 +0200
Message-ID: <20190607130552.13203-16-mwilck@suse.com>
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

We set out[len] = '\0' later, thus we should set len to no more then
out_len - 1.

Fixes: 756ef73b7197 "Separate out vpd parsing functions"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f360e306..89c4d2ad 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -913,7 +913,7 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 	if (len >= out_len) {
 		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
 			len, (int)out_len);
-		len = out_len;
+		len = out_len - 1;
 	}
 	if (len > 0) {
 		memcpy(out, in + 4, len);
-- 
2.21.0
