From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] dm snapshot: fix error return code in snapshot_ctr()
Date: Fri, 19 Apr 2013 09:26:07 +0800
Message-ID: <CAPgLHd-ZjORYMQ9DSa_CBRipu8NnpOkpsqyswk8FG8cdi98dHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in create slab pool error case
instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-snap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index eb32e35..fb3ea3c 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1121,6 +1121,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 

