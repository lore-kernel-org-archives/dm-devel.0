From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Make it possible to set a uuid if one was not set
 during DM_DEV_CREATE.
Date: Fri, 8 Oct 2010 16:59:49 -0400
Message-ID: <20101008205949.GC20707@redhat.com>
References: <1286560423-12748-1-git-send-email-pjones@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1286560423-12748-1-git-send-email-pjones@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 08 2010 at  1:53pm -0400,
Peter Jones <pjones@redhat.com> wrote:

> This makes it possible to use DM_DEV_RENAME to add a uuid to a device so
> long as one has not been previously set either with DM_DEV_CREATE or
> with DM_DEV_RENAME. This is proposed as a fix to rhbz#584328 .
> 
> Also bump the minor number to 19.

We still need a better patch header.  I'll look at the BZ and draft one.

But here is a follow-on patch that I think we should fold ontop of this
latest patch.

I basically just cleaned up dm_hash_rename a bit.  Added "Unable to"
consistency to DMWARN messages.  And eliminated a bit of duplicate code
in the first hunk of dm_hash_rename.

Peter, please advise.

Thanks,
Mike

---
 drivers/md/dm-ioctl.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -315,28 +315,24 @@ static struct mapped_device *dm_hash_ren
 	/*
 	 * Is new free ?
 	 */
-	if (param->flags & DM_NEW_UUID_FLAG) {
+	if (param->flags & DM_NEW_UUID_FLAG)
 		hc = __get_uuid_cell(new);
-		if (hc) {
-			DMWARN("Unable to change uuid on device with an "
-			       "already-existing uuid %s -> %s",
-			       param->name, new);
-			dm_put(hc->md);
-			up_write(&_hash_lock);
-			kfree(new_data);
-			return ERR_PTR(-EBUSY);
-		}
-	} else {
+	else
 		hc = __get_name_cell(new);
-		if (hc) {
-			DMWARN("asked to rename to an already-existing name "
-			       "%s -> %s",
+
+	if (hc) {
+		if (param->flags & DM_NEW_UUID_FLAG)
+			DMWARN("Unable to change uuid on device %s to an "
+			       "already-existing uuid %s",
 			       param->name, new);
-			dm_put(hc->md);
-			up_write(&_hash_lock);
-			kfree(new_data);
-			return ERR_PTR(-EBUSY);
-		}
+		else
+			DMWARN("Unable to rename device %s to an "
+			       "already-existing name %s",
+			       param->name, new);
+		dm_put(hc->md);
+		up_write(&_hash_lock);
+		kfree(new_data);
+		return ERR_PTR(-EBUSY);
 	}
 
 	/*
@@ -344,7 +340,7 @@ static struct mapped_device *dm_hash_ren
 	 */
 	hc = __get_name_cell(param->name);
 	if (!hc) {
-		DMWARN("asked to rename a non-existent device %s -> %s",
+		DMWARN("Unable to rename a non-existent device %s to %s",
 		       param->name, new);
 		up_write(&_hash_lock);
 		kfree(new_data);
@@ -356,15 +352,15 @@ static struct mapped_device *dm_hash_ren
 		 * Does this device already have a uuid?
 		 */
 		if (hc->uuid) {
-			DMWARN("asked to change uuid of device with uuid "
-			       "already set %s %s -> %s",
-			       param->name, hc->uuid, param->uuid);
+			DMWARN("Unable to change uuid of device %s because "
+			       "its uuid is already set to %s",
+			       param->name, hc->uuid);
 			up_write(&_hash_lock);
 			kfree(new_data);
 			return ERR_PTR(-EINVAL);
 		}
 		/*
-		 * reuuid and move the uuid cell.
+		 * change uuid and move the uuid cell.
 		 */
 		list_del(&hc->uuid_list);
 		old_data = hc->uuid;
