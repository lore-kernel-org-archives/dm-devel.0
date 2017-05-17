From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/7] Remove mpath_reverse_8bytes_order()
Date: Wed, 17 May 2017 08:43:06 -0700
Message-ID: <20170517154309.17787-5-bart.vanassche@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Since this function is not used, remove it.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 31b2fe6d..29df8c6f 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -502,21 +502,6 @@ void mpath_reverse_uint32_byteorder(uint32_t *num)
 	*num = ((byte0 << 24) | (byte1 << 16) | (byte2 << 8) | (byte3 << 0));
 }
 
-void mpath_reverse_8bytes_order(char * var)
-{
-	char byte[8];
-
-	int i;
-	for(i=0 ; i < 8 ; i++ )
-	{
-		byte[i] = var[i];
-	}
-	for(i=0 ; i < 8 ; i++ )
-	{
-		var[7 - i] = byte[i];
-	}
-}
-
 void
 dumpHex(const char* str, int len, int log)
 {
-- 
2.12.2
