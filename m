From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm table: do not allow queue limits that will
 exceed hardware limits
Date: Fri, 14 Sep 2012 16:41:33 -0400
Message-ID: <20120914204133.GA376@redhat.com>
References: <20120831150428.GA31566@fury.redhat.com>
	<20120904145843.GA19388@redhat.com>
	<20120912193706.GA17101@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120912193706.GA17101@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Jeffery <djeffery@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

DM recalculates queue limits based only on devices which currently exist
in the table.  This creates a problem in the event all devices are
temporarily removed such as all fibre channel paths being lost in
multipath.  DM will reset the limits to the maximum permissible, which
can then assemble requests which exceed the limits of the paths when the
paths are restored.  The request will fail the blk_rq_check_limits()
test when sent to a path with lower limits, and will be retried without
end by multipath.  This became a much bigger issue after commit
fe86cdcef ("block: do not artificially constrain max_sectors for
stacking drivers").

Add a safety net that will establish safe default limits, via
blk_set_default_limits, in the event that a table temporarily doesn't
have any component devices.  The default limits may be too conservative
once paths are reinstated but adding a path to a multipath device
requires a table reload.  Once the table is reloaded proper limits
will be established based on the available component device(s).

Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

v2: adjust the patch header to be more succinct

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f6979ad..9b931b4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1264,6 +1264,15 @@ combine_limits:
 			       (unsigned long long) ti->len);
 	}
 
+	/*
+	 * If a table doesn't have any component devices (e.g. multipath
+	 * loses all paths) don't allow the queue_limits to be left at
+	 * their maximum (as established by blk_set_stacking_limits() so
+	 * limits could be inherited from component devices).
+	 */
+	if (limits->max_sectors == UINT_MAX)
+		blk_set_default_limits(limits);
+
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
-- 
1.7.1
