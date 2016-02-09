From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm: check for kmalloc failure in
 dm_init_request_based_blk_mq_queue()
Date: Tue, 9 Feb 2016 14:14:40 +0300
Message-ID: <20160209111440.GB23998@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

We can just return -ENOMEM if the kzalloc() fails.

Fixes: 41b2facaf4ba ('dm: allocate blk_mq_tag_set rather than embed in mapped_device')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6b7e80e..1a5f879 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2736,6 +2736,8 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md,
 	int err;
 
 	md->tag_set = kzalloc(sizeof(struct blk_mq_tag_set), GFP_KERNEL);
+	if (!md->tag_set)
+		return -ENOMEM;
 	md->tag_set->ops = &dm_mq_ops;
 	md->tag_set->queue_depth = dm_get_blk_mq_queue_depth();
 	md->tag_set->numa_node = NUMA_NO_NODE;
