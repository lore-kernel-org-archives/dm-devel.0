From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/14] dm, persistence: Remove a dead assignment
Date: Fri, 18 Nov 2016 14:28:32 -0800
Message-ID: <a5af7603-68f9-2f82-69f5-0140e1f2e736@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

A value is assigned to 'nr_entries' but is never used. Hence remove
that variable.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/persistent-data/dm-array.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index e83047c..7938cd2 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -700,13 +700,11 @@ static int populate_ablock_with_values(struct dm_array_info *info, struct array_
 {
 	int r;
 	unsigned i;
-	uint32_t nr_entries;
 	struct dm_btree_value_type *vt = &info->value_type;
 
 	BUG_ON(le32_to_cpu(ab->nr_entries));
 	BUG_ON(new_nr > le32_to_cpu(ab->max_entries));
 
-	nr_entries = le32_to_cpu(ab->nr_entries);
 	for (i = 0; i < new_nr; i++) {
 		r = fn(base + i, element_at(info, ab, i), context);
 		if (r)
-- 
2.10.1
