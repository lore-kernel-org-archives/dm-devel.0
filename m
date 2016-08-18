From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] multipathd: Change four threads from detached
	into joinable
Date: Thu, 18 Aug 2016 15:44:51 -0700
Message-ID: <f31a3171-80e1-c01a-a992-588bb063e619@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Change the CLI listener, checker loop, uevent dispatcher and
uevent listener threads from detached into joinable threads.
This change is needed because calling pthread_join() is only
allowed for joinable threads.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: dragan.stancevic@canonical.com
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2be6cb2..6b3c856 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2216,8 +2216,8 @@ child (void * param)
 	signal_init();
 	rcu_init();
 
-	setup_thread_attr(&misc_attr, 64 * 1024, 1);
-	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 1);
+	setup_thread_attr(&misc_attr, 64 * 1024, 0);
+	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
 	if (logsink == 1) {
-- 
2.9.2
