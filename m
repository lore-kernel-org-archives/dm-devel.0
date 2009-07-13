From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid1: wake the thread after adding bios to
	the queue
Date: Mon, 13 Jul 2009 09:33:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907130931550.6498@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi. I found this bug when reading dm-raid1.

Mikulas

---

The rule is that whether anything is being added on ms->reads, ms->writes or
ms->failures and the list was empty before, we must call wakeup_mirrord (for
immediate processing) or delayed_wake (for delayed processing).

Otherwise the thread wouldn't be woken up and bio could be sitting on the
list indefinitely.

Recent dm-raid1 clustering patch violate this rule.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
CC: stable@kernel.org

---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.31-rc2-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-rc2-devel.orig/drivers/md/dm-raid1.c	2009-07-13 15:14:55.000000000 +0200
+++ linux-2.6.31-rc2-devel/drivers/md/dm-raid1.c	2009-07-13 15:15:40.000000000 +0200
@@ -638,6 +638,7 @@ static void do_writes(struct mirror_set 
 		spin_lock_irq(&ms->lock);
 		bio_list_merge(&ms->writes, &requeue);
 		spin_unlock_irq(&ms->lock);
+		delayed_wake(ms);
 	}
 
 	/*
