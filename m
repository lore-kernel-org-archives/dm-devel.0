From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 24/30] libmultipath: parse_vpd_pg80: fix
	whitespace handling
Date: Fri,  7 Jun 2019 15:05:46 +0200
Message-ID: <20190607130552.13203-25-mwilck@suse.com>
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

According to the SPC spec, the unit serial number is right-aligned
ASCII. Thus leading whitespace must be skipped. Moreover, trailing
whitespace should be discarded before doing the length check.

Fixes: 756ef73b7197 "Separate out vpd parsing functions"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 931a676f..b10afdef 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -907,9 +907,18 @@ get_geometry(struct path *pp)
 static int
 parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 {
-	char *p = NULL;
 	int len = get_unaligned_be16(&in[2]);
 
+	/*
+	 * Strip leading and trailing whitespace
+	 */
+	while (len > 0 && in[len + 3] == ' ')
+		--len;
+	while (len > 0 && in[4] == ' ') {
+		++in;
+		--len;
+	}
+
 	if (len >= out_len) {
 		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
 			len + 1, (int)out_len);
@@ -919,15 +928,6 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 		memcpy(out, in + 4, len);
 		out[len] = '\0';
 	}
-	/*
-	 * Strip trailing whitspaces
-	 */
-	p = out + len - 1;
-	while (p > out && *p == ' ') {
-		*p = '\0';
-		p--;
-		len --;
-	}
 	return len;
 }
 
-- 
2.21.0
