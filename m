From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC] updated DM table alignment validation patches
	[Was: Re: linux-next: block tree build failure]
Date: Tue, 26 May 2009 09:54:02 -0400
Message-ID: <20090526135402.GA3086@redhat.com>
References: <20090525143511.f9e76bdc.sfr@canb.auug.org.au>
	<yq1bpphg2st.fsf@sermon.lab.mkp.net>
	<20090525155426.28331f5f.sfr@canb.auug.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090525155426.28331f5f.sfr@canb.auug.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-next@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 25 2009 at  1:54am -0400,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Martin,
> 
> On Mon, 25 May 2009 01:38:26 -0400 "Martin K. Petersen" <martin.petersen@oracle.com> wrote:
> >
> > The accessor function patch in my patch series was explicitly put in
> > place to enable changing the API without affecting users.  And we've
> > tried to be careful about staging these patches in the right order
> > throughout all the involved trees.
> 
> What you really need is to have the patches that introduce the accessors
> in a tree common to all the possible users of them.  In practise this
> often means Linus' tree - in which case the patches should introduce noop
> versions of the accessors.  If that is possible, Linus is quite happy to
> take those patches after which all the other users can take the
> conversions into their own tree and everyone is happy.  :-)
> 
> Currently the patches that introduce the accessors only exist in the
> block tree ...

I've refreshed the DM linux-next patches that were off Martin's radar;
they are available here (and are also attached):

http://people.redhat.com/msnitzer/patches/dm-topology/dm-table-ensure-targets-are-aligned-to-logical_block_size.patch
http://people.redhat.com/msnitzer/patches/dm-topology/dm-table-validate-device-logical_block_size.patch

These updated patches still seem useful (as negative checks independent
of the topology code).

There is more work that is needed in DM and LVM2 userspace in order to
properly support and utilize the new topology infrastructure.  So I'm
also taking a much closer look at the needed changes now and should have
it sorted out in the coming days.

Mike



--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="dm-table-ensure-targets-are-aligned-to-logical_block_size.patch"

From: Mike Snitzer <snitzer@redhat.com>

Ensure I/O is aligned to the logical block size of target devices.

Rename check_device_area() to device_area_is_valid() for clarity and
establish the device limits including the logical block size prior to
calling it.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c |   54 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -385,15 +385,42 @@ static void close_dev(struct dm_dev_inte
 /*
  * If possible, this checks an area of a destination device is valid.
  */
-static int check_device_area(struct dm_dev_internal *dd, sector_t start,
-			     sector_t len)
+static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
+			     sector_t start, sector_t len)
 {
-	sector_t dev_size = dd->dm_dev.bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	unsigned short logical_block_size_sectors =
+		ti->limits.logical_block_size >> SECTOR_SHIFT;
+	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 1;
 
-	return ((start < dev_size) && (len <= (dev_size - start)));
+	if ((start >= dev_size) || (start + len > dev_size)) {
+		DMWARN("%s: %s too small for target",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		return 0;
+	}
+
+	if (logical_block_size_sectors <= 1)
+		return 1;
+
+	if (start & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: start=%llu not aligned to h/w sector of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start, bdevname(bdev, b));
+		return 0;
+	}
+
+	if (len & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: len=%llu not aligned to h/w sector size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
+		       ti->limits.logical_block_size, bdevname(bdev, b));
+		return 0;
+	}
+
+	return 1;
 }
 
 /*
@@ -479,14 +506,7 @@ static int __table_get_device(struct dm_
 	}
 	atomic_inc(&dd->count);
 
-	if (!check_device_area(dd, start, len)) {
-		DMWARN("device %s too small for target", path);
-		dm_put_device(ti, &dd->dm_dev);
-		return -EINVAL;
-	}
-
 	*result = &dd->dm_dev;
-
 	return 0;
 }
 
@@ -555,8 +575,16 @@ int dm_get_device(struct dm_target *ti, 
 	int r = __table_get_device(ti->table, ti, path,
 				   start, len, mode, result);
 
-	if (!r)
-		dm_set_device_limits(ti, (*result)->bdev);
+	if (r)
+		return r;
+
+	dm_set_device_limits(ti, (*result)->bdev);
+
+	if (!device_area_is_valid(ti, (*result)->bdev, start, len)) {
+		dm_put_device(ti, *result);
+		*result = NULL;
+		return -EINVAL;
+	}
 
 	return r;
 }

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="dm-table-validate-device-logical_block_size.patch"

From: Mike Snitzer <snitzer@redhat.com>

Impose necessary and sufficient conditions on a devices's table such
that any incoming bio which respects its logical_block_size can be
processed successfully.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -723,6 +723,71 @@ static void check_for_valid_limits(struc
 		rs->bounce_pfn = -1;
 }
 
+/*
+ * Impose necessary and sufficient conditions on a devices's table such
+ * that any incoming bio which respects its logical_block_size can be
+ * processed successfully.  If it falls across the boundary between
+ * two or more targets, the size of each piece it gets split into must
+ * be compatible with the logical_block_size of the target processing it.
+ */
+static int validate_hardware_logical_block_alignment(struct dm_table *table)
+{
+	/*
+	 * This function uses arithmetic modulo the logical_block_size
+	 * (in units of 512-byte sectors).
+	 */
+	unsigned short device_logical_block_size_sects =
+		table->limits.logical_block_size >> SECTOR_SHIFT;
+
+	/*
+	 * Offset of the start of the next table entry, mod logical_block_size.
+	 */
+	unsigned short next_target_start = 0;
+
+	/*
+	 * Given an aligned bio that extends beyond the end of a
+	 * target, how many sectors must the next target handle?
+	 */
+	unsigned short remaining = 0;
+
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0;
+
+	/*
+	 * Check each entry in the table in turn.
+	 */
+	while (i < dm_table_get_num_targets(table)) {
+		ti = dm_table_get_target(table, i++);
+
+		/*
+		 * If the remaining sectors fall entirely within this
+		 * table entry are they compatible with its logical_block_size?
+		 */
+		if (remaining < ti->len &&
+		    remaining & ((ti->limits.logical_block_size >>
+				  SECTOR_SHIFT) - 1))
+			break;	/* Error */
+
+		next_target_start =
+		    (unsigned short) ((next_target_start + ti->len) &
+				      (device_logical_block_size_sects - 1));
+		remaining = next_target_start ?
+		    device_logical_block_size_sects - next_target_start : 0;
+	}
+
+	if (remaining) {
+		DMWARN("%s: table line %u (start sect %llu len %llu) "
+		       "not aligned to hardware logical block size %hu",
+		       dm_device_name(table->md), i,
+		       (unsigned long long) ti->begin,
+		       (unsigned long long) ti->len,
+		       table->limits.logical_block_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -822,6 +887,10 @@ int dm_table_complete(struct dm_table *t
 
 	check_for_valid_limits(&t->limits);
 
+	r = validate_hardware_logical_block_alignment(t);
+	if (r)
+		return r;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--cWoXeonUoKmBZSoM--
