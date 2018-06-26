From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 0/3] Fix DM DAX handling
Date: Tue, 26 Jun 2018 11:59:29 -0600
Message-ID: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: dm-devel.ids

This series fixes a few issues that I found with DM's handling of DAX
devices.  Here are some of the issues I found:

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a raw PMEM namespace but which can hold a
   filesystem mounted with the -o dax mount option.  DAX operations to
   the raw PMEM namespace part lack struct page and can fail in
   interesting/unexpected ways when doing things like fork(), examining
   memory with gdb, etc.

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
   mounted with the -o dax mount option.  All I/O to this filesystem
   will fail.

---

Changes since v2:
  * Only set QUEUE_FLAG_DAX for fsdax mode PMEM namespaces. (Mike)
  * Check for QUEUE_FLAG_DAX in __bdev_dax_supported(). (Mike)
  * Get rid of DM_TYPE_DAX_BIO_BASED reworks. (Mike)
  * Dropped the first 2 prep patches of v2 since they were merged for
    v4.18-rc1.  (Thanks, Darrick!)

---

Mike, can you take this series through your tree?

Personally I think this should be treated as a bug fix and merged in the
v4.18-rc* series.

Ross Zwisler (3):
  pmem: only set QUEUE_FLAG_DAX for fsdax mode
  dax: bdev_dax_supported() check for QUEUE_FLAG_DAX
  dm: prevent DAX mounts if not supported

 drivers/dax/super.c           | 8 ++++++++
 drivers/md/dm-ioctl.c         | 5 +++++
 drivers/md/dm-table.c         | 7 +++----
 drivers/md/dm.c               | 3 +--
 drivers/nvdimm/pmem.c         | 3 ++-
 include/linux/device-mapper.h | 5 +++++
 6 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.14.4
