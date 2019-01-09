From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [RFC PATCH v2 0/4] add parameter for pmem cache device init
Date: Wed,  9 Jan 2019 13:31:23 +0800
Message-ID: <20190109053127.8128-1-yehs2007@zoho.com>
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
To: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

This patch set could be used for dm-writecache when use persistent
memory as cache data device.

Patch 1 and 2 go towards removing unused parameter and codes which
actually doesn't really work.

Patch 3 and 4 are targeted at solving problem fn ctr failed to work
due to invalid magic or version, which is caused by the super block
of pmem has messy data stored.

Changes Since v1:
	- add optional parameter reinit to avoid invalid magic or
	  version.
	[1]: https://lkml.org/lkml/2019/1/3/43

Huaisheng Ye (4):
  dm-writecache: remove unused size to writecache_flush_region
  dm-writecache: get rid of memory_data flush to writecache_flush_entry
  dm-writecache: expand pmem_reinit for struct dm_writecache
  Documentation/device-mapper: add optional parameter reinit

 Documentation/device-mapper/writecache.txt |  4 ++++
 drivers/md/dm-writecache.c                 | 19 +++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

-- 
1.8.3.1
