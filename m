From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: Allow NULL buffer in dm_copy_name_and_uuid
 if only one vaule requested.
Date: Wed, 17 Dec 2008 13:02:18 +0100
Message-ID: <4948EA4A.3070603@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Allow NULL buffer in dm_copy_name_and_uuid if only one value requested.

Also add maximal length check for string size.

(This patch is needed for device-mapper sysfs extension.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7c3ae49..59b3283 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1548,8 +1548,10 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
 		goto out;
 	}
 
-	strcpy(name, hc->name);
-	strcpy(uuid, hc->uuid ? : "");
+	if (name)
+		strncpy(name, hc->name, DM_NAME_LEN);
+	if (uuid)
+		strncpy(uuid, hc->uuid ? : "", DM_UUID_LEN);
 
 out:
 	up_read(&_hash_lock);
