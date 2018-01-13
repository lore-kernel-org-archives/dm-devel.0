From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/20] libmultipath: fix return code of
	sgio_get_vpd()
Date: Sat, 13 Jan 2018 22:19:23 +0100
Message-ID: <20180113211938.31552-6-mwilck@suse.com>
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

This function must return the length of data received in success
case.
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ab7794d8d2e1..c53d3aab897f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -852,7 +852,7 @@ retry:
 			return len;
 		if (len > DEFAULT_SGIO_LEN)
 			goto retry;
-		return 0;
+		return len;
 	}
 	return -1;
 }
-- 
2.15.1
