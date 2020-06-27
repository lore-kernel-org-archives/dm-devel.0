From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] cgroup: unexport cgroup_rstat_updated
Date: Sat, 27 Jun 2020 09:31:56 +0200
Message-ID: <20200627073159.2447325-12-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

cgroup_rstat_updated is only used by core block code, no need to
export it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/cgroup/rstat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b6397a186ce9c8..d51175cedfca4f 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -64,7 +64,6 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
-EXPORT_SYMBOL_GPL(cgroup_rstat_updated);
 
 /**
  * cgroup_rstat_cpu_pop_updated - iterate and dismantle rstat_cpu updated tree
-- 
2.26.2
