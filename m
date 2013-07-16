From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/30] multipathd: increase stacksize for uevent
	listener
Date: Tue, 16 Jul 2013 09:13:17 +0200
Message-ID: <1373958801-103613-27-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

libudev has quite some heavy stack usage, so the default stack size
is not enough here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b41fc64..8681aa2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1580,7 +1580,7 @@ static int
 child (void * param)
 {
 	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr;
-	pthread_attr_t log_attr, misc_attr;
+	pthread_attr_t log_attr, misc_attr, uevent_attr;
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
@@ -1593,6 +1593,7 @@ child (void * param)
 	udev = udev_new();
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 1);
+	setup_thread_attr(&uevent_attr, 128 * 1024, 1);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
 	if (logsink) {
@@ -1658,10 +1659,11 @@ child (void * param)
 	/*
 	 * Start uevent listener early to catch events
 	 */
-	if ((rc = pthread_create(&uevent_thr, &misc_attr, ueventloop, udev))) {
+	if ((rc = pthread_create(&uevent_thr, &uevent_attr, ueventloop, udev))) {
 		condlog(0, "failed to create uevent thread: %d", rc);
 		exit(1);
 	}
+	pthread_attr_destroy(&uevent_attr);
 	if ((rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs))) {
 		condlog(0, "failed to create cli listener: %d", rc);
 		exit(1);
-- 
1.7.12.4
