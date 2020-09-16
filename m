From: mwilck@suse.com
Subject: [PATCH 05/19] multipathd: use volatile qualifier for
	running_state
Date: Wed, 16 Sep 2020 17:37:04 +0200
Message-ID: <20200916153718.582-6-mwilck@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

While we access running_state only under the config_lock,
we sometimes do in a loop. Use the volatile qualifier to make
sure compilers can't optimize away the loads.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8cc9b74..451d68c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -126,7 +126,7 @@ int poll_dmevents = 0;
 int poll_dmevents = 1;
 #endif
 /* Don't access this variable without holding config_lock */
-enum daemon_status running_state = DAEMON_INIT;
+volatile enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t config_cond;
-- 
2.28.0
