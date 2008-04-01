From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 01/10] dm snapshot: Fix the fraction full
	percentage
Date: Tue,  1 Apr 2008 09:32:48 +0200
Message-ID: <1207035177-7156-2-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-1-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Make fraction_full() return a percentage of the amount of actual data
the device can hold, rather than of the amount of data+metadata it can
hold.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-exception-store.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 5bbce29..02fd3e9 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -429,11 +429,43 @@ static struct pstore *get_info(struct exception_store *store)
 	return (struct pstore *) store->context;
 }
 
+/*
+ * Calculate the number of chunks of data we can store in @n_chunks,
+ * given that each metadata area can store @exceptions_per_area
+ * exceptions.
+ */
+static inline uint32_t calc_n_data_chunks(uint32_t n_chunks,
+					  uint32_t exceptions_per_area)
+{
+	uint32_t stride, full_areas, leftovers;
+
+	/* we can't use the header */
+	if (--n_chunks <= 0)
+		return 0;
+
+	stride = exceptions_per_area + 1;
+
+	/* how many metadata areas would we completely fill? */
+	full_areas = n_chunks / stride;
+
+	/* how many chunks could we fit after the full areas? */
+	leftovers = n_chunks % stride;
+	if (leftovers - 1 <= 0)
+		leftovers = 0;
+
+	return (full_areas * exceptions_per_area) + leftovers;
+}
+
 static void persistent_fraction_full(struct exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
-	*numerator = get_info(store)->next_free * store->snap->chunk_size;
-	*denominator = get_dev_size(store->snap->cow->bdev);
+	struct pstore *ps = get_info(store);
+	uint32_t n_chunks;
+
+	n_chunks = get_dev_size(ps->snap->cow->bdev) >> ps->snap->chunk_shift;
+
+	*numerator = calc_n_data_chunks(ps->next_free, ps->exceptions_per_area);
+	*denominator = calc_n_data_chunks(n_chunks, ps->exceptions_per_area);
 }
 
 static void persistent_destroy(struct exception_store *store)
-- 
1.5.4.1
