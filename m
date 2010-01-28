From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Do not wait for event on device without table.
Date: Thu, 28 Jan 2010 14:27:55 +0100
Message-ID: <1264685275-21232-1-git-send-email-mbroz@redhat.com>
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
To: dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

If there is DM device with no table present, do not
try to wait for change event. Otherwise it can
wait forever and block already removed device.

Simple reproducible:
  dmsetup create x --notable
  dmsetup wait x 0 &
  dmsetup remove x

Now it waits for device, which is no longer accesible through dm-ioctl.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1d66932..a0ac379 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1023,6 +1023,15 @@ static int dev_wait(struct dm_ioctl *param, size_t param_size)
 		return -ENXIO;
 
 	/*
+	 * Do not wait if no table present
+	 */
+	if (!(table = dm_get_live_or_inactive_table(md, param))) {
+		r = -ENXIO;
+		goto out;
+	}
+	dm_table_put(table);
+
+	/*
 	 * Wait for a notification event
 	 */
 	if (dm_wait_event(md, param->event_nr)) {
-- 
1.6.6
