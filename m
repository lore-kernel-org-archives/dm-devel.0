From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 0/5] Optimize writecache when using pmem as cache
Date: Thu, 31 Jan 2019 10:29:50 +0800
Message-ID: <20190131022955.9920-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
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

This patch set could be used for dm-writecache when use persistent
memory as cache data device.

Patch 1 and 2 go towards removing unused parameter and codes which
actually doesn't really work.

Patch 3 and 4 are targeted at solving problem fn ctr failed to work
due to invalid magic or version, which is caused by the super block
of pmem has messy data stored.

Patch 5 is used for getting the status of seq_count.

Changes Since v2: 
        - seq_count is important for flush operations, output it within status
          for debugging and analyzing code behavior.
	[1]: https://lkml.org/lkml/2019/1/3/43
        [2]: https://lkml.org/lkml/2019/1/9/6

Huaisheng Ye (5):
  dm-writecache: remove unused size to writecache_flush_region
  dm-writecache: get rid of memory_data flush to writecache_flush_entry
  dm-writecache: expand pmem_reinit for struct dm_writecache
  Documentation/device-mapper: add optional parameter reinit
  dm-writecache: output seq_count within status

 Documentation/device-mapper/writecache.txt |  4 ++++
 drivers/md/dm-writecache.c                 | 23 +++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

-- 
1.8.3.1
