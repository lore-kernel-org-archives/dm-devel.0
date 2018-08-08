From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 07/17] libmultipath: fix length issues in
	get_vpd_sgio
Date: Wed,  8 Aug 2018 17:21:25 -0500
Message-ID: <1533766895-28605-8-git-send-email-bmarzins@redhat.com>
References: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When get_vpd_sgio() finds out that the vpd info needed to be truncated
to fit in the buffer, it doesn't trucate the size as well,  which allows
it to overwrite the buffer. Also, in once len is set to -ENODATA,
get_vpd_sgio() should exit, instead of using the negative len in
memcpy(). Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0b1855d..3e0db7f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1116,17 +1116,21 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 		return -ENODATA;
 	}
 	buff_len = get_unaligned_be16(&buff[2]) + 4;
-	if (buff_len > 4096)
+	if (buff_len > 4096) {
 		condlog(3, "vpd pg%02x page truncated", pg);
-
+		buff_len = 4096;
+	}
 	if (pg == 0x80)
 		len = parse_vpd_pg80(buff, str, maxlen);
 	else if (pg == 0x83)
 		len = parse_vpd_pg83(buff, buff_len, str, maxlen);
 	else if (pg == 0xc9 && maxlen >= 8) {
-		len = buff_len < 8 ? -ENODATA :
-			(buff_len <= maxlen ? buff_len : maxlen);
-		memcpy (str, buff, len);
+		if (buff_len < 8)
+			len = -ENODATA;
+		else {
+			len = (buff_len <= maxlen)? buff_len : maxlen;
+			memcpy (str, buff, len);
+		}
 	} else
 		len = -ENOSYS;
 
-- 
2.7.4
