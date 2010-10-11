From: Tejun Heo <tj@kernel.org>
Subject: [PATCH wq#for-next] workqueue: fix HIGHPRI handling in keep_working()
Date: Mon, 11 Oct 2010 12:09:18 +0200
Message-ID: <4CB2E24E.3020209@kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <4CAE1F47.3050105@kernel.org> <4CAE29CC.8030702@redhat.com> <4CAF4E93.1040101@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CAF4E93.1040101@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, just.for.lkml@googlemail.com, hch@infradead.org, herbert@gondor.hengli.com.au
List-Id: dm-devel.ids

The policy function keep_working() didn't check GCWQ_HIGHPRI_PENDING
and could return %false with highpri work pending.  This could lead to
late execution of a highpri work which was delayed due to @max_active
throttling if other works are actively consuming CPU cycles.

For example, the following could happen.

1. Work W0 which burns CPU cycles.

2. Two works W1 and W2 are queued to a highpri wq w/ @max_active of 1.

3. W1 starts executing and W2 is put to delayed queue.  W0 and W1 are
   both runnable.

4. W1 finishes which puts W2 to pending queue but keep_working()
   incorrectly returns %false and the worker goes to sleep.

5. W0 finishes and W2 starts execution.

With this patch applied, W2 starts execution as soon as W1 finishes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This is the workqueue bug I've found while trying to debug the dm/raid
hang.  Although the bug may introduce unexpected delay in scheduling a
highpri work, the delay can only be as long as the combined length of
CPU cycle burns of the already running works.  Given that HIGHPRI is
currently only used by xfs and its usage, I don't think it's likely to
cause an actual issue.  I'll queue it for #for-next.

Thank you.

 kernel/workqueue.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f77afd9..d355278 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -604,7 +604,9 @@ static bool keep_working(struct global_cwq *gcwq)
 {
 	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);

-	return !list_empty(&gcwq->worklist) && atomic_read(nr_running) <= 1;
+	return !list_empty(&gcwq->worklist) &&
+		(atomic_read(nr_running) <= 1 ||
+		 gcwq->flags & GCWQ_HIGHPRI_PENDING);
 }

 /* Do we need a new worker?  Called from manager. */
-- 
1.7.1
