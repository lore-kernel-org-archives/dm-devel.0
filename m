From: John Dorminy <jdorminy@redhat.com>
Subject: [PATCH] dm: expose dm_copy_name_and_uuid()
Date: Fri, 31 Jan 2020 19:55:24 -0500
Message-ID: <20200201005524.23405-1-jdorminy@redhat.com>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

While dm_device_name() returns the MAJOR:MINOR numbers of a device,
some targets would like to know the pretty name of a device, and
some targets would like to know the uuid expected for the device.

The MAJOR:MINOR name is useful for logging, but printing the long
name of the device can make it easier for the user to correlate
messages with the device names they know in userspace.

The UUID can be useful for devices which store a UUID on disk, and
would like to verify the on-disk UUID matches the UUID known by DM.

dm_copy_name_and_uuid() appears to be the only way to get at the
pretty name and the UUID at present, and this change exports the
function for use by GPLd modules.

Signed-off-by: John Dorminy <jdorminy@redhat.com>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1e03bc89e20f..711a46015696 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2018,7 +2018,7 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
 
 	return r;
 }
-
+EXPORT_SYMBOL_GPL(dm_copy_name_and_uuid);
 
 /**
  * dm_early_create - create a mapped device in early boot.
-- 
2.20.1
