From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH RT 2/2 v2] list_bl: avoid BUG when the list is not locked
Date: Tue, 12 Nov 2019 11:16:29 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911121110430.12815@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, linux-rt-users@vger.kernel.org
Cc: Mike Snitzer <msnitzer@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: dm-devel.ids

list_bl would crash with BUG() if we used it without locking. dm-snapshot=
=20
uses its own locking on realtime kernels (it can't use list_bl because=20
list_bl uses raw spinlock and dm-snapshot takes other non-raw spinlocks=20
while holding bl_lock).

To avoid this BUG, we must set LIST_BL_LOCKMASK =3D 0.

This patch is intended only for the realtime kernel patchset, not for the=
=20
upstream kernel.

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
