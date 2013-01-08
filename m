From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/42] multipath.init.suse: Update usage message
Date: Tue,  8 Jan 2013 14:54:12 +0100
Message-ID: <1357653259-62650-35-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

The usage message in multipath.init.suse doesn't list 'reload'.
And 'reload' is a misnomer, as it's actually a restart.
So rename 'reload' to 'restart' and add to the usage message.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.init.suse |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.init.suse b/multipath/multipath.init.suse
index c7cd5c7..de1cc1f 100644
--- a/multipath/multipath.init.suse
+++ b/multipath/multipath.init.suse
@@ -146,12 +146,12 @@ case "$1" in
 	fi
 	rc_status -v
 	;;
-    reload)
+    restart)
 	$0 stop
 	$0 start
 	;;
     *)
-	echo "Usage: $0 {start|stop|status}"
+	echo "Usage: $0 {start|stop|status|restart}"
 	exit 1
 	;;
 esac
-- 
1.7.4.2
