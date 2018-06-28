From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] multipath: don't start multipathd
	unnecessarily
Date: Thu, 28 Jun 2018 12:34:45 +0200
Message-ID: <20180628103446.16817-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When multipathd is off, but systemd is monitoring the multipathd socket,
mpath_connect() has the side effect of starting multipathd. That's
superfluous if we aren't going to pass the command at hand to multipathd.
So, only try to open the socket if the command at hand is a candidate
for delegation.

Note: Despite this, some day in the future, we may decide to delegate
almost everything to multipathd.

Fixes: 506d253b "multipath: delegate dangerous commands to multipathd"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index ed4f40ef..a0f3bde0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -803,10 +803,6 @@ int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 	char command[1024], *p, *reply = NULL;
 	int n, r = 0;
 
-	fd = mpath_connect();
-	if (fd == -1)
-		return 0;
-
 	p = command;
 	*p = '\0';
 	n = sizeof(command);
@@ -819,7 +815,12 @@ int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 	if (strlen(command) == 0)
 		/* No command found, no need to delegate */
 		return 0;
-	else if (p >= command + sizeof(command)) {
+
+	fd = mpath_connect();
+	if (fd == -1)
+		return 0;
+
+	if (p >= command + sizeof(command)) {
 		condlog(0, "internal error - command buffer overflow");
 		r = -1;
 		goto out;
-- 
2.17.1
