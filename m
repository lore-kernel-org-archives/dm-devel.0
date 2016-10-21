From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/15] libmultipath: Remove an unused variable
Date: Fri, 21 Oct 2016 11:44:08 -0700
Message-ID: <ca39c736-1810-73c7-48d3-6650501258f0@sandisk.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/uevent.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7bc5837..19b910f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -49,7 +49,6 @@
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
-pthread_t uevq_thr;
 LIST_HEAD(uevq);
 pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
 pthread_mutex_t *uevq_lockp = &uevq_lock;
-- 
2.10.1
