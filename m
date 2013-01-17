From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/11] multipathd: call 'reconfigure' during
	startup
Date: Thu, 17 Jan 2013 15:59:31 +0100
Message-ID: <1358434773-2002-10-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The init script should be calling 'reconfigure' cli command
during startup. That not only checks if the daemon is running,
but will also cause a complete reconfiguration, so all devices
which might have been missed during init will be catched.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.init.suse |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.init.suse b/multipathd/multipathd.init.suse
index 03a1151..d1319b1 100644
--- a/multipathd/multipathd.init.suse
+++ b/multipathd/multipathd.init.suse
@@ -38,7 +38,7 @@ case "$1" in
     start)
 	echo -n "Starting multipathd"
 	ulimit -c unlimited
-	if $DAEMON -k"show daemon" > /dev/null 2>&1 ; then
+	if $DAEMON -k"reconfigure" > /dev/null 2>&1 ; then
 	    echo -n " (multipathd running)"
 	    rc_status -v
 	    rc_exit
-- 
1.7.10.4
