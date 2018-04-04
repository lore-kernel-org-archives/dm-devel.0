From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 19/20] libmultipath: enable find_multipaths
	"smart"
Date: Wed,  4 Apr 2018 18:16:26 +0200
Message-ID: <20180404161627.6244-20-mwilck@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404161627.6244-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This activates "smart" path detection. This is similar to
"find_multipaths yes", but doesn't generally ignore single paths
that are not listed in the WWIDs file. Rather, such paths are
temporarily treated like multipath members. If no additional paths
are detected after a certain time, the paths are re-added to the
system as non-multipath. This needs support by the udev rules, to
be added in a follow-up patch.

If a multipath map is successfully successfully created, and paths are
in waiting state, trigger path uevents to update their status.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 15 ++++++++++++---
 libmultipath/dict.c        |  1 +
 multipath/multipath.conf.5 | 13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9aa3d21..17c2fa1 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <sys/file.h>
 #include <errno.h>
+#include <ctype.h>
 #include <libdevmapper.h>
 #include <libudev.h>
 #include "mpath_cmd.h"
@@ -476,9 +477,17 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 			env = udev_device_get_property_value(
 				pp->udev, "DM_MULTIPATH_DEVICE_PATH");
 
-			if (is_mpath && env != NULL && !strcmp(env, "1"))
-				continue;
-			else if (!is_mpath &&
+			if (is_mpath && env != NULL && !strcmp(env, "1")) {
+				/*
+				 * If FIND_MULTIPATHS_WAIT_UNTIL is not "0",
+				 * path is in "maybe" state and timer is running
+				 * Send uevent now (see multipath.rules).
+				 */
+				env = udev_device_get_property_value(
+					pp->udev, "FIND_MULTIPATHS_WAIT_UNTIL");
+				if (env == NULL || !strcmp(env, "0"))
+					continue;
+			} else if (!is_mpath &&
 				   (env == NULL || !strcmp(env, "0")))
 				continue;
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4be808d..8a18b1f 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -239,6 +239,7 @@ static const char *find_multipaths_optvals[] = {
 	[FIND_MULTIPATHS_ON] = "on",
 	[FIND_MULTIPATHS_STRICT] = "strict",
 	[FIND_MULTIPATHS_GREEDY] = "greedy",
+	[FIND_MULTIPATHS_SMART] = "smart",
 };
 
 static int
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 94c419a..641ba43 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -978,6 +978,19 @@ with the same WWID have been detected.
 Both multipathd and multipath treat every non-blacklisted device as multipath
 device path.
 .TP
+.I smart
+This differs from \fIfind_multipaths yes\fR only in
+the way it treats new devices for which only one path has been
+detected yet. When such a device is first encounted in udev rules, it is
+treated as a multipath device. multipathd waits whether additional paths with
+the same WWID appears. If that happens, it sets up a multipath map. If it
+doesn\'t happen until a 
+timeout expires, or if setting up the map fails, a new uevent is triggered for
+the device; at second encounter in the udev rules, the device will be treated
+as non-multipath and passed on to upper layers.
+\fBNote:\fR this may cause delays during device detection if
+there are single-path devices which aren\'t blacklisted.
+.TP
 The default is: \fBstrict\fR
 .RE
 .
-- 
2.16.1
