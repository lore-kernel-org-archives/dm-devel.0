From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/8] multipathd: add lock protection for
	cli_list_status
Date: Thu,  8 Mar 2018 00:15:44 +0100
Message-ID: <20180307231551.15162-2-mwilck@suse.com>
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

cli_list_status will access vecs->pathvec which should have lock
protection, otherwise might get inconsistent data or other
problem.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 327cc191214c..6d502aceb252 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1212,7 +1212,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
 	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
-	set_unlocked_handler_callback(LIST+STATUS, cli_list_status);
+	set_handler_callback(LIST+STATUS, cli_list_status);
 	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
 	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
 	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
-- 
2.16.1
