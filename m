From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid: select the config option CONFIG_MD_RAID0
Date: Tue, 28 Mar 2017 12:53:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1703281251440.16283@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Since the commit 0cf4503174c1, the dm-raid subsystem can activate a RAID-0
array. Therefore, add MD_RAID0 to the dependencies of DM_RAID, so that
MD_RAID0 will be selected when DM_RAID is selected.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 0cf4503174c1 ("dm raid: add support for the MD RAID0 personality")
Cc: stable@vger.kernel.org	# v4.2+

---
 drivers/md/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -365,6 +365,7 @@ config DM_LOG_USERSPACE
 config DM_RAID
        tristate "RAID 1/4/5/6/10 target"
        depends on BLK_DEV_DM
+       select MD_RAID0
        select MD_RAID1
        select MD_RAID10
        select MD_RAID456
