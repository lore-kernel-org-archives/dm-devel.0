From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/42] Increase parameter buffer
Date: Tue,  8 Jan 2013 14:53:55 +0100
Message-ID: <1357653259-62650-18-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Multipath is using an internal static buffer for assembling
device-mapper tables, which might be too small for large setups.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 312014b..16e940b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -9,7 +9,7 @@
 #define SERIAL_SIZE		65
 #define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE		16
-#define PARAMS_SIZE		1024
+#define PARAMS_SIZE		4096
 #define FILE_NAME_SIZE		256
 #define CALLOUT_MAX_SIZE	256
 #define BLK_DEV_SIZE		33
-- 
1.7.4.2
