From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] realtime: avoid BUG when the list is not
	locked
Date: Mon, 11 Nov 2019 08:59:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911110853100.30532@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Scott Wood <swood@redhat.com>
Cc: dm-devel@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>
List-Id: dm-devel.ids

list_bl.h would crash with BUG() if we used it without locking.=20
dm-snapshot uses its own locking on readltime kernels, so to avoid this=20
BUG, we must set LIST_BL_LOCKMASK =3D 0.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-rt-devel/include/linux/list_bl.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-rt-devel.orig/include/linux/list_bl.h=092019-11-07 14:01:51.00000=
0000 +0100
+++ linux-rt-devel/include/linux/list_bl.h=092019-11-08 10:12:49.000000000 =
+0100
@@ -19,7 +19,7 @@
  * some fast and compact auxiliary data.
  */
=20
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+#if (defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)) && !defined(CO=
NFIG_PREEMPT_RT_BASE)
 #define LIST_BL_LOCKMASK=091UL
 #else
 #define LIST_BL_LOCKMASK=090UL
@@ -161,9 +161,6 @@ static inline void hlist_bl_lock(struct
 =09bit_spin_lock(0, (unsigned long *)b);
 #else
 =09raw_spin_lock(&b->lock);
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-=09__set_bit(0, (unsigned long *)b);
-#endif
 #endif
 }
=20
@@ -172,9 +169,6 @@ static inline void hlist_bl_unlock(struc
 #ifndef CONFIG_PREEMPT_RT_BASE
 =09__bit_spin_unlock(0, (unsigned long *)b);
 #else
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-=09__clear_bit(0, (unsigned long *)b);
-#endif
 =09raw_spin_unlock(&b->lock);
 #endif
 }
