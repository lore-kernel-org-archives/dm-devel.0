From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 2/4] dm clone: Add overflow check for number of
	regions
Date: Fri, 27 Mar 2020 16:01:09 +0200
Message-ID: <20200327140111.7798-3-ntsironis@arrikto.com>
References: <20200327140111.7798-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327140111.7798-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: ntsironis@arrikto.com
List-Id: dm-devel.ids

Add overflow check for clone->nr_regions variable, which holds the
number of regions of the target.

The overflow can occur with sufficiently large devices, if BITS_PER_LONG
== 32. E.g., if the region size is 8 sectors (4K), the overflow would
occur for device sizes > 34359738360 sectors (~16TB).

This could result in multiple device sectors wrongly mapping to the same
region number, due to the truncation from 64 bits to 32 bits, which
would lead to data corruption.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-target.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 022dddcad647..6ee85fb3388a 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1790,6 +1790,7 @@ static int copy_ctr_args(struct clone *clone, int argc, const char **argv, char
 static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
+	sector_t nr_regions;
 	struct clone *clone;
 	struct dm_arg_set as;
 
@@ -1831,7 +1832,16 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto out_with_source_dev;
 
 	clone->region_shift = __ffs(clone->region_size);
-	clone->nr_regions = dm_sector_div_up(ti->len, clone->region_size);
+	nr_regions = dm_sector_div_up(ti->len, clone->region_size);
+
+	/* Check for overflow */
+	if (nr_regions != (unsigned long)nr_regions) {
+		ti->error = "Too many regions. Consider increasing the region size";
+		r = -EOVERFLOW;
+		goto out_with_source_dev;
+	}
+
+	clone->nr_regions = nr_regions;
 
 	r = validate_nr_regions(clone->nr_regions, &ti->error);
 	if (r)
-- 
2.11.0
