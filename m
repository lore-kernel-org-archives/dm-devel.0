From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-bufio: initialize read-only module
	parameters
Date: Thu, 5 Dec 2013 17:34:19 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1312051733350.2574@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312051732300.2574@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1312051732300.2574@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-stats: initialize read-only module parameters

The module parameter stats_current_allocated_bytes in dm-mod is read-only.
This parameter informs the user about memory consumption. It is not
supposed to be changed by the user.

However, despite being read-only, this parameter can be set on modprobe or
insmod command line:
modprobe dm-mod stats_current_allocated_bytes=12345

The kernel doesn't expect that this variable can be non-zero at module
initialization and if the user sets it, it results in warning.

This patch initializates the variable in the module init routine, so that
user-supplied value is ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org	# 3.12+

---
 drivers/md/dm-bufio.c |    5 +++++
 drivers/md/dm-stats.c |    1 +
 2 files changed, 6 insertions(+)

Index: linux-3.13-rc2/drivers/md/dm-stats.c
===================================================================
--- linux-3.13-rc2.orig/drivers/md/dm-stats.c	2013-12-05 23:08:37.000000000 +0100
+++ linux-3.13-rc2/drivers/md/dm-stats.c	2013-12-05 23:09:00.000000000 +0100
@@ -964,6 +964,7 @@ int dm_stats_message(struct mapped_devic
 
 int __init dm_statistics_init(void)
 {
+	shared_memory_amount = 0;
 	dm_stat_need_rcu_barrier = 0;
 	return 0;
 }
