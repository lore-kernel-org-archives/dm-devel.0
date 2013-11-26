From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/9] multipathd: Read environment variables from
	systemd
Date: Tue, 26 Nov 2013 12:41:29 +0100
Message-ID: <1385466090-24290-9-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
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

When systemd adjusts 'OOMScoreAdjust' and 'LimitNOFILE'
we should take those settings and not try to adjust them
again on our side.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 448ed39..b57fa5d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1553,7 +1553,13 @@ set_oom_adj (void)
 #endif
 	FILE *fp;
 	struct stat st;
+	char *envp;
 
+	envp = getenv("OOMScoreAdjust");
+	if (envp) {
+		condlog(3, "Using systemd provided OOMScoreAdjust");
+		return;
+	}
 	do {
 		if (stat(file, &st) == 0){
 			fp = fopen(file, "w");
@@ -1630,7 +1636,11 @@ child (void * param)
 
 	setlogmask(LOG_UPTO(conf->verbosity + 3));
 
-	if (conf->max_fds) {
+	envp = getenv("LimitNOFILE");
+
+	if (envp) {
+		condlog(2,"Using systemd provided open fds limit of %s", envp);
+	} else if (conf->max_fds) {
 		struct rlimit fd_limit;
 
 		if (getrlimit(RLIMIT_NOFILE, &fd_limit) < 0) {
-- 
1.8.1.4
