From: mwilck@suse.com
Subject: [PATCH 09/23] multipathd: close pidfile on exit
Date: Thu, 24 Sep 2020 15:40:40 +0200
Message-ID: <20200924134054.14632-10-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

It seems we've been doing this only in the failure case, for ages.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3db051b..44c1bd1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -132,6 +132,7 @@ static pthread_cond_t config_cond;
 static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
 static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
 	uevq_thr_started, dmevent_thr_started;
+static int pid_fd = -1;
 
 static inline enum daemon_status get_running_state(void)
 {
@@ -2894,6 +2895,8 @@ set_oom_adj (void)
 
 static void cleanup_pidfile(void)
 {
+	if (pid_fd >= 0)
+		close(pid_fd);
 	condlog(3, "unlink pidfile");
 	unlink(DEFAULT_PIDFILE);
 }
@@ -3026,7 +3029,6 @@ child (__attribute__((unused)) void *param)
 	pthread_attr_t log_attr, misc_attr, uevent_attr;
 	struct vectors * vecs;
 	int rc;
-	int pid_fd = -1;
 	struct config *conf;
 	char *envp;
 	enum daemon_status state;
-- 
2.28.0
