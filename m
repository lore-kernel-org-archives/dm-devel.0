From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 03/15] libmultipath: Remove an incorrect comment
Date: Fri, 21 Oct 2016 11:42:19 -0700
Message-ID: <78fc5a81-6da0-e60e-ed0a-57a067a17c17@sandisk.com>
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

It is easy to see that uevq_lockp is not held while service_uevq()
is called. Since no other code accesses the list that is processed
by this function calling service_uevq() without holding uevq_lockp
is safe. Hence remove the comment about locking above service_uevq().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/uevent.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0f32dbc..f844294 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -104,9 +104,6 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 	}
 }
 
-/*
- * Called with uevq_lockp held
- */
 void
 service_uevq(struct list_head *tmpq)
 {
-- 
2.10.1
