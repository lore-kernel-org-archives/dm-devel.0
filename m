From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Remove might_sleep from wait_event_cmd
Date: Mon, 2 Feb 2015 09:39:02 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502020935580.13510@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Neil Brown <neilb@suse.de>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

Please apply this before 3.19 is released.

Mikulas


The patch e22b886a8a43b147e1994a9f970f678fc0df2033 introduced a bug in the
raid5 subsystem.

The function raid5_quiesce (and resize_stripes) calls 
lock_all_device_hash_locks_irq that disables interrupts and takes a few 
spinlocks, then it calls wait_event_cmd with cmd1 
unlock_all_device_hash_locks_irq(conf) and cmd2 
lock_all_device_hash_locks_irq(conf). cmd1 unlocks the spinlocks and 
enables interrupts, cmd2 disables interrupts and locks the spinlock.

The patch e22b886a8a43b147e1994a9f970f678fc0df2033 adds might_sleep() to a
position where spinlocks are taken, thus it introduces a bug.

This patch removes might_sleep() from wait_event_cmd.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/wait.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/include/linux/wait.h
===================================================================
--- linux-2.6.orig/include/linux/wait.h	2014-12-30 01:19:25.564231262 +0100
+++ linux-2.6/include/linux/wait.h	2015-02-02 15:30:16.766354658 +0100
@@ -363,7 +363,6 @@ do {									\
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
-	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
