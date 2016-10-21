From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 02/15] libmultipath: Avoid that thread
 cancellation causes a hang
Date: Fri, 21 Oct 2016 11:41:56 -0700
Message-ID: <e131ace9-3e0f-8f9a-8332-bbaa94a21b80@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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

Apparently uevq_stop() hangs every now and then in pthread_mutex_lock()
if the udev listener thread is canceled. Avoid this hang by removing
code from uevq_stop(). This is safe because uevq_stop() is only called
just before uevent_listen() returns and in that case neither clearing
my_uev_trigger nor signaling uev_condp is needed. Additionally, rename
uevq_stop() into uevent_cleanup() to make clear that its purpose is to
clean up resources and not to stop the uevent listener.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/uevent.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 6247898..0f32dbc 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -124,15 +124,11 @@ service_uevq(struct list_head *tmpq)
 	}
 }
 
-static void uevq_stop(void *arg)
+static void uevent_cleanup(void *arg)
 {
 	struct udev *udev = arg;
 
-	condlog(3, "Stopping uev queue");
-	pthread_mutex_lock(uevq_lockp);
-	my_uev_trigger = NULL;
-	pthread_cond_signal(uev_condp);
-	pthread_mutex_unlock(uevq_lockp);
+	condlog(3, "Releasing uevent_listen() resources");
 	udev_unref(udev);
 }
 
@@ -495,7 +491,7 @@ int uevent_listen(struct udev *udev)
 		return 1;
 	}
 	udev_ref(udev);
-	pthread_cleanup_push(uevq_stop, udev);
+	pthread_cleanup_push(uevent_cleanup, udev);
 
 	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
-- 
2.10.1
