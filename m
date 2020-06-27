From: Christoph Hellwig <hch@lst.de>
Subject: drive-by blk-cgroup cleanups
Date: Sat, 27 Jun 2020 09:31:45 +0200
Message-ID: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

Hi all,

while looking into another "project" I ended up wading through the
blkcq code for research and found a bunch of lose ends.  So here is
a bunch of drive-by cleanups for the code.

Diffstat:
 block/bio.c                |  143 +----------------------------------
 block/blk-cgroup.c         |  182 +++++++++++++++++++++++++++++++++++++--------
 block/blk-core.c           |    7 +
 block/blk-throttle.c       |   10 +-
 block/blk.h                |    2 
 drivers/md/dm.c            |    5 -
 include/linux/bio.h        |    9 --
 include/linux/blk-cgroup.h |  101 ------------------------
 kernel/cgroup/rstat.c      |    1 
 mm/page_io.c               |   17 ++++
 10 files changed, 192 insertions(+), 285 deletions(-)
