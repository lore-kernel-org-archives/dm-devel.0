From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 0/4] Misc dm writecache patches
Date: Thu, 25 Apr 2019 21:31:16 +0800
Message-ID: <20190425133120.13088-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

This patch set is a collection about some patches for dm-writecache.

Patches 0001-0003 have got Acked-by or Signed-off-by from the author and
dm maintainer.

Patches 0004 is still under review. Any comments and suggestion are welcome.

Huaisheng Ye (4):
  dm writecache: remove needless dereferences in
    __writecache_writeback_pmem()
  dm writecache: add unlikely for returned value of rb_next/prev
  dm writecache: remove unused member page_offset in writeback_struct
  dm writecache: avoid unnecessary lookups in writecache_find_entry

 drivers/md/dm-writecache.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

-- 
1.8.3.1
