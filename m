From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix excessive alignment of
	metadata runs
Date: Wed, 13 Nov 2019 06:48:16 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911130625330.20335@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Metadata runs are supposed to be aligned on 4k boundary (so that they work
efficiently with disks with 4k sectors). However, there was a programming
bug that makes them aligned on 128k boundary instead. The unused space is
wasted.

This patch fixes the bug by providing a proper alignment. In order to keep
existing volumes working, we introduce a new flag SB_FLAG_FIXED_PADDING -
when the flag is clear, we calculate the padding the old way. In order to
make sure that the old version cannot mount the volume created by the new
version, we increase superblock version to 4.

In order to not break with old integritysetup, we fix alignment only if
the parameter "fix_padding" is present when formatting the device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |    5 ++
 drivers/md/dm-integrity.c                                |   26 ++++++++++=
++---
 2 files changed, 27 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/md/dm-integrity.c=092019-11-12 21:13:57.00000000=
0 +0100
+++ linux-2.6/drivers/md/dm-integrity.c=092019-11-13 12:29:00.000000000 +01=
00
@@ -53,6 +53,7 @@
 #define SB_VERSION_1=09=09=091
 #define SB_VERSION_2=09=09=092
 #define SB_VERSION_3=09=09=093
+#define SB_VERSION_4=09=09=094
 #define SB_SECTORS=09=09=098
 #define MAX_SECTORS_PER_BLOCK=09=098
=20
@@ -73,6 +74,7 @@ struct superblock {
 #define SB_FLAG_HAVE_JOURNAL_MAC=090x1
 #define SB_FLAG_RECALCULATING=09=090x2
 #define SB_FLAG_DIRTY_BITMAP=09=090x4
+#define SB_FLAG_FIXED_PADDING=09=090x8
=20
 #define=09JOURNAL_ENTRY_ROUNDUP=09=098
=20
@@ -250,6 +252,7 @@ struct dm_integrity_c {
 =09bool journal_uptodate;
 =09bool just_formatted;
 =09bool recalculate_flag;
+=09bool fix_padding;
=20
 =09struct alg_spec internal_hash_alg;
 =09struct alg_spec journal_crypt_alg;
@@ -463,7 +466,9 @@ static void wraparound_section(struct dm
=20
 static void sb_set_version(struct dm_integrity_c *ic)
 {
-=09if (ic->mode =3D=3D 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BI=
TMAP))
+=09if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
+=09=09ic->sb->version =3D SB_VERSION_4;
+=09else if (ic->mode =3D=3D 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIR=
TY_BITMAP))
 =09=09ic->sb->version =3D SB_VERSION_3;
 =09else if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULAT=
ING))
 =09=09ic->sb->version =3D SB_VERSION_2;
