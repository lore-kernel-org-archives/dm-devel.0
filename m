From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 3/6] multipathd: don't update priority of
	failed paths
Date: Mon, 27 Feb 2017 12:26:40 -0600
Message-ID: <1488220003-20541-4-git-send-email-bmarzins@redhat.com>
References: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

Multipathd shouldn't be updating the priority of failed paths in the
checkerloop. The current avoids this in almost all cases, but not all.
Close the loophole.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0f32b2c..553d1d1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1467,7 +1467,8 @@ int update_prio(struct path *pp, int refresh_all)
 	}
 	oldpriority = pp->priority;
 	conf = get_multipath_config();
-	pathinfo(pp, conf, DI_PRIO);
+	if (pp->state != PATH_DOWN)
+		pathinfo(pp, conf, DI_PRIO);
 	put_multipath_config(conf);
 
 	if (pp->priority == oldpriority)
-- 
1.8.3.1
