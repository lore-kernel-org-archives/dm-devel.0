From: Alasdair G Kergon <agk@redhat.com>
Subject: dm ioctl: prevent rename to empty name or uuid
Date: Thu, 29 Aug 2013 16:37:45 +0100
Message-ID: <20130829153745.GA12181@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Try something like this?

From: Alasdair G Kergon <agk@redhat.com>

A device-mapper device must always have a name consisting of a non-empty
string.  If the device also has a uuid, this similarly must not be an
empty string.

The DM_DEV_CREATE_CMD ioctl enforces these rules when the device is
created, but this patch is needed to enforce them when DM_DEV_RENAME_CMD
is used to change the name or uuid.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>                                                                                                                                                  
Cc: Mikulas Patocka <mpatocka@redhat.com>   
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>    

---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/md/dm-ioctl.c
===================================================================
--- linux.orig/drivers/md/dm-ioctl.c
+++ linux/drivers/md/dm-ioctl.c
@@ -877,7 +877,7 @@ static int dev_rename(struct dm_ioctl *p
 	unsigned change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
 
 	if (new_data < param->data ||
-	    invalid_str(new_data, (void *) param + param_size) ||
+	    invalid_str(new_data, (void *) param + param_size) || !*new_data ||
 	    strlen(new_data) > (change_uuid ? DM_UUID_LEN - 1 : DM_NAME_LEN - 1)) {
 		DMWARN("Invalid new mapped device name or uuid string supplied.");
 		return -EINVAL;
