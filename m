From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 09/20] dm-crypt: unify io_queue and crypt_queue
Date: Tue, 21 Aug 2012 11:09:20 +0200
Message-ID: <293ee774d85297bbdd40aada3e0279ec1d22bc7a.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Unify these two request queues. There is no need to have two queues, one
is enough. No encryption operations are done in the queue anyway.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 967d218..d6306f1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -127,7 +127,6 @@ struct crypt_config {
 	struct bio_set *bs;
 
 	struct workqueue_struct *io_queue;
-	struct workqueue_struct *crypt_queue;
 	unsigned crypt_threads_size;
 	int num_threads_value;	/* the value entered in the arguments */
 	struct task_struct **crypt_threads;
@@ -1281,7 +1280,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->cc;
 
 	INIT_WORK(&io->work, kcryptd_crypt);
-	queue_work(cc->crypt_queue, &io->work);
+	queue_work(cc->io_queue, &io->work);
 }
 
 /*
@@ -1432,8 +1431,6 @@ static void crypt_dtr(struct dm_target *ti)
 
 	if (cc->io_queue)
 		destroy_workqueue(cc->io_queue);
-	if (cc->crypt_queue)
-		destroy_workqueue(cc->crypt_queue);
 
 	crypt_free_tfms(cc);
 
@@ -1751,15 +1748,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_NON_REENTRANT|
-					  WQ_MEM_RECLAIM,
-					  1);
-	if (!cc->crypt_queue) {
-		ti->error = "Couldn't create kcryptd queue";
-		goto bad;
-	}
-
 	if (num_threads == num_online_cpus()) {
 		for (i = 0; i < NR_CPUS; i++)
 			if (cpu_online(i))
-- 
1.7.10.4