@@ -2955,6 +2960,7 @@ static void dm_integrity_status(struct d
 =09=09arg_count +=3D !!ic->internal_hash_alg.alg_string;
 =09=09arg_count +=3D !!ic->journal_crypt_alg.alg_string;
 =09=09arg_count +=3D !!ic->journal_mac_alg.alg_string;
+=09=09arg_count +=3D (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) =
!=3D 0;
 =09=09DMEMIT("%s %llu %u %c %u", ic->dev->name, (unsigned long long)ic->st=
art,
 =09=09       ic->tag_size, ic->mode, arg_count);
 =09=09if (ic->meta_dev)
@@ -2974,6 +2980,8 @@ static void dm_integrity_status(struct d
 =09=09=09DMEMIT(" sectors_per_bit:%llu", (unsigned long long)ic->sectors_p=
er_block << ic->log2_blocks_per_bitmap_bit);
 =09=09=09DMEMIT(" bitmap_flush_interval:%u", jiffies_to_msecs(ic->bitmap_f=
lush_interval));
 =09=09}
+=09=09if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) !=3D 0)
+=09=09=09DMEMIT(" fix_padding");
=20
 #define EMIT_ALG(a, n)=09=09=09=09=09=09=09\
 =09=09do {=09=09=09=09=09=09=09\
@@ -3042,8 +3050,14 @@ static int calculate_device_limits(struc
 =09if (!ic->meta_dev) {
 =09=09sector_t last_sector, last_area, last_offset;
=20
+=09=09/* we have to maintain excessive padding for compatibility with exis=
ting volumes */
+=09=09u64 metadata_run_padding =3D
+=09=09=09ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING) ?
+=09=09=09(__u64)(METADATA_PADDING_SECTORS << SECTOR_SHIFT) :
+=09=09=09(__u64)(1 << SECTOR_SHIFT << METADATA_PADDING_SECTORS);
+
 =09=09ic->metadata_run =3D roundup((__u64)ic->tag_size << (ic->sb->log2_in=
terleave_sectors - ic->sb->log2_sectors_per_block),
-=09=09=09=09=09   (__u64)(1 << SECTOR_SHIFT << METADATA_PADDING_SECTORS)) =
>> SECTOR_SHIFT;
+=09=09=09=09=09   metadata_run_padding) >> SECTOR_SHIFT;
 =09=09if (!(ic->metadata_run & (ic->metadata_run - 1)))
 =09=09=09ic->log2_metadata_run =3D __ffs(ic->metadata_run);
 =09=09else
@@ -3086,6 +3100,8 @@ static int initialize_superblock(struct
 =09=09journal_sections =3D 1;
=20
 =09if (!ic->meta_dev) {
+=09=09if (ic->fix_padding)
+=09=09=09ic->sb->flags |=3D cpu_to_le32(SB_FLAG_FIXED_PADDING);
 =09=09ic->sb->journal_sections =3D cpu_to_le32(journal_sections);
 =09=09if (!interleave_sectors)
 =09=09=09interleave_sectors =3D DEFAULT_INTERLEAVE_SECTORS;
@@ -3725,6 +3741,8 @@ static int dm_integrity_ctr(struct dm_ta
 =09=09=09=09goto bad;
 =09=09} else if (!strcmp(opt_string, "recalculate")) {
 =09=09=09ic->recalculate_flag =3D true;
+=09=09} else if (!strcmp(opt_string, "fix_padding")) {
+=09=09=09ic->fix_padding =3D true;
 =09=09} else {
 =09=09=09r =3D -EINVAL;
 =09=09=09ti->error =3D "Invalid argument";
@@ -3867,7 +3885,7 @@ static int dm_integrity_ctr(struct dm_ta
 =09=09=09should_write_sb =3D true;
 =09}
=20
-=09if (!ic->sb->version || ic->sb->version > SB_VERSION_3) {
+=09if (!ic->sb->version || ic->sb->version > SB_VERSION_4) {
 =09=09r =3D -EINVAL;
 =09=09ti->error =3D "Unknown version";
 =09=09goto bad;
@@ -4182,7 +4200,7 @@ static void dm_integrity_dtr(struct dm_t
=20
 static struct target_type integrity_target =3D {
 =09.name=09=09=09=3D "integrity",
-=09.version=09=09=3D {1, 3, 0},
+=09.version=09=09=3D {1, 4, 0},
 =09.module=09=09=09=3D THIS_MODULE,
 =09.features=09=09=3D DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 =09.ctr=09=09=09=3D dm_integrity_ctr,
Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst=
=092019-10-10 16:51:56.000000000 +0200
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst=0920=
19-11-13 12:24:48.000000000 +0100
@@ -177,6 +177,11 @@ bitmap_flush_interval:number
 =09The bitmap flush interval in milliseconds. The metadata buffers
 =09are synchronized when this interval expires.
=20
+fix_padding
+=09Use a smaller padding of the tag area that is more
+=09space-efficient. If this option is not present, large padding is
+=09used - that is for compatibility with older kernels.
+
=20
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time can
 be changed when reloading the target (load an inactive table and swap the
