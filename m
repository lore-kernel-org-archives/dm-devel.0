From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/78] Disable reassign maps per default
Date: Mon, 16 Mar 2015 13:36:05 +0100
Message-ID: <1426509425-15978-19-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

lvm has undergone various updates, and should now check for
correct device assignment. So disable the 'reassign_maps'
feature per default.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/defaults.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 7831992..878da14 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -12,7 +12,7 @@
 #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
-#define DEFAULT_REASSIGN_MAPS	1
+#define DEFAULT_REASSIGN_MAPS	0
 #define DEFAULT_FIND_MULTIPATHS	0
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
-- 
1.8.4.5
