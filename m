From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/8] libmultipath: enable feature disable changed
	wwid by default
Date: Thu,  8 Mar 2018 00:15:45 +0100
Message-ID: <20180307231551.15162-3-mwilck@suse.com>
References: <20180307231551.15162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231551.15162-1-mwilck@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

From: Chongyun Wu <wu.chongyun@h3c.com>

enable feature disable changed wwid by default.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index c9e3411aa579..2b270ca46f48 100644
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
2.16.1
