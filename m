From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bio-prison-v2: replace spin_lock_irqsave with
 spin_lock_irq
Date: Wed, 23 Oct 2019 09:39:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910230939160.29580@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Replace spin_lock_irqsave/irqrestore with spin_lock_irq/spin_unlock_irq.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-prison-v2.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/md/dm-bio-prison-v2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/md/dm-bio-prison-v2.c=092019-10-10 16:52:03.0000=
00000 +0200
+++ linux-2.6/drivers/md/dm-bio-prison-v2.c=092019-10-16 17:08:47.000000000=
 +0200
@@ -177,11 +177,10 @@ bool dm_cell_get_v2(struct dm_bio_prison
 =09=09    struct dm_bio_prison_cell_v2 **cell_result)
 {
 =09int r;
-=09unsigned long flags;
=20
-=09spin_lock_irqsave(&prison->lock, flags);
+=09spin_lock_irq(&prison->lock);
 =09r =3D __get(prison, key, lock_level, inmate, cell_prealloc, cell_result=
);
-=09spin_unlock_irqrestore(&prison->lock, flags);
+=09spin_unlock_irq(&prison->lock);
=20
 =09return r;
 }
@@ -261,11 +260,10 @@ int dm_cell_lock_v2(struct dm_bio_prison
 =09=09    struct dm_bio_prison_cell_v2 **cell_result)
 {
 =09int r;
-=09unsigned long flags;
=20
-=09spin_lock_irqsave(&prison->lock, flags);
+=09spin_lock_irq(&prison->lock);
 =09r =3D __lock(prison, key, lock_level, cell_prealloc, cell_result);
-=09spin_unlock_irqrestore(&prison->lock, flags);
+=09spin_unlock_irq(&prison->lock);
=20
 =09return r;
 }
@@ -285,11 +283,9 @@ void dm_cell_quiesce_v2(struct dm_bio_pr
 =09=09=09struct dm_bio_prison_cell_v2 *cell,
 =09=09=09struct work_struct *continuation)
 {
-=09unsigned long flags;
-
-=09spin_lock_irqsave(&prison->lock, flags);
+=09spin_lock_irq(&prison->lock);
 =09__quiesce(prison, cell, continuation);
-=09spin_unlock_irqrestore(&prison->lock, flags);
+=09spin_unlock_irq(&prison->lock);
 }
 EXPORT_SYMBOL_GPL(dm_cell_quiesce_v2);
=20
@@ -309,11 +305,10 @@ int dm_cell_lock_promote_v2(struct dm_bi
 =09=09=09    unsigned new_lock_level)
 {
 =09int r;
-=09unsigned long flags;
=20
-=09spin_lock_irqsave(&prison->lock, flags);
+=09spin_lock_irq(&prison->lock);
 =09r =3D __promote(prison, cell, new_lock_level);
-=09spin_unlock_irqrestore(&prison->lock, flags);
+=09spin_unlock_irq(&prison->lock);
=20
 =09return r;
 }
@@ -342,11 +337,10 @@ bool dm_cell_unlock_v2(struct dm_bio_pri
 =09=09       struct bio_list *bios)
 {
 =09bool r;
-=09unsigned long flags;
=20
-=09spin_lock_irqsave(&prison->lock, flags);
+=09spin_lock_irq(&prison->lock);
 =09r =3D __unlock(prison, cell, bios);
-=09spin_unlock_irqrestore(&prison->lock, flags);
+=09spin_unlock_irq(&prison->lock);
=20
 =09return r;
 }
