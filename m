From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/7] Explicitly initialize bio lists
Date: Wed, 18 Nov 2009 07:10:31 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
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

Explicitly initialize bio lists.

Currently, zeroing the list with kzalloc already does the initialization,
bit if we ever switch to another bio list implementation, it could be a problem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.31-fast-new/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-raid1.c	2009-10-06 18:15:09.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-raid1.c	2009-10-06 18:15:10.000000000 +0200
@@ -791,6 +791,9 @@ static struct mirror_set *alloc_context(
 	}
 
 	spin_lock_init(&ms->lock);
+	bio_list_init(&ms->reads);
+	bio_list_init(&ms->writes);
+	bio_list_init(&ms->failures);
 
 	ms->ti = ti;
 	ms->nr_mirrors = nr_mirrors;
