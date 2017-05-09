From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/6] libmultipath: print alias with no_path_retry
	message
Date: Tue,  9 May 2017 11:57:00 -0500
Message-ID: <1494349025-6561-2-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

the "flush_on_last_del in progress" message in select_no_path_retry
should print the device alias.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 09fe728..d393710 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -456,7 +456,7 @@ int select_no_path_retry(struct config *conf, struct multipath *mp)
 	char buff[12];
 
 	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
-		condlog(0, "flush_on_last_del in progress");
+		condlog(0, "%s: flush_on_last_del in progress", mp->alias);
 		mp->no_path_retry = NO_PATH_RETRY_FAIL;
 		return 0;
 	}
-- 
1.8.3.1
