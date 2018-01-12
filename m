From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/14] libmultipath: fix return code of
	sgio_get_vpd()
Date: Fri, 12 Jan 2018 23:07:35 +0100
Message-ID: <20180112220743.11513-7-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This function must return the length of data received in success
case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3ae934261b65..da7bf5652a53 100644
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
