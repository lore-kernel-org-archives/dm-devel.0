From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 0/3] optimize writecache_writeback for performance
Date: Sun, 25 Aug 2019 15:24:30 +0800
Message-ID: <20190825072433.2628-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: prarit@redhat.com, tyu1@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

Patch 1 and 2 are used for cleaning the code, and they have got
Acked-by from Mikulas.

Patch 3 is used for performance optimization when writeback_all,
which could save more than half of time.
Of course, if the blocks in writecache are more uncontinuous and
disordered, the more performance improvement would be gained from
this patch.

Huaisheng Ye (3):
  dm writecache: remove unused member pointer in writeback_struct
  dm writecache: add unlikely for getting two block with same LBA
  dm writecache: optimize performance by sorting the blocks for
    writeback_all

 drivers/md/dm-writecache.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

-- 
1.8.3.1
