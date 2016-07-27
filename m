From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/7] multipathd: Fix type of rcu_unregister()
Date: Wed, 27 Jul 2016 14:13:25 -0700
Message-ID: <c5ff00bc-88be-794b-9f75-8ca6ee415769@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This patch avoids that gcc reports the following compiler warning:

initialization from incompatible pointer type [-Wincompatible-pointer-types]
  pthread_cleanup_push(rcu_unregister, NULL);

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8784307..0cd822b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1126,10 +1126,9 @@ out:
 	return r;
 }
 
-static void *rcu_unregister(void *param)
+static void rcu_unregister(void *param)
 {
 	rcu_unregister_thread();
-	return NULL;
 }
 
 static void *
-- 
2.9.2
