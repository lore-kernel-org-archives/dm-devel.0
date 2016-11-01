From: li.minghui7@zte.com.cn
Subject: [PATCH] multipathd/main.c:change the loglevel from 1/2
	to 0
Date: Tue, 1 Nov 2016 19:39:06 +0800
Message-ID: <1478000346-6928-1-git-send-email-li.minghui7@zte.com.cn>
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
Cc: zhang.kai16@zte.com.cn, "li.minghui" <li.minghui7@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "li.minghui" <li.minghui7@zte.com.cn>

In fucntion child(),before the execution of the function load_config() and
rcu_assign_pointer(), we need to adjust the log level to 0. otherwise ,the log
will not be logged because the variable conf->verbosity is not assigned then.
---
 multipathd/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 03c2dd9..3d5a077 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2228,7 +2228,7 @@ child (void * param)
 	}
 	pid_fd = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
 	if (pid_fd < 0) {
-		condlog(1, "failed to create pidfile");
+		condlog(0, "failed to create pidfile");
 		if (logsink == 1)
 			log_thread_stop();
 		exit(1);
@@ -2236,8 +2236,8 @@ child (void * param)
 
 	post_config_state(DAEMON_START);
 
-	condlog(2, "--------start up--------");
-	condlog(2, "read " DEFAULT_CONFIGFILE);
+	condlog(0, "--------start up--------");
+	condlog(0, "read " DEFAULT_CONFIGFILE);
 
 	conf = load_config(DEFAULT_CONFIGFILE);
 	if (!conf)
-- 
2.8.1.windows.1
