From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 07/17] multipathd: ignore failed wwid recheck
Date: Sat, 30 Mar 2019 01:05:56 -0500
Message-ID: <1553925966-20958-8-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If disable_changed_wwids is set, when multipathd gets a change event on
a path, it verifies that the wwid hasn't changed in uev_update_path().
If get_uid() failed, uev_update_path treated this as a wwid change to 0.
This could cause paths to suddenly be dropped due to an issue with
getting the wwid.  Even if get_uid() failed because the path was down,
it no change uevent happend when it later became active, multipathd
would continue to ignore the path. Also, scsi_uid_fallback() clears the
failure return if it doesn't attempt to fallback, causing get_uid()
to return success, when it actually failed.

Multipathd should neither set nor clear wwid_changed if get_uid()
returned failure. Also, scsi_uid_fallback() should retain the old return
value if it doesn't attempt to fallback.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 6 +++---
 multipathd/main.c        | 6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 729bcb9..b08cb2d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1755,9 +1755,9 @@ get_vpd_uid(struct path * pp)
 }
 
 static ssize_t scsi_uid_fallback(struct path *pp, int path_state,
-			     const char **origin)
+			     const char **origin, ssize_t old_len)
 {
-	ssize_t len = 0;
+	ssize_t len = old_len;
 	int retrigger;
 	struct config *conf;
 
@@ -1828,7 +1828,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 			origin = "sysfs";
 		}
 		if (len <= 0 && pp->bus == SYSFS_BUS_SCSI)
-			len = scsi_uid_fallback(pp, path_state, &origin);
+			len = scsi_uid_fallback(pp, path_state, &origin, len);
 	}
 	if ( len < 0 ) {
 		condlog(1, "%s: failed to get %s uid: %s",
diff --git a/multipathd/main.c b/multipathd/main.c
index 678ecf8..fd83a6a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1234,9 +1234,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
-		get_uid(pp, pp->state, uev->udev);
+		rc = get_uid(pp, pp->state, uev->udev);
 
-		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		if (rc != 0)
+			strcpy(pp->wwid, wwid);
+		else if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
 			condlog(0, "%s: path wwid changed from '%s' to '%s'. %s",
 				uev->kernel, wwid, pp->wwid,
 				(disable_changed_wwids ? "disallowing" :
-- 
2.17.2
