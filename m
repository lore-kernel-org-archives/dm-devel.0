From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 13/16] Make multipathd deal better with
	uninitialized paths
Date: Thu,  2 May 2013 16:46:34 -0500
Message-ID: <1367531197-8987-14-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

If multipathd cannot get all the necessary information from a path in
pathinfo, it clears the path's wwid, and adds it to the pathvec without
being initialized.  However, it never tries to reinitialize it later.
This can cause problems at bootup if multipathd is started at around
the same time as some path devices are discovered. multipathd may try
to initalize them in configure() before they are all the way set up.
After the paths are completely set up, multipathd will get a uevent for
them, but it won't try to reinitialize them. This patch adds
reinitialization code to uev_add_path().  Also, since getting the path
uid now just involves reading an attribute set by udev, there's no
reason no to try it for paths that are currently down.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |  2 +-
 multipathd/main.c        | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4d452a1..26983ca 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1034,7 +1034,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		}
 	}
 
-	if (path_state == PATH_UP && (mask & DI_WWID) && !strlen(pp->wwid))
+	if ((mask & DI_WWID) && !strlen(pp->wwid))
 		get_uid(pp);
 	if (mask & DI_BLACKLIST && mask & DI_WWID) {
 		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
diff --git a/multipathd/main.c b/multipathd/main.c
index df1c5b9..a8e4725 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -375,7 +375,7 @@ static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
-	int ret;
+	int ret, i;
 
 	condlog(2, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
@@ -392,6 +392,23 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 			uev->kernel);
 		if (pp->mpp)
 			return 0;
+		if (!strlen(pp->wwid)) {
+			udev_device_unref(pp->udev);
+			pp->udev = udev_device_ref(uev->udev);
+			ret = pathinfo(pp, conf->hwtable,
+				       DI_ALL | DI_BLACKLIST);
+			if (ret == 2) {
+				i = find_slot(vecs->pathvec, (void *)pp);
+				if (i != -1)
+					vector_del_slot(vecs->pathvec, i);
+				free_path(pp);
+				return 0;
+			} else if (ret == 1) {
+				condlog(0, "%s: failed to reinitialize path",
+					uev->kernel);
+				return 1;
+			}
+		}
 	} else {
 		/*
 		 * get path vital state
-- 
1.8.2
