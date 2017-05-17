From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/7] libmultipath/configure.h: Add a forward
	declaration
Date: Wed, 17 May 2017 08:43:04 -0700
Message-ID: <20170517154309.17787-3-bart.vanassche@sandisk.com>
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

This change avoids that the "#include "configure.h"" statements that
are added by the next patch trigger a compiler warning.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/configure.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index fb078a61..fd7f581d 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -26,6 +26,8 @@ enum actions {
 #define FLUSH_ONE 1
 #define FLUSH_ALL 2
 
+struct vectors;
+
 int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
-- 
2.12.2
