From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 08/18] multipathd: fail if pidfile can't be
	created
Date: Thu,  7 Apr 2016 18:20:02 -0500
Message-ID: <1460071212-21018-9-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Right now, multipathd ignores failures from pidfile_create.  This means
that multiple multipathd processes can be running at the same time. If
someone runs "multipathd" and doesn't add a command after it, a new
process will be created, even if one is already running. To avoid this,
multipathd needs to actually fail if the pidfile can't be created or
locked. Since we only really need the pidfile to keep from launching
multiple processes, we can create in earlier in startup. This patch
moves pidfile_create to as soon as we can be sure that we can log an
error message, and fails multipathd if the create fails.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8f4fb58..06876b9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1768,7 +1768,7 @@ child (void * param)
 #ifdef USE_SYSTEMD
 	unsigned long checkint;
 #endif
-	int rc, pid_rc;
+	int rc;
 	char *envp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -1786,6 +1786,12 @@ child (void * param)
 		log_thread_start(&log_attr);
 		pthread_attr_destroy(&log_attr);
 	}
+	if (pidfile_create(DEFAULT_PIDFILE, daemon_pid)) {
+		condlog(1, "failed to create pidfile");
+		if (logsink == 1)
+			log_thread_stop();
+		exit(1);
+	}
 
 	running_state = DAEMON_START;
 
@@ -1905,10 +1911,6 @@ child (void * param)
 	}
 	pthread_attr_destroy(&misc_attr);
 
-	/* Startup complete, create logfile */
-	pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
-	/* Ignore errors, we can live without */
-
 	running_state = DAEMON_RUNNING;
 #ifdef USE_SYSTEMD
 	sd_notify(0, "READY=1\nSTATUS=running");
@@ -1959,10 +1961,8 @@ child (void * param)
 	dm_lib_exit();
 
 	/* We're done here */
-	if (!pid_rc) {
-		condlog(3, "unlink pidfile");
-		unlink(DEFAULT_PIDFILE);
-	}
+	condlog(3, "unlink pidfile");
+	unlink(DEFAULT_PIDFILE);
 
 	condlog(2, "--------shut down-------");
 
-- 
1.8.3.1
