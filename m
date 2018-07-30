From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 0/6] kaddr and pfn can be NULL to ->direct_access()
Date: Mon, 30 Jul 2018 15:15:42 +0800
Message-ID: <20180730071548.9172-1-yehs2007@zoho.com>
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
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

Changes since v2 [2]:
* Collect Martin and Mike's acks for dcssblk and dm-writecache;
* Rebase the series of patch to v4.18-rc7.

Changes since v1 [1]:
* Involve the previous patches for pfn can be NULL.
* Reword the patch descriptions according to Christian's comment.
* According to Ross's suggestion, replace local pointer dummy_addr
  with NULL within md/dm-writecache for direct_access.

[1]: https://lkml.org/lkml/2018/7/24/199
[2]: https://lkml.org/lkml/2018/7/25/581

Some functions within fs/dax, dax/super and md/dm-writecache don't
need to get local pointer kaddr or variable pfn from direct_access.
Assigning NULL to kaddr or pfn with ->direct_access() is more
straightforward and simple than offering a useless local pointer or
variable.

So all ->direct_access() need to check the validity of pointer kaddr
and pfn for NULL assignment. If either of them is equal to NULL, that
is to say callers may have no need for kaddr or pfn, so this series of
patch are prepared for allowing them to pass in NULL instead of having
to pass in a local pointer or variable that they then just throw away.

Huaisheng Ye (6):
  libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
  s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
  tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
  dax/super: Do not request a pointer kaddr when not required
  md/dm-writecache: Don't request pointer dummy_addr when not required
  filesystem-dax: Do not request kaddr and pfn when not required

 drivers/dax/super.c             |  3 +--
 drivers/md/dm-writecache.c      |  3 +--
 drivers/nvdimm/pmem.c           |  7 +++++--
 drivers/s390/block/dcssblk.c    |  8 +++++---
 fs/dax.c                        | 13 ++++---------
 tools/testing/nvdimm/pmem-dax.c | 12 ++++++++----
 6 files changed, 24 insertions(+), 22 deletions(-)

-- 
1.8.3.1
