From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: allow a target to relax discard restrictions
Date: Wed, 27 Apr 2011 17:55:38 -0400
Message-ID: <20110427215537.GA13386@redhat.com>
References: <20110427150623.GC13487@infradead.org>
	<20110427151911.GF7294@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110427151911.GF7294@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A target, like the upcoming thin provisioning target, may want to allow
discards even if the underlying devices do not support them natively.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c         |    4 ++++
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cb8380c..75b0430 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1354,6 +1354,10 @@ bool dm_table_supports_discards(struct dm_table *t)
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
+		/* target supports discards even if underlying devices cannot */
+		if (ti->discards_supported)
+			return 1;
+
 		if (ti->type->iterate_devices &&
 		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
 			return 1;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 32a4423..c9e7ff5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -191,6 +191,12 @@ struct dm_target {
 
 	/* Used to provide an error string from the ctr */
 	char *error;
+
+	/*
+	 * Enable discards even if the table's underlying devices
+	 * do not have native discard support.
+	 */
+	unsigned discards_supported:1;
 };
 
 /* Each target can link one of these into the table */
