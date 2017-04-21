From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH] dm-crypt: run in a WQ_HIGHPRI workqueue
Date: Fri, 21 Apr 2017 11:11:36 +0200
Message-ID: <20170421091136.28322-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, timmurray@google.com
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, ghackmann@google.com
List-Id: dm-devel.ids

From: Tim Murray <timmurray@google.com>

Running dm-crypt in a standard workqueue results in IO competing for CPU
time with standard user apps, which can lead to pipeline bubbles and
seriously degraded performance. Move to a WQ_HIGHPRI workqueue to
protect against that.

Signed-off-by: Tim Murray <timmurray@google.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
We think that would be interesting share one issue that we have and know
the opinion of the maintainers about this patch.

One of the major causes of Bullhead devices slowdowns, is that when the
system is under load, the kworkers responsible for dm-verity and dm-crypt
are runnable but may not run for 10s of ms per iteration. This then results
in mmcqd not being called as often, and the net effect is that disk IO
performance goes to zero. We can see significant improvements when moving
to a WQ_HIGHPRI workqueue for verity and kcryptd.
---
 drivers/md/dm-crypt.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8dbecf1..0b7ffa2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2738,16 +2738,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io", WQ_MEM_RECLAIM, 1);
+	cc->io_queue = alloc_workqueue("kcryptd_io",
+				       WQ_HIGHPRI |
+				       WQ_MEM_RECLAIM,
+				       1);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
+		cc->crypt_queue = alloc_workqueue("kcryptd",
+						  WQ_HIGHPRI |
+						  WQ_MEM_RECLAIM, 1);
 	else
-		cc->crypt_queue = alloc_workqueue("kcryptd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+		cc->crypt_queue = alloc_workqueue("kcryptd",
+						  WQ_HIGHPRI |
+						  WQ_MEM_RECLAIM |
+						  WQ_UNBOUND,
 						  num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
-- 
2.9.3
