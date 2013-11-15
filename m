From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/13] multipathd: Read environment variables
	from systemd
Date: Fri, 15 Nov 2013 11:29:42 +0100
Message-ID: <1384511384-27642-12-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
index abeebc2..e5b061b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1551,7 +1551,13 @@ set_oom_adj (void)
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
@@ -1625,7 +1631,11 @@ child (void * param)
 
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
