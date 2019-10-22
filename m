From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH RFC] dm dust: add limited write failure mode
Date: Tue, 22 Oct 2019 16:46:01 -0400
Message-ID: <1571777161-12082-1-git-send-email-bgurney@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Add a limited write failure mode, which will allow a write to a
block to fail a specified amount of times, prior to remapping.

Add an interface for limited write failures, to be added by the
following message:

(Example: add bad block on block 60, with 5 write failures)

dmsetup message 0 dust1 addbadblock 60 5

The write failure counter will be printed for newly added
bad blocks.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 48 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 8288887b7f94..3aecc0cb0fbd 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -17,6 +17,7 @@
 struct badblock {
 =09struct rb_node node;
 =09sector_t bb;
+=09unsigned char wr_fail_cnt;
 };
=20
 struct dust_device {
@@ -101,7 +102,9 @@ static int dust_remove_block(struct dust_device *dd, un=
signed long long block)
 =09return 0;
 }
=20
-static int dust_add_block(struct dust_device *dd, unsigned long long block=
)
+static int dust_add_block(struct dust_device *dd,
+=09=09=09=09unsigned long long block,
+=09=09=09=09unsigned char wr_fail_cnt)
 {
 =09struct badblock *bblock;
 =09unsigned long flags;
@@ -115,6 +118,7 @@ static int dust_add_block(struct dust_device *dd, unsig=
ned long long block)
=20
 =09spin_lock_irqsave(&dd->dust_lock, flags);
 =09bblock->bb =3D block;
+=09bblock->wr_fail_cnt =3D wr_fail_cnt;
 =09if (!dust_rb_insert(&dd->badblocklist, bblock)) {
 =09=09if (!dd->quiet_mode) {
 =09=09=09DMERR("%s: block %llu already in badblocklist",
@@ -127,7 +131,7 @@ static int dust_add_block(struct dust_device *dd, unsig=
ned long long block)
=20
 =09dd->badblock_count++;
 =09if (!dd->quiet_mode)
-=09=09DMINFO("%s: badblock added at block %llu", __func__, block);
+=09=09DMINFO("%s: badblock added at block %llu with write fail count %hhu"=
, __func__, block, wr_fail_cnt);
 =09spin_unlock_irqrestore(&dd->dust_lock, flags);
=20
 =09return 0;
@@ -175,10 +179,15 @@ static int dust_map_read(struct dust_device *dd, sect=
or_t thisblock,
 =09return ret;
 }
=20
-static void __dust_map_write(struct dust_device *dd, sector_t thisblock)
+static int __dust_map_write(struct dust_device *dd, sector_t thisblock)
 {
 =09struct badblock *bblk =3D dust_rb_search(&dd->badblocklist, thisblock);
=20
+=09if (bblk && bblk->wr_fail_cnt > 0) {
+=09=09bblk->wr_fail_cnt--;
+=09=09return DM_MAPIO_KILL;
+=09}
+
 =09if (bblk) {
 =09=09rb_erase(&bblk->node, &dd->badblocklist);
 =09=09dd->badblock_count--;
@@ -189,21 +198,24 @@ static void __dust_map_write(struct dust_device *dd, =
sector_t thisblock)
 =09=09=09       (unsigned long long)thisblock);
 =09=09}
 =09}
+
+=09return DM_MAPIO_REMAPPED;
 }
=20
 static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 =09=09=09  bool fail_read_on_bb)
 {
 =09unsigned long flags;
+=09int ret =3D DM_MAPIO_REMAPPED;
=20
 =09if (fail_read_on_bb) {
 =09=09thisblock >>=3D dd->sect_per_block_shift;
 =09=09spin_lock_irqsave(&dd->dust_lock, flags);
-=09=09__dust_map_write(dd, thisblock);
+=09=09ret =3D __dust_map_write(dd, thisblock);
 =09=09spin_unlock_irqrestore(&dd->dust_lock, flags);
 =09}
=20
-=09return DM_MAPIO_REMAPPED;
+=09return ret;
 }
=20
 static int dust_map(struct dm_target *ti, struct bio *bio)
@@ -377,6 +389,8 @@ static int dust_message(struct dm_target *ti, unsigned =
int argc, char **argv,
 =09bool invalid_msg =3D false;
 =09int result =3D -EINVAL;
 =09unsigned long long tmp, block;
+=09unsigned char wr_fail_cnt;
+=09unsigned int tmp_ui;
 =09unsigned long flags;
 =09char dummy;
=20
@@ -422,14 +436,36 @@ static int dust_message(struct dm_target *ti, unsigne=
d int argc, char **argv,
 =09=09}
=20
 =09=09if (!strcasecmp(argv[0], "addbadblock"))
-=09=09=09result =3D dust_add_block(dd, block);
+=09=09=09result =3D dust_add_block(dd, block, 0);
 =09=09else if (!strcasecmp(argv[0], "removebadblock"))
 =09=09=09result =3D dust_remove_block(dd, block);
 =09=09else if (!strcasecmp(argv[0], "queryblock"))
 =09=09=09result =3D dust_query_block(dd, block);
 =09=09else
 =09=09=09invalid_msg =3D true;
+=09} else if (argc =3D=3D 3) {
+=09=09if (sscanf(argv[1], "%llu%c", &tmp, &dummy) !=3D 1)
+=09=09=09return result;
+
+=09=09if (sscanf(argv[2], "%u%c", &tmp_ui, &dummy) !=3D 1)
+=09=09=09return result;
=20
+=09=09block =3D tmp;
+=09=09if (tmp_ui > 255) {
+=09=09=09DMERR("selected write fail count out of range");
+=09=09=09return result;
+=09=09}
+=09=09wr_fail_cnt =3D tmp_ui;
+=09=09sector_div(size, dd->sect_per_block);
+=09=09if (block > size) {
+=09=09=09DMERR("selected block value out of range");
+=09=09=09return result;
+=09=09}
+
+=09=09if (!strcasecmp(argv[0], "addbadblock"))
+=09=09=09result =3D dust_add_block(dd, block, wr_fail_cnt);
+=09=09else
+=09=09=09invalid_msg =3D true;
 =09} else
 =09=09DMERR("invalid number of arguments '%d'", argc);
=20
--=20
2.21.0
