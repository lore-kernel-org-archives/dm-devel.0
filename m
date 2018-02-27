From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: [PATCH] libmultipath: enable feature disable changed
 wwid by default
Date: Tue, 27 Feb 2018 08:34:31 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295BB24@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

enable feature disable changed wwid by default.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
 libmultipath/defaults.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index c9e3411..2b270ca 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -38,7 +38,7 @@
 #define DEFAULT_FORCE_SYNC	0
 #define DEFAULT_PARTITION_DELIM	NULL
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
-#define DEFAULT_DISABLE_CHANGED_WWIDS 0
+#define DEFAULT_DISABLE_CHANGED_WWIDS 1
 #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
 #define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
 
-- 
1.7.9.5
