From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: Add a throttle parameter
Date: Mon, 30 May 2011 12:41:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105301240400.26092@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-kcopyd: Add a throttle parameter

This patch adds a kcopyd throttle parameter accessible in
/sys/module/dm_mod/parameters/dm_kcopyd_throttle

So far, this parameter does nothing, it will be used in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-26 18:36:47.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-26 19:23:15.000000000 +0200
@@ -66,6 +66,11 @@ struct dm_kcopyd_client {
 	struct list_head pages_jobs;
 };
 
+static unsigned dm_kcopyd_throttle = 100;
+
+module_param(dm_kcopyd_throttle, uint, 0644);
+MODULE_PARM_DESC(dm_kcopyd_throttle, "A percentage of time allocated for copying");
+
 static DEFINE_SPINLOCK(activity_spinlock);
 static unsigned long num_io_jobs = 0;
 
