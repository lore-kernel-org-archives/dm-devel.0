From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 7/9] multipathd: ignore failed wwid recheck
Date: Fri, 22 Feb 2019 10:58:10 -0600
Message-ID: <1550854692-19873-8-git-send-email-bmarzins@redhat.com>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
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
would continue to ignore the path.

Instead, multipathd should neither set nor clear wwid_changed if
get_uid() returned failure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 678ecf8..81ad6c0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1234,9 +1234,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
-		get_uid(pp, pp->state, uev->udev);
+		rc = get_uid(pp, pp->state, uev->udev);
 
-		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		if (rc == 0 && strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
 			condlog(0, "%s: path wwid changed from '%s' to '%s'. %s",
 				uev->kernel, wwid, pp->wwid,
 				(disable_changed_wwids ? "disallowing" :
@@ -1252,7 +1252,8 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				goto out;
 			}
 		} else {
-			pp->wwid_changed = 0;
+			if (rc == 0)
+				pp->wwid_changed = 0;
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
-- 
2.17.2
