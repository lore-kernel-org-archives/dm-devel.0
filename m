From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH] dm-bufio: Remove deprecated create_singlethread_workqueue
Date: Tue, 30 Aug 2016 22:19:11 +0530
Message-ID: <20160830164911.GA26756@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The workqueue "dm_bufio_wq" queues a single work item &dm_bufio_work and
hence it doesn't require execution ordering. Hence, alloc_workqueue has
been used to replace the deprecated create_singlethread_workqueue instance.

The WQ_MEM_RECLAIM flag has been set since md / dm are block multi disk
drivers and require forward progress under memory pressure.

Since there are fixed number of work items, explicit concurrency
limit is unnecessary here.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/md/dm-bufio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cd77216..d073ec1 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1876,7 +1876,7 @@ static int __init dm_bufio_init(void)
 	__cache_size_refresh();
 	mutex_unlock(&dm_bufio_clients_lock);

-	dm_bufio_wq = create_singlethread_workqueue("dm_bufio_cache");
+	dm_bufio_wq = alloc_workqueue("dm_bufio_cache", WQ_MEM_RECLAIM, 0);
 	if (!dm_bufio_wq)
 		return -ENOMEM;

--
2.1.4
