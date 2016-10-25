From: ding.yemin@zte.com.cn
Subject: [PATCH] Remove duplicated code in
	mpath_alloc_prin_response()
Date: Tue, 25 Oct 2016 16:19:23 +0800
Message-ID: <1477383563-10684-1-git-send-email-ding.yemin@zte.com.cn>
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
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, "ding.yemin" <ding.yemin@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "ding.yemin" <ding.yemin@zte.com.cn>

Remove duplicated code in mpath_alloc_prin_response().

Signed-off-by: ding.yemin <ding.yemin@zte.com.cn>
---
 libmpathpersist/mpath_persist.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 7501651..5962756 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -833,26 +833,26 @@ void * mpath_alloc_prin_response(int prin_sa)
 	{
 		case MPATH_PRIN_RKEY_SA:
 			size = sizeof(struct prin_readdescr);
-			ptr = malloc(size);
-			memset(ptr, 0, size);
 			break;
 		case MPATH_PRIN_RRES_SA:
 			size = sizeof(struct prin_resvdescr);
-			ptr = malloc(size);
-			memset(ptr, 0, size);
 			break;
 		case MPATH_PRIN_RCAP_SA:
 			size=sizeof(struct prin_capdescr);
-			ptr = malloc(size);
-			memset(ptr, 0, size);
 			break;
 		case MPATH_PRIN_RFSTAT_SA:
 			size = sizeof(struct print_fulldescr_list) +
 				sizeof(struct prin_fulldescr *)*MPATH_MX_TIDS;
-			ptr = malloc(size);
-			memset(ptr, 0, size);
 			break;
 	}
+	if (size > 0)
+	{
+		ptr = malloc(size);
+		if (ptr)
+		{
+			memset(ptr, 0, size);
+		}
+	}
 	return ptr;
 }
 
-- 
2.8.1.windows.1
