From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/12] multipathd(coverity): check retval
	clock_gettime()
Date: Tue,  8 Jan 2019 23:54:06 +0100
Message-ID: <20190108225409.15977-10-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Checking this is pointless, as we'd bail out early in
pthread_cond_init_mono if CLOCK_MONOTONIC was unsupported, and this
is the only error condition of clock_gettime worth checking.
Do it anyway to make coverity feel better.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 01cf70f..0270e18 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -242,10 +242,11 @@ int set_config_state(enum daemon_status state)
 		else if (running_state != DAEMON_IDLE) {
 			struct timespec ts;
 
-			clock_gettime(CLOCK_MONOTONIC, &ts);
-			ts.tv_sec += 1;
-			rc = pthread_cond_timedwait(&config_cond,
-						    &config_lock, &ts);
+			if (clock_gettime(CLOCK_MONOTONIC, &ts) == 0) {
+				ts.tv_sec += 1;
+				rc = pthread_cond_timedwait(&config_cond,
+							    &config_lock, &ts);
+			}
 		}
 		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
 			running_state = state;
-- 
2.19.2
