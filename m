From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/15] libmultipath: Make building against
 musl-libc again possible
Date: Fri, 21 Oct 2016 11:41:12 -0700
Message-ID: <cc5e409a-78e9-6c4b-0cc5-d2214ea29fdf@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

musl-libc does not support PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP.

This patch reverts commit 7884bde302ad ("multipathd: Avoid that a
deadlock is triggered sporadically during shutdown").

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 85fd2fb..6247898 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -52,7 +52,7 @@ typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
 pthread_t uevq_thr;
 LIST_HEAD(uevq);
-pthread_mutex_t uevq_lock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
+pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
 pthread_mutex_t *uevq_lockp = &uevq_lock;
 pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
 pthread_cond_t *uev_condp = &uev_cond;
-- 
2.10.1
