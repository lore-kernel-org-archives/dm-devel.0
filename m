From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 2/4] dm-log: update resume method for
 interruption of presuspend
Date: Tue, 23 Feb 2010 13:45:06 -0500
Message-ID: <4B842232.30604@redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: k-ueda@ct.jp.nec.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

When suspend is interrupted after presuspend procedure, each
target needs to cancel all state changes done by its presuspend
procedure. As for the log target, there is nothing to be canceled
because the log target doesn't have a presuspend method.

The log target should skip disk_resume/core_resume method when
the target isn't suspended.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-log.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-log.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-log.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-log.c
@@ -593,6 +593,10 @@ static int disk_resume(struct dm_dirty_l
 	struct log_c *lc = (struct log_c *) log->context;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
 
+	/* Just returns if the state is not "suspended." */
+	if (!dm_suspended(lc->ti))
+		return 0;
+
 	/* read the disk header */
 	r = read_header(lc);
 	if (r) {
@@ -658,6 +662,11 @@ static uint32_t core_get_region_size(str
 static int core_resume(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
+	/* Just returns if the state is not "suspended." */
+	if (!dm_suspended(lc->ti))
+		return 0;
+
 	lc->sync_search = 0;
 	return 0;
 }

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
