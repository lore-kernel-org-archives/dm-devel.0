From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH RT 1/2 v2] dm-snapshot: fix crash with the realtime kernel
Date: Tue, 12 Nov 2019 11:09:51 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: Nikos Tsironis <ntsironis@arrikto.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-rt-users@vger.kernel.org, tglx@linutronix.de
List-Id: dm-devel.ids

Snapshot doesn't work with realtime kernels since the commit f79ae415b64c.
hlist_bl is implemented as a raw spinlock and the code takes two non-raw
spinlocks while holding hlist_bl (non-raw spinlocks are blocking mutexes
in the realtime kernel).

We can't change hlist_bl to use non-raw spinlocks, this triggers warnings=
=20
in dentry lookup code, because the dentry lookup code uses hlist_bl while=
=20
holding a seqlock.

This patch fixes the problem by using non-raw spinlock=20
exception_table_lock instead of the hlist_bl lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f79ae415b64c ("dm snapshot: Make exception tables scalable")

---
 drivers/md/dm-snap.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6/drivers/md/dm-snap.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/md/dm-snap.c=092019-11-12 16:44:36.000000000 +01=
00
+++ linux-2.6/drivers/md/dm-snap.c=092019-11-12 17:01:46.000000000 +0100
@@ -141,6 +141,10 @@ struct dm_snapshot {
 =09 * for them to be committed.
 =09 */
 =09struct bio_list bios_queued_during_merge;
+
+#ifdef CONFIG_PREEMPT_RT_BASE
+=09spinlock_t exception_table_lock;
+#endif
 };
=20
 /*
@@ -625,30 +629,46 @@ static uint32_t exception_hash(struct dm
=20
 /* Lock to protect access to the completed and pending exception hash tabl=
es. */
 struct dm_exception_table_lock {
+#ifndef CONFIG_PREEMPT_RT_BASE
 =09struct hlist_bl_head *complete_slot;
 =09struct hlist_bl_head *pending_slot;
+#else
+=09spinlock_t *lock;
+#endif
 };
=20
 static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t ch=
unk,
 =09=09=09=09=09 struct dm_exception_table_lock *lock)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 =09struct dm_exception_table *complete =3D &s->complete;
 =09struct dm_exception_table *pending =3D &s->pending;
=20
 =09lock->complete_slot =3D &complete->table[exception_hash(complete, chunk=
)];
 =09lock->pending_slot =3D &pending->table[exception_hash(pending, chunk)];
+#else
+=09lock->lock =3D &s->exception_table_lock;
+#endif
 }
=20
 static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 =09hlist_bl_lock(lock->complete_slot);
 =09hlist_bl_lock(lock->pending_slot);
+#else
+=09spin_lock(lock->lock);
+#endif
 }
=20
 static void dm_exception_table_unlock(struct dm_exception_table_lock *lock=
)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 =09hlist_bl_unlock(lock->pending_slot);
 =09hlist_bl_unlock(lock->complete_slot);
+#else
+=09spin_unlock(lock->lock);
+#endif
 }
=20
 static int dm_exception_table_init(struct dm_exception_table *et,
@@ -1318,6 +1338,9 @@ static int snapshot_ctr(struct dm_target
 =09s->first_merging_chunk =3D 0;
 =09s->num_merging_chunks =3D 0;
 =09bio_list_init(&s->bios_queued_during_merge);
+#ifdef CONFIG_PREEMPT_RT_BASE
+=09spin_lock_init(&s->exception_table_lock);
+#endif
=20
 =09/* Allocate hash table for COW data */
 =09if (init_hash_tables(s)) {
