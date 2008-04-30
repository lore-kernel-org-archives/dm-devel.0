From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Don't print failure messages for callouts by
	default
Date: Wed, 30 Apr 2008 11:04:26 +0200
Message-ID: <20080430090426.D2B4718C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Calling 'multipath -ll' on devices with paths results in
lots of error messages; they really should be suppressed
for the normal output. The user can always have them printed
out by increasing verbosity.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/callout.c           |   14 ++++++++++++--
 libmultipath/discovery.c         |    8 ++++----
 libmultipath/prioritizers/alua.c |    6 +++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index d54f3ca..4dd33c5 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <stdlib.h>
+#include <fcntl.h>
 #include <sys/wait.h>
 #include <errno.h>
 
@@ -32,7 +33,7 @@ int execute_program(char *path, char *value, int len)
 	int retval;
 	int count;
 	int status;
-	int fds[2];
+	int fds[2], null_fd;
 	pid_t pid;
 	char *pos;
 	char arg[PROGRAM_SIZE];
@@ -75,7 +76,16 @@ int execute_program(char *path, char *value, int len)
 		close(STDOUT_FILENO);
 
 		/* dup write side of pipe to STDOUT */
-		dup(fds[1]);
+		if (dup(fds[1]) < 0)
+			return -1;
+
+		/* Ignore writes to stderr */
+		null_fd = open("/dev/null", O_WRONLY);
+		if (null_fd > 0) {
+			close(STDERR_FILENO);
+			dup(null_fd);
+			close(null_fd);
+		}
 
 		retval = execv(argv[0], argv);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 83e1865..8cfb53f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -623,8 +623,8 @@ get_state (struct path * pp)
 	}
 	pp->state = checker_check(c);
 	condlog(3, "%s: state = %i", pp->dev, pp->state);
-	if (pp->state == PATH_DOWN)
-		condlog(2, "%s: checker msg is \"%s\"",
+	if (pp->state == PATH_DOWN && strlen(checker_message(c)))
+		condlog(3, "%s: checker msg is \"%s\"",
 			pp->dev, checker_message(c));
 	return 0;
 }
@@ -642,7 +642,7 @@ get_prio (struct path * pp)
 	}
 	pp->priority = prio_getprio(pp->prio, pp);
 	if (pp->priority < 0) {
-		condlog(0, "%s: %s prio error", pp->dev, prio_name(pp->prio));
+		condlog(3, "%s: %s prio error", pp->dev, prio_name(pp->prio));
 		pp->priority = PRIO_UNDEF;
 		return 1;
 	}
@@ -663,7 +663,7 @@ get_uid (struct path * pp)
 		condlog(0, "error formatting uid callout command");
 		memset(pp->wwid, 0, WWID_SIZE);
 	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-		condlog(0, "error calling out %s", buff);
+		condlog(3, "error calling out %s", buff);
 		memset(pp->wwid, 0, WWID_SIZE);
 		return 1;
 	}
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 67e4adb..1b52b8e 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -22,6 +22,7 @@
 #define ALUA_PRIO_NOT_SUPPORTED			1
 #define ALUA_PRIO_RTPG_FAILED			2
 #define ALUA_PRIO_GETAAS_FAILED			3
+#define ALUA_PRIO_TPGS_FAILED			4
 
 int
 get_alua_info(int fd)
@@ -38,7 +39,7 @@ get_alua_info(int fd)
 
 	rc = get_target_port_group_support(fd);
 	if (rc < 0)
-		return rc;
+		return -ALUA_PRIO_TPGS_FAILED;
 
 	if (rc == TPGS_NONE)
 		return -ALUA_PRIO_NOT_SUPPORTED;
@@ -85,6 +86,9 @@ int getprio (struct path * pp)
 			case ALUA_PRIO_GETAAS_FAILED:
 				condlog(0, "%s: couln't get asymmetric access state", pp->dev);
 				break;
+			case ALUA_PRIO_TPGS_FAILED:
+				condlog(3, "%s: couln't get supported alua states", pp->dev);
+				break;
 		}
 	}
 	return rc;
-- 
1.5.2.4
