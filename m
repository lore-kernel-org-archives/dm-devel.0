From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm table: verify a DM device is H/W
	sector aligned
Date: Wed, 22 Apr 2009 11:06:15 -0400
Message-ID: <20090422150615.GB32602@redhat.com>
References: <1240327259-14412-1-git-send-email-snitzer@redhat.com>
	<20090422132543.GA7778@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090422132543.GA7778@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 22 2009 at  9:25am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> I've tried to make this easier to understand.
> Please check I've not broken something in the process...

Looks good, I especially like what you did with the revised DM_WARN().
But there were some minor compiler warnings:

drivers/md/dm-table.c: In function =E2=80=98validate_hardsect_alignment=E2=
=80=99:
drivers/md/dm-table.c:763: warning: suggest parentheses around + or - in =
operand of &
drivers/md/dm-table.c: In function =E2=80=98dm_table_complete=E2=80=99:
drivers/md/dm-table.c:749: warning: =E2=80=98ti=E2=80=99 may be used unin=
itialized in this function

I fixed these warnings in the following revised patch.  I then fixed
this checkpatch warning (which resulted in somewhat uglier code):

WARNING: line over 80 characters
#74: FILE: drivers/md/dm-table.c:763:
+                   remaining & ((ti->limits.hardsect_size >> SECTOR_SHIF=
T) - 1))


diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 429b50b..73f0438 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -693,6 +693,71 @@ static void check_for_valid_limits(struct io_restric=
tions *rs)
 		rs->bounce_pfn =3D -1;
 }
=20
+/*
+ * Impose necessary and sufficient conditions on a devices's table such
+ * that any incoming bio which respects its hardsect_size can be
+ * processed successfully.  If it falls across the boundary between
+ * two or more targets, the size of each piece it gets split into must
+ * be compatible with the hardsect_size of the target processing it.
+ */
+static int validate_hardsect_alignment(struct dm_table *table)
+{
+	/*
+	 * This function uses arithmetic modulo the hardsect_size
+	 * (in units of 512-byte sectors).
+	 */
+	unsigned short device_hardsect_size_sects =3D
+			    table->limits.hardsect_size >> SECTOR_SHIFT;
+
+	/*
+	 * Offset of the start of the next table entry, mod hardsect_size.
+	 */
+	unsigned short next_target_start =3D 0;
+
+	/*
+	 * Given an aligned bio that extends beyond the end of a
+	 * target, how many sectors must the next target handle?
+	 */
+	unsigned short remaining =3D 0;
+
+	struct dm_target *ti =3D NULL;
+	unsigned i =3D 0;
+
+	/*
+	 * Check each entry in the table in turn.
+	 */
+	while (i < dm_table_get_num_targets(table)) {
+		ti =3D dm_table_get_target(table, i++);
+
+		/*
+		 * If the remaining sectors fall entirely within this
+		 * table entry are they compatible with its hardsect_size?
+		 */
+		if (remaining < ti->len &&
+		    remaining & ((ti->limits.hardsect_size >>
+				  SECTOR_SHIFT) - 1))
+			break;	/* Error */
+
+		next_target_start =3D
+		    (unsigned short) ((next_target_start + ti->len) &
+				      (device_hardsect_size_sects - 1));
+		remaining =3D next_target_start ?
+		    device_hardsect_size_sects - next_target_start : 0;
+	}
+
+	if (remaining) {
+		DMWARN("%s: table line %u (start sect %llu len %llu) "
+		       "not aligned to hardware sector size %hu",
+		       dm_device_name(table->md), i,
+		       (unsigned long long) ti->begin,
+		       (unsigned long long) ti->len,
+		       table->limits.hardsect_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -792,6 +857,10 @@ int dm_table_complete(struct dm_table *t)
=20
 	check_for_valid_limits(&t->limits);
=20
+	r =3D validate_hardsect_alignment(t);
+	if (r)
+		return r;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes =3D dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth =3D 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
