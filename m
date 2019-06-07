From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/30] libmultipath: fix another WWID overflow in
	parse_vpd_pg83()
Date: Fri,  7 Jun 2019 15:05:39 +0200
Message-ID: <20190607130552.13203-18-mwilck@suse.com>
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

This one is an obvious typo.

Fixes: 18176202e75c "Read wwid from sysfs vpg_pg83 attribute"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index eed35284..10306b22 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1040,7 +1040,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				len = 1;
 				vpd += 4;
 				vpd_len -= 4;
-				if (vpd_len > out_len + 2)
+				if (vpd_len > out_len - 2)
 					vpd_len = out_len - 2;
 				memcpy(out, vpd, vpd_len);
 				len = vpd_len + 1;
-- 
2.21.0
