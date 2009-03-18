From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/8] dm core: reject I/O violating new queue
	limits
Date: Wed, 18 Mar 2009 17:53:09 +0900
Message-ID: <49C0B675.6000905@ct.jp.nec.com>
References: <49C0B474.4000204@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B474.4000204@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch detects requests violating the queue limitations
and rejects them.

The same limitation checks are done when requests are submitted
to the queue by blk_insert_cloned_request().
However, such violation can happen if a table is swapped and
the queue limitations are shrunk while some requests are
in the queue.

Since struct request is a reliable one in the block layer and
device drivers, dispatching such requests is pretty dangerous.
(e.g. it may cause kernel panic easily.)
So avoid to dispatch such problematic requests in request-based dm.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: 2.6.29-rc8/drivers/md/dm.c
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm.c
+++ 2.6.29-rc8/drivers/md/dm.c
@@ -1492,6 +1492,30 @@ static void map_request(struct dm_target
 	dm_get(md);
 
 	tio->ti = ti;
+
+	/*
+	 * Although submitted requests to the md->queue are checked against
+	 * the table/queue limitations at the submission time, the limitations
+	 * may be changed by a table swapping while those already checked
+	 * requests are in the md->queue.
+	 * If the limitations have been shrunk in such situations, we may be
+	 * dispatching requests violating the current limitations here.
+	 * Since struct request is a reliable one in the block-layer
+	 * and device drivers, dispatching such requests is dangerous.
+	 * (e.g. it may cause kernel panic easily.)
+	 * Avoid to dispatch such problematic requests in request-based dm.
+	 *
+	 * Since dm_kill_unmapped_request() expects that tio->ti is correctly
+	 * set, this has to be done after the set.
+	 */
+	r = blk_rq_check_limits(rq->q, rq);
+	if (unlikely(r)) {
+		DMWARN("violating the queue limitation. the limitation may be"
+		       " shrunk while there are some requests in the queue.");
+		dm_kill_unmapped_request(clone, r);
+		return;
+	}
+
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
