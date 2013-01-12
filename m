From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 09/18] multipath: fix set_oom_adj
Date: Sat, 12 Jan 2013 00:04:46 -0600
Message-ID: <1357970695-3396-9-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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

Fix set_oom_adj() to work correclty if OOM_ADJUST_MIN isn't
defined.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8917499..a6afebb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1542,8 +1542,12 @@ set_oom_adj (void)
 				strerror(errno));
 			return;
 		}
+#ifdef OOM_ADJUST_MIN
 		file = "/proc/self/oom_adj";
 		score = OOM_ADJUST_MIN;
+#else
+		retry = 0;
+#endif
 	} while (retry--);
 	condlog(0, "couldn't adjust oom score");
 }
-- 
1.8.0
