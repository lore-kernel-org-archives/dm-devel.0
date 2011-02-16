From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Use only specific errors when failing dm-ioctl
Date: Wed, 16 Feb 2011 18:32:05 +0100
Message-ID: <1297877525-10163-1-git-send-email-mbroz@redhat.com>
References: <1297777960-22662-2-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1297777960-22662-2-git-send-email-mbroz@redhat.com>
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

The return codes of ioctl are part of device-mapper
API and only defined errno should be returned.

Unify return codes for device lookup function on one place
and allow ENOMEM and ENXIO for now.

(Later it can be added more codes as userspace is prepared
to handle them.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-table.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38e4eb1..ca19e4d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -532,7 +532,17 @@ EXPORT_SYMBOL_GPL(dm_set_device_limits);
 int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		  struct dm_dev **result)
 {
-	return __table_get_device(ti->table, ti, path, mode, result);
+	int r = __table_get_device(ti->table, ti, path, mode, result);
+
+	/*
+	 * Return code is directly used for dm ioctl.
+	 * Allow only ENOMEM here, all other codes
+	 * means device lookup failed.
+	 */
+	if (r && r != -ENOMEM)
+		r = -ENXIO;
+
+	return r;
 }
 
 
-- 
1.7.2.3
