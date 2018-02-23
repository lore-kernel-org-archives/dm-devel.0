From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: [PATCH] multipathd: add lock protection for
 cli_list_status
Date: Fri, 23 Feb 2018 09:58:24 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295B3BB@H3CMLB14-EX.srv.huawei-3com.com>
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

cli_list_status will access vecs->pathvec which should have lock
protection, otherwise might get inconsistent data or other
problem.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
  multipathd/main.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e74a448..b4e15eb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1204,7 +1204,7 @@ uxlsnrloop (void * ap)
  	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
  	set_handler_callback(LIST+PATH, cli_list_path);
  	set_handler_callback(LIST+MAPS, cli_list_maps);
-	set_unlocked_handler_callback(LIST+STATUS, cli_list_status);
+	set_handler_callback(LIST+STATUS, cli_list_status);
  	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
  	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
  	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
-- 
1.7.9.5
