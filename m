From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] dm writecache: reject asynchronous pmem.
Date: Tue, 30 Jun 2020 14:35:28 +0200
Message-ID: <20200630123528.29660-1-msuchanek@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Michal Suchanek <msuchanek@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Jan Kara <jack@suse.cz>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Pankaj Gupta <pagupta@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, Cornelia Huck <cohuck@redhat.com>, Jakub Staron <jstaron@google.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The writecache driver does not handle asynchronous pmem. Reject it when
supplied as cache.

Link: https://lore.kernel.org/linux-nvdimm/87lfk5hahc.fsf@linux.ibm.com/
Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/md/dm-writecache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 30505d70f423..57b0a972f6fd 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2277,6 +2277,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
 
+		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
+			r = -EOPNOTSUPP;
+			ti->error = "Asynchronous persistent memory not supported as pmem cache";
+			goto bad;
+		}
+
 		bio_list_init(&wc->flush_list);
 		wc->flush_thread = kthread_create(writecache_flush_thread, wc, "dm_writecache_flush");
 		if (IS_ERR(wc->flush_thread)) {
-- 
2.26.2
