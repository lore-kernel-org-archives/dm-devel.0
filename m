From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/6] dm-delay: Update documentation for offsets
	(resend)
Date: Wed, 28 Oct 2015 04:38:56 +0900
Message-ID: <1445974740-8362-2-git-send-email-kusumi.tomohiro@gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Only delay params are mentioned in delay.txt.
Mention offsets just like documents for linear and flakey do.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Documentation/device-mapper/delay.txt |    1 +
 drivers/md/dm-delay.c                 |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/delay.txt b/Documentation/device-mapper/delay.txt
index 15adc55..a07b592 100644
--- a/Documentation/device-mapper/delay.txt
+++ b/Documentation/device-mapper/delay.txt
@@ -8,6 +8,7 @@ Parameters:
     <device> <offset> <delay> [<write_device> <write_offset> <write_delay>]
 
 With separate write parameters, the first set is only used for reads.
+Offsets are specified in sectors.
 Delays are specified in milliseconds.
 
 Example scripts
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index e10f69a..772b720 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -122,6 +122,7 @@ static void flush_expired_bios(struct work_struct *work)
  *    <device> <offset> <delay> [<write_device> <write_offset> <write_delay>]
  *
  * With separate write parameters, the first set is only used for reads.
+ * Offsets are specified in sectors.
  * Delays are specified in milliseconds.
  */
 static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
-- 
1.7.1
