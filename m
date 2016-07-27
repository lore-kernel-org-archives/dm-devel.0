From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 7/7] multipathd: Fix a use-after-free
Date: Wed, 27 Jul 2016 14:14:27 -0700
Message-ID: <86fd1f05-b386-6d80-e537-ba8c78d23268@sandisk.com>
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

Avoid that Valgrind reports the following:

Invalid read of size 4
   at 0x40C7AE: child (main.c:2382)
   by 0x40D2DC: main (main.c:2608)
 Address 0x7ed255c is 76 bytes inside a block of size 416 free'd
   at 0x4C2E38B: free (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
   by 0x5DD37ED: free_config (config.c:539)
   by 0x40B76C: rcu_free_config (main.c:1987)
   by 0x4E3C1FF: call_rcu_thread (urcu-call-rcu-impl.h:332)
   by 0x5047473: start_thread (pthread_create.c:333)
   by 0x671C3EC: clone (clone.S:109)
 Block was alloc'd at
   at 0x4C2D12F: malloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
   by 0x5DC7D9B: zalloc (memory.c:41)
   by 0x5DD34D7: alloc_config (config.c:472)
   by 0x5DD3A87: load_config (config.c:582)
   by 0x40BF98: child (main.c:2246)
   by 0x40D2DC: main (main.c:2608)

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index f4c8245..6a4135c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2376,9 +2376,11 @@ child (void * param)
 	}
 
 	lock(vecs->lock);
+	conf = get_multipath_config();
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
+	put_multipath_config(conf);
 	remove_maps_and_stop_waiters(vecs);
 	unlock(vecs->lock);
 
-- 
2.9.2
