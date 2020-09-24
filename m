From: mwilck@suse.com
Subject: [PATCH 15/23] multipathd: fixup libdm deinitialization
Date: Thu, 24 Sep 2020 15:40:46 +0200
Message-ID: <20200924134054.14632-16-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

With libmp_dm_exit() in place, we can make sure that the
calls are made in the right order.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 483b3c7..f9749e5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3220,8 +3220,6 @@ failed:
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-	dm_lib_exit();
-
 	/* We're done here */
 	cleanup_pidfile();
 	condlog(2, "--------shut down-------");
@@ -3320,6 +3318,9 @@ main (int argc, char *argv[])
 
 	pthread_cond_init_mono(&config_cond);
 
+	if (atexit(dm_lib_exit))
+		condlog(3, "failed to register exit handler for libdm");
+
 	libmultipath_init();
 	if (atexit(libmultipath_exit))
 		condlog(3, "failed to register exit handler for libmultipath");
-- 
2.28.0
