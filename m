From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 21/33] libmultipath: setup_feature: handle
	"retain_attached_hw_handler"
Date: Tue, 28 Feb 2017 17:23:17 +0100
Message-ID: <20170228162329.14517-22-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index c2565239..e225f8b4 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -504,6 +504,12 @@ void setup_feature(struct multipath *mpp, char *feature)
 		else
 			condlog(1, "%s: ignoring feature queue_if_no_path because no_path_retry = %d",
 				mpp->alias, mpp->no_path_retry);
+	} else if (!strcmp(feature, "retain_attached_hw_handler")) {
+		if (mpp->retain_hwhandler != RETAIN_HWHANDLER_OFF)
+			mpp->retain_hwhandler = RETAIN_HWHANDLER_ON;
+		else
+			condlog(1, "%s: ignoring feature 'retain_attached_hw_handler'",
+				mpp->alias);
 	}
 }
 
-- 
2.11.0
