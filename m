From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: add module aliases
Date: Thu, 7 Feb 2013 15:10:38 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302071509080.6952@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi. This is a fix for bug 889973.

Mikulas

---

dm-snapshot: add module aliases

Add module aliases so that autoloading works if the user tries to
activate "snapshot-origin" or "snapshot-merge" targets.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-3.8-rc6-fast/drivers/md/dm-snap.c
===================================================================
--- linux-3.8-rc6-fast.orig/drivers/md/dm-snap.c	2013-02-07 21:05:00.000000000 +0100
+++ linux-3.8-rc6-fast/drivers/md/dm-snap.c	2013-02-07 21:06:44.000000000 +0100
@@ -2310,3 +2310,5 @@ module_exit(dm_snapshot_exit);
 MODULE_DESCRIPTION(DM_NAME " snapshot target");
 MODULE_AUTHOR("Joe Thornber");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-snapshot-origin");
+MODULE_ALIAS("dm-snapshot-merge");
