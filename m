From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 4/7] multipathd: don't update priority of
	failed paths
Date: Mon, 13 Feb 2017 22:06:50 -0600
Message-ID: <1487045213-15776-5-git-send-email-bmarzins@redhat.com>
References: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
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
index adc3258..5480e96 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1457,7 +1457,8 @@ int update_prio(struct path *pp, int refresh_all)
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
