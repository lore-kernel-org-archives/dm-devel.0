From: Germano Percossi <germano.percossi@citrix.com>
Subject: [PATCH 1/1] multipath: fix memory leak and segfault in
	reconfigure
Date: Thu, 11 Feb 2016 19:30:54 +0000
Message-ID: <1455219054-13122-1-git-send-email-germano.percossi@citrix.com>
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Within the reconfigure function, the global pointer conf is
stored in a local variable and then assigned NULL.
If load_config should fail, for any reason, we end up with
a memory leak, as soon as we leave the function, and with
the global pointer conf set to NULL, leading to a segfault
as soon as it is dereferenced.

I tested it by calling a reconfigure and making the first
allocation in load_config fail but any failure in load_config
would do.
From a user perspective the CLI reports "fail".

If something like this should happen there are at least 2 possible
scenarios:

1) If a second immediate reconfigure succeeds, the conf now is fine but
   the leak stays
2) If the previous point does not happen, any command trying to access
   "conf" would fail. On my test box a "show conf" segfaulted.

The fix is simple but in case of failure at least the previous
conf is kept in memory without leaks or segfaluts

Signed-off-by: Germano Percossi <germano.percossi@citrix.com>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 04f6d02..f83c849 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1551,6 +1551,8 @@ reconfigure (struct vectors * vecs)
 		configure(vecs, 1);
 		free_config(old);
 		retval = 0;
+	} else {
+		conf = old;
 	}
 
 	running_state = DAEMON_RUNNING;
-- 
1.9.1
