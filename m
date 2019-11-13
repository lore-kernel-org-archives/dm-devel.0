From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH RT 2/2 v4] list_bl: avoid BUG when the list is not locked
Date: Wed, 13 Nov 2019 15:10:42 +0200
Message-ID: <20191113131042.7719-1-ntsironis@arrikto.com>
References: <alpine.LRH.2.02.1911121110430.12815@file01.intranet.prod.int.rdu2.redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1911121110430.12815@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com, tglx@linutronix.de, linux-rt-users@vger.kernel.org, msnitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: swood@redhat.com, linux-fsdevel@vger.kernel.org, dwagner@suse.de, bigeasy@linutronix.de, iliastsi@arrikto.com, ntsironis@arrikto.com
List-Id: dm-devel.ids

list_bl would crash with BUG() if we used it without locking.
dm-snapshot uses its own locking on realtime kernels (it can't use
list_bl because list_bl uses raw spinlock and dm-snapshot takes other
non-raw spinlocks while holding bl_lock).

To avoid this BUG we deactivate the list debug checks for list_bl on
realtime kernels.

This patch is intended only for the realtime kernel patchset, not for
the upstream kernel.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
---
 include/linux/list_bl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index da38433240f5..3585b2f6b948 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -25,7 +25,7 @@
 #define LIST_BL_LOCKMASK	0UL
 #endif
 
-#ifdef CONFIG_DEBUG_LIST
+#if defined(CONFIG_DEBUG_LIST) && !defined(CONFIG_PREEMPT_RT_BASE)
 #define LIST_BL_BUG_ON(x) BUG_ON(x)
 #else
 #define LIST_BL_BUG_ON(x)
-- 
2.11.0
