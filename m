From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: move device check warning messages into
	debug level
Date: Thu,  6 Jan 2011 21:02:49 +0100
Message-ID: <1294344169-26950-1-git-send-email-mbroz@redhat.com>
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

The device-mapper should not send warning messages to syslog
if device is not found. This should be done in userspace
according to returned dm-ioctl error code.

Move these messages into debug level and use rate limiting
to not flood syslog.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f3481d9..6d12775 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -779,7 +779,7 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 	hc = __find_device_hash_cell(param);
 
 	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
+		DMDEBUG_LIMIT("device doesn't appear to be in the dev hash table.");
 		up_write(&_hash_lock);
 		return -ENXIO;
 	}
@@ -791,7 +791,7 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 	 */
 	r = dm_lock_for_deletion(md);
 	if (r) {
-		DMWARN("unable to remove open device %s", hc->name);
+		DMDEBUG_LIMIT("unable to remove open device %s", hc->name);
 		up_write(&_hash_lock);
 		dm_put(md);
 		return r;
@@ -938,7 +938,7 @@ static int do_resume(struct dm_ioctl *param)
 
 	hc = __find_device_hash_cell(param);
 	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
+		DMDEBUG_LIMIT("device doesn't appear to be in the dev hash table.");
 		up_write(&_hash_lock);
 		return -ENXIO;
 	}
@@ -1265,7 +1265,7 @@ static int table_clear(struct dm_ioctl *param, size_t param_size)
 
 	hc = __find_device_hash_cell(param);
 	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
+		DMDEBUG_LIMIT("device doesn't appear to be in the dev hash table.");
 		up_write(&_hash_lock);
 		return -ENXIO;
 	}
-- 
1.7.2.3
