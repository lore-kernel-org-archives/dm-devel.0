Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1BED29A
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 09:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 3AS9iIWO061665;
	Tue, 28 Nov 2023 17:44:18 +0800 (+08)
	(envelope-from Yunlong.Xing@unisoc.com)
Received: from SHDLP.spreadtrum.com (bjmbx02.spreadtrum.com [10.0.64.8])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4SfcpY5H47z2MxJxp;
	Tue, 28 Nov 2023 17:38:45 +0800 (CST)
Received: from tj10379pcu.spreadtrum.com (10.5.32.15) by
 BJMBX02.spreadtrum.com (10.0.64.8) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 28 Nov 2023 17:44:16 +0800
From: Yunlong Xing <yunlong.xing@unisoc.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
        <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: <yibin.ding@unisoc.com>, <hongyu.jin@unisoc.com>,
        <dongliang.cui@unisoc.com>, <yunlong.xing@unisoc.com>,
        <xiuhong.wang@unisoc.com>
Subject: [PATCH] dm: increase the io priority of the kworker-kverityd process
Date: Tue, 28 Nov 2023 17:44:14 +0800
Message-ID: <20231128094414.583666-1-yunlong.xing@unisoc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX02.spreadtrum.com (10.0.64.8)
X-MAIL:SHSQR01.spreadtrum.com 3AS9iIWO061665

From: Hongyu Jin <hongyu.jin@unisoc.com>

When obtaining the hash value of a high IO priority data block
from the disk, the kverity-worker that obtains the hash will
also have a high IO priority to avoid being blocked by other
IO with low IO priority.

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
---
 drivers/md/dm-verity-target.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e115fcfe723c..ade9c6734154 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/jump_label.h>
+#include <linux/ioprio.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -639,7 +640,9 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 static void verity_work(struct work_struct *w)
 {
 	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
+	struct bio *bio = dm_bio_from_per_bio_data(io, io->v->ti->per_io_data_size);
 
+	set_task_ioprio(current, bio->bi_ioprio);
 	io->in_tasklet = false;
 
 	verity_fec_init_io(io);
-- 
2.25.1

