From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 20/33] libmultipath: setup_feature: print log msg
	if no_path_retry cant be set
Date: Tue, 28 Feb 2017 17:23:16 +0100
Message-ID: <20170228162329.14517-21-mwilck@suse.com>
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
 libmultipath/structs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 4419510d..c2565239 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -501,6 +501,9 @@ void setup_feature(struct multipath *mpp, char *feature)
 	if (!strncmp(feature, "queue_if_no_path", 16)) {
 		if (mpp->no_path_retry <= NO_PATH_RETRY_UNDEF)
 			mpp->no_path_retry = NO_PATH_RETRY_QUEUE;
+		else
+			condlog(1, "%s: ignoring feature queue_if_no_path because no_path_retry = %d",
+				mpp->alias, mpp->no_path_retry);
 	}
 }
 
-- 
2.11.0
