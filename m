From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [resend PATCH v2 32/33] filesystem-dax: gate calls to dax_flush()
 on QUEUE_FLAG_WC
Date: Mon, 17 Apr 2017 12:11:43 -0700
Message-ID: <149245630377.10206.16395058260450137463.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

Some platforms arrange for cpu caches to be flushed on power-fail. On
those platforms there is no requirement that the kernel track and flush
potentially dirty cache lines. Given that we still insert entries into
the radix for locking purposes this patch only disables the cache flush
loop, not the dirty tracking.

Userspace can override the default cache setting via the block device
queue "write_cache" attribute in sysfs.

Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/dax.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f37ed21e4093..5b7ee1bc74d0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -797,7 +797,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
-	dax_flush(dax_dev, pgoff, kaddr, size);
+	if (test_bit(QUEUE_FLAG_WC, &bdev->bd_queue->queue_flags))
+		dax_flush(dax_dev, pgoff, kaddr, size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -982,7 +983,8 @@ int __dax_zero_page_range(struct block_device *bdev,
 			return rc;
 		}
 		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, pgoff, kaddr + offset, size);
+		if (test_bit(QUEUE_FLAG_WC, &bdev->bd_queue->queue_flags))
+			dax_flush(dax_dev, pgoff, kaddr + offset, size);
 		dax_read_unlock(id);
 	}
 	return 0;
