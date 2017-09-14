From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/4] multipath: delegate dangerous commands to
	multipathd
Date: Thu, 14 Sep 2017 21:49:26 +0200
Message-ID: <20170914194926.17522-1-mwilck@suse.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Some multipath commands are dangerous to run while multipathd is running.
For example, "multipath -r" may apply a modified configuration to the kernel,
while multipathd is still using the old configuration, leading to
inconsistent state between multipathd and the kernel.

It is safer to use equivalent multipathd client commands instead.
For now, do this only for "multipath -r", but other invocations
may be added in the future. Perhaps some day, all "multipath"
commands will be mapped to multipathd actions.

Note that with delegation, "multipath -r" will not produce any
terminal output, so this may affect users who capture "multipath -r"
output for parsing it. It would be very hard to produce compatible output
to the normal multipath command for different verbosity levels. I
considered running "show topology" after "reconfigure", but the output
would have slightly different format and would only match -v2, anyway.

I plan to convert more multipath commands, but that needs some more
thought. Some additional multipathd client commands need to be
implemented first.

Changes wrt v2:
 - use libmpathcmd rather than exec'ing multipathd (Ben Marzinski)
 - pass more parameters from main program, preparing for other commands

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index dede017e9202..48a75b6855d9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -502,6 +502,64 @@ get_dev_type(char *dev) {
 	return DEV_NONE;
 }
 
+/*
+ * Some multipath commands are dangerous to run while multipathd is running.
+ * For example, "multipath -r" may apply a modified configuration to the kernel,
+ * while multipathd is still using the old configuration, leading to
+ * inconsistent state.
+ *
+ * It is safer to use equivalent multipathd client commands instead.
+ */
+int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
+			   enum devtypes dev_type, const struct config *conf)
+{
+	int fd;
+	char command[1024], *p, *reply;
+	int n, r = 0;
+
+	fd = mpath_connect();
+	if (fd == -1)
+		return 0;
+
+	p = command;
+	*p = '\0';
+	n = sizeof(command);
+
+	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
+		p += snprintf(p, n, "reconfigure");
+	}
+	/* Add other translations here */
+
+	if (strlen(command) == 0)
+		/* No command found, no need to delegate */
+		return 0;
+	else if (p >= command + sizeof(command)) {
+		condlog(0, "internal error - command buffer overflow");
+		r = -1;
+		goto out;
+	}
+
+	condlog(3, "delegating command to multipathd");
+	r = mpath_process_cmd(fd, command, &reply, conf->uxsock_timeout);
+
+	if (r == -1) {
+		condlog(1, "error in multipath command %s: %s",
+			command, strerror(errno));
+		goto out;
+	}
+
+	if (reply != NULL && *reply != '\0' && strcmp(reply, "ok\n"))
+		printf("%s", reply);
+	r = 1;
+
+out:
+	FREE(reply);
+	close(fd);
+	if (r < 0)
+		exit(1);
+	return r;
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -699,6 +757,10 @@ main (int argc, char *argv[])
 		condlog(0, "the -w option requires a device");
 		goto out;
 	}
+
+	if (delegate_to_multipathd(cmd, dev, dev_type, conf))
+		exit(0);
+
 	if (cmd == CMD_RESET_WWIDS) {
 		struct multipath * mpp;
 		int i;
-- 
2.14.0
