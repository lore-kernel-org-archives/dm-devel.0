From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH v2] dm writecache: reject asynchronous pmem.
Date: Tue, 30 Jun 2020 16:53:35 +0200
Message-ID: <20200630145335.1185-1-msuchanek@suse.de>
References: <20200630133546.GA20439@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200630133546.GA20439@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Michal Suchanek <msuchanek@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Jan Kara <jack@suse.cz>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Yuval Shaia <yuval.shaia@oracle.com>, Dan Williams <dan.j.williams@intel.com>, Cornelia Huck <cohuck@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Jakub Staron <jstaron@google.com>, linux-kernel@vger.kernel.org
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
index 30505d70f423..1e4f37249e28 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2271,6 +2271,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			ti->error = "Unable to map persistent memory for cache";
 			goto bad;
 		}
+
+		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
+			r = -EOPNOTSUPP;
+			ti->error = "Asynchronous persistent memory not supported as pmem cache";
+			goto bad;
+		}
 	} else {
 		size_t n_blocks, n_metadata_blocks;
 		uint64_t n_bitmap_bits;
-- 
2.26.2
