From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 21/30] libmultipath: allow zero-padded SCSI names
	in parse_vpd_pg83()
Date: Fri,  7 Jun 2019 15:05:43 +0200
Message-ID: <20190607130552.13203-22-mwilck@suse.com>
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

The spec says that SCSI name strings designator length must be a multiple of
4, and that strings must be zero-terminated and zero-padded.
Fix the returned string length if the VPD input ends with multiple 0-bytes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 32e3f9d3..3558e559 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1032,6 +1032,8 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 
 			vpd += 4;
 			len = vpd_len - 4;
+			while (len > 2 && vpd[len - 2] == '\0')
+				--len;
 			if (len > out_len - 1) {
 				condlog(1, "%s: WWID overflow, type 8/%c, %d/%lu bytes required",
 					__func__, out[0], len + 1, out_len);
-- 
2.21.0
