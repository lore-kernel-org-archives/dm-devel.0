From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath: fix setting of fast_io_fail_tmo
Date: Tue, 25 Oct 2016 18:39:23 +0800
Message-ID: <1477391963-9364-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: zhang.kai16@zte.com.cn, PengLiang <peng.liang5@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: PengLiang <peng.liang5@zte.com.cn>

As MP_FAST_IO_FAIL_ZERO define to -2, it means -1 and -2 will be sscanf to
*int_ptr in set_fast_io_fail. Then, -1 will be snprintf to 'off' and -2 will
be snprintf to '0' in print_fast_io_fail.
So it will showing the wrong config if user set fast_io_fail_tmo to -1 or -2.
But in fact, -1 or -2 is a invalid config.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 libmultipath/dict.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7c21e72..b02a29b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -573,7 +573,7 @@ set_fast_io_fail(vector strvec, void *ptr)
 	if (strcmp(buff, "off") == 0)
 		*int_ptr = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", int_ptr) != 1 ||
-		 *int_ptr < MP_FAST_IO_FAIL_ZERO)
+		 *int_ptr < 0)
 		*int_ptr = MP_FAST_IO_FAIL_UNSET;
 	else if (*int_ptr == 0)
 		*int_ptr = MP_FAST_IO_FAIL_ZERO;
-- 
2.8.1.windows.1
