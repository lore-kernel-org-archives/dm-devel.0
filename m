From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] multipath: fix return code handling in
	delegate_to_multipathd
Date: Thu, 28 Jun 2018 12:34:46 +0200
Message-ID: <20180628103446.16817-2-mwilck@suse.com>
References: <20180628103446.16817-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180628103446.16817-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Error exit was handled in delegate_to_multipathd() and success
exit after it returned. That's inconsistent. Fix it. Introduce
symbolic return values for better readability.

Fixes: 506d253b "multipath: delegate dangerous commands to multipathd"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index a0f3bde0..fc5bf169 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -796,12 +796,18 @@ get_dev_type(char *dev) {
  *
  * It is safer to use equivalent multipathd client commands instead.
  */
+enum {
+	DELEGATE_OK = 0,
+	DELEGATE_ERROR = -1,
+	NOT_DELEGATED = 1,
+};
+
 int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 			   enum devtypes dev_type, const struct config *conf)
 {
 	int fd;
 	char command[1024], *p, *reply = NULL;
-	int n, r = 0;
+	int n, r = DELEGATE_ERROR;
 
 	p = command;
 	*p = '\0';
@@ -814,22 +820,21 @@ int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 
 	if (strlen(command) == 0)
 		/* No command found, no need to delegate */
-		return 0;
+		return NOT_DELEGATED;
 
 	fd = mpath_connect();
 	if (fd == -1)
-		return 0;
+		return NOT_DELEGATED;
 
 	if (p >= command + sizeof(command)) {
 		condlog(0, "internal error - command buffer overflow");
-		r = -1;
 		goto out;
 	}
 
 	condlog(3, "delegating command to multipathd");
-	r = mpath_process_cmd(fd, command, &reply, conf->uxsock_timeout);
 
-	if (r == -1) {
+	if (mpath_process_cmd(fd, command, &reply, conf->uxsock_timeout)
+	    == -1) {
 		condlog(1, "error in multipath command %s: %s",
 			command, strerror(errno));
 		goto out;
@@ -837,13 +842,11 @@ int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 
 	if (reply != NULL && *reply != '\0' && strcmp(reply, "ok\n"))
 		printf("%s", reply);
-	r = 1;
+	r = DELEGATE_OK;
 
 out:
 	FREE(reply);
 	close(fd);
-	if (r < 0)
-		exit(1);
 	return r;
 }
 
@@ -1050,8 +1053,14 @@ main (int argc, char *argv[])
 		goto out;
 	}
 
-	if (delegate_to_multipathd(cmd, dev, dev_type, conf))
+	switch(delegate_to_multipathd(cmd, dev, dev_type, conf)) {
+	case DELEGATE_OK:
 		exit(0);
+	case DELEGATE_ERROR:
+		exit(1);
+	case NOT_DELEGATED:
+		break;
+	}
 
 	if (cmd == CMD_RESET_WWIDS) {
 		struct multipath * mpp;
-- 
2.17.1
