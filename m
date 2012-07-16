From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] dm: introduce split_discard_requests
Date: Mon, 16 Jul 2012 14:34:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

dm: introduce split_discard_requests

This patch introduces a new variable split_discard_requests. It can be
set by targets, when it is set, discard requests are split on max_io_len
boundary.

When split_discard_requests is not set, discard requests are split on
target boundary, as it used to be before this patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |    5 ++++-
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-3.4.4-fast/drivers/md/dm.c
===================================================================
--- linux-3.4.4-fast.orig/drivers/md/dm.c	2012-07-05 23:55:38.000000000 +0200
+++ linux-3.4.4-fast/drivers/md/dm.c	2012-07-05 23:56:41.000000000 +0200
@@ -1244,7 +1244,10 @@ static int __clone_and_map_discard(struc
 		if (!ti->num_discard_requests)
 			return -EOPNOTSUPP;
 
-		len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+		if (!ti->split_discard_requests)
+			len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+		else
+			len = min(ci->sector_count, max_io_len(ci->sector, ti));
 
 		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
 
Index: linux-3.4.4-fast/include/linux/device-mapper.h
===================================================================
--- linux-3.4.4-fast.orig/include/linux/device-mapper.h	2012-07-05 23:53:47.000000000 +0200
+++ linux-3.4.4-fast/include/linux/device-mapper.h	2012-07-05 23:59:37.000000000 +0200
@@ -220,6 +220,12 @@ struct dm_target {
 	unsigned discards_supported:1;
 
 	/*
+	 * Set if the target required discard request to be split
+	 * on max_io_len boundary.
+	 */
+	unsigned split_discard_requests:1;
+
+	/*
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	unsigned discard_zeroes_data_unsupported:1;
