From: mwilck@suse.com
Subject: [PATCH 22/35] libmultipath: get_uid(): improve log
	message on udev failure
Date: Thu,  9 Jul 2020 12:16:07 +0200
Message-ID: <20200709101620.6786-23-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

If WWID determination by uid_attribute fails, and no fallback
is available, multipath(d) print two error messages:
"failed to get udev uid" and "failed to get unknown uid".
That's confusing and unnecessary. Print only the udev message.
If the fallback is available, this will result in only the
error message from the fallback being printed. But that's not
a big issue, because the udev error message will have been printed
before, and because failure of the fallback implies previous failure
of the udev method.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 81c78d3..5d4bf7d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2014,12 +2014,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 
 		if (udev_available) {
 			len = get_udev_uid(pp, pp->uid_attribute, udev);
-			if (len <= 0)
-				condlog(1,
-					"%s: failed to get udev uid: %s",
-					pp->dev, strerror(-len));
-			else
-				origin = "udev";
+			origin = "udev";
+			if (len == 0)
+				condlog(1, "%s: empty udev uid", pp->dev);
 		}
 		if ((!udev_available || (len <= 0 && allow_fallback))
 		    && has_uid_fallback(pp)) {
-- 
2.26.2
