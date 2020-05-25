From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/16] block: use __this_cpu_add() instead of access by smp_processor_id()
Date: Mon, 25 May 2020 13:30:13 +0200
Message-ID: <20200525113014.345997-16-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Most architectures have fast path to access percpu for current cpu.
The required preempt_disable() is provided by part_stat_lock().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
[hch: rebased]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/part_stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index a6b0938ce82e9..24125778ef3ec 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -54,7 +54,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 	 part_stat_read(part, field[STAT_DISCARD]))
 
 #define __part_stat_add(part, field, addnd)				\
-	(part_stat_get(part, field) += (addnd))
+	__this_cpu_add((part)->dkstats->field, addnd)
 
 #define part_stat_add(part, field, addnd)	do {			\
 	__part_stat_add((part), field, addnd);				\
-- 
2.26.2
