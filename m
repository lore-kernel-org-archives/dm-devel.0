From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 5/5] dm-writecache: output seq_count within status
Date: Thu, 31 Jan 2019 10:29:55 +0800
Message-ID: <20190131022955.9920-6-yehs2007@zoho.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190131022955.9920-1-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

seq_count is important for flush operations, output it within status
for debugging and analyzing code behavior.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 drivers/md/dm-writecache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2c1e825..3396710 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2231,9 +2231,9 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
+		DMEMIT("%ld %llu %llu %llu %llu", writecache_has_error(wc),
 		       (unsigned long long)wc->n_blocks, (unsigned long long)wc->freelist_size,
-		       (unsigned long long)wc->writeback_size);
+		       (unsigned long long)wc->writeback_size, wc->seq_count);
 		break;
 	case STATUSTYPE_TABLE:
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
-- 
1.8.3.1
