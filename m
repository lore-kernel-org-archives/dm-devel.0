From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 3/5] dm-writecache: expand pmem_reinit for struct
 dm_writecache
Date: Thu, 31 Jan 2019 10:29:53 +0800
Message-ID: <20190131022955.9920-4-yehs2007@zoho.com>
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

When use persistent memory as cache data device, sometimes
the super block of pmem has messy data stored in it. That would
have risk to lead fn ctr failed to work due to invalid magic or
version.

Here we expand pmem_reinit to optional parameters in order to solve
this issue. When user gets pmem device, which has unrelated data,
as cache device, he should use paramenter 'reinit' to avoid s.magic
and s.version don't equal to NULL or correct
MEMORY_SUPERBLOCK_MAGIC/VERSION.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 drivers/md/dm-writecache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index c69317c..2c1e825 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -149,6 +149,7 @@ struct dm_writecache {
 
 	bool pmem_mode:1;
 	bool writeback_fua:1;
+	bool pmem_reinit:1;
 
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
@@ -2026,6 +2027,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				wc->writeback_fua = false;
 				wc->writeback_fua_set = true;
 			} else goto invalid_optional;
+		} else if (!strcasecmp(string, "reinit")) {
+			if (WC_MODE_PMEM(wc))
+				wc->pmem_reinit = true;
+			else goto invalid_optional;
 		} else {
 invalid_optional:
 			r = -EINVAL;
@@ -2127,7 +2132,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		ti->error = "Hardware memory error when reading superblock";
 		goto bad;
 	}
-	if (!le32_to_cpu(s.magic) && !le32_to_cpu(s.version)) {
+	if (wc->pmem_reinit || (!le32_to_cpu(s.magic) && !le32_to_cpu(s.version))) {
 		r = init_memory(wc);
 		if (r) {
 			ti->error = "Unable to initialize device";
-- 
1.8.3.1
