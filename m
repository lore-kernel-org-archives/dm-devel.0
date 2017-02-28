From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/33] multipathd: Set CLI timeout correctly
Date: Tue, 28 Feb 2017 17:23:05 +0100
Message-ID: <20170228162329.14517-10-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When calling 'multipathd cmd' the CLI timeout isn't set correctly;
calling "multipathd -k'cmd'" uses the correct timeout.
And the default timeout should be increased to 4 seconds to ensure
multipath runs correctly on large installations.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathcmd/mpath_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 7293d919..6534474c 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -25,7 +25,7 @@ extern "C" {
 #endif
 
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
-#define DEFAULT_REPLY_TIMEOUT	1000
+#define DEFAULT_REPLY_TIMEOUT	4000
 #define MAX_REPLY_LEN		65536
 
 
-- 
2.11.0
