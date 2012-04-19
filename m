From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] Compilation fix for system not providing
	OOM_SCORE_ADJ_MIN
Date: Thu, 19 Apr 2012 14:03:26 +0200
Message-ID: <1334837006-10611-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Newer systems do not provide a definition for OOM_SCORE_ADJ_MIN,
so we need to test against this.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3845880..a3f82d1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1483,9 +1483,15 @@ setscheduler (void)
 static void
 set_oom_adj (void)
 {
+#ifdef OOM_SCORE_ADJ_MIN
 	int retry = 1;
 	char *file = "/proc/self/oom_score_adj";
 	int score = OOM_SCORE_ADJ_MIN;
+#else
+	int retry = 0;
+	char *file = "/proc/self/oom_adj";
+	int score = OOM_ADJUST_MIN;
+#endif
 	FILE *fp;
 	struct stat st;
 
-- 
1.7.3.4
