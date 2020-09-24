From: mwilck@suse.com
Subject: [PATCH 11/23] multipathd: child(): call cleanups in
	failure case, too
Date: Thu, 24 Sep 2020 15:40:42 +0200
Message-ID: <20200924134054.14632-12-mwilck@suse.com>
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

So far we haven't called any cleanup code if child() failed.
Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e742aa5..3c8f893 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3044,6 +3044,7 @@ child (__attribute__((unused)) void *param)
 	char *envp;
 	enum daemon_status state;
 	struct call_rcu_data *crdp;
+	int exit_code = 1;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
@@ -3207,6 +3208,8 @@ child (__attribute__((unused)) void *param)
 		}
 	}
 
+	exit_code = 0;
+failed:
 	cleanup_threads();
 	cleanup_vecs();
 	cleanup_foreign();
@@ -3229,12 +3232,7 @@ child (__attribute__((unused)) void *param)
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-	exit(sd_notify_exit(0));
-
-failed:
-	if (pid_fd >= 0)
-		close(pid_fd);
-	exit(sd_notify_exit(1));
+	return sd_notify_exit(exit_code);
 }
 
 static int
-- 
2.28.0
