From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/20] libmultipath: get_vpd_sgio: support VPD
	0xc9
Date: Sat, 13 Jan 2018 22:19:25 +0100
Message-ID: <20180113211938.31552-8-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This VPD is needed to check for NetApp E-Series RDAC support.
---
 libmultipath/discovery.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 43631c46f21e..8ae170ee3a27 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1118,7 +1118,11 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 		len = parse_vpd_pg80(buff, str, maxlen);
 	else if (pg == 0x83)
 		len = parse_vpd_pg83(buff, buff_len, str, maxlen);
-	else
+	else if (pg == 0xc9 && maxlen >= 8) {
+		len = buff_len < 8 ? -ENODATA :
+			(buff_len <= maxlen ? buff_len : maxlen);
+		memcpy (str, buff, len);
+	} else
 		len = -ENOSYS;
 
 	return len;
-- 
2.15.1
