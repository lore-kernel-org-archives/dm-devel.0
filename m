From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: call store_pathinfo with DI_BLACKLIST
Date: Mon,  3 Jun 2019 14:29:16 -0500
Message-ID: <1559590156-26394-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Commit ca19f865f moved adding DI_BLACKLIST to the pathinfo flags out of
store_pathinfo(), but it didn't add it to all of the necessary callers.
Without this, store_pathinfo() callers can do unnecessary extra work,
including running the path checker on blacklisted devices. Also, running

multipathd add path <blacklisted_path_device>

will add a blacklisted path.

Fixes: ca19f865f "libmultipath: add 'cmd' as argument for get_refwwid()"
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c  | 3 ++-
 multipathd/cli_handlers.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b3dc60b1..e9411dfc 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -134,7 +134,8 @@ path_discover (vector pathvec, struct config * conf,
 		pp = find_path_by_devt(pathvec, devt);
 		if (!pp)
 			return store_pathinfo(pathvec, conf,
-					      udevice, flag, NULL);
+					      udevice, flag | DI_BLACKLIST,
+					      NULL);
 	}
 	return pathinfo(pp, conf, flag);
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 60e17d68..4c32d953 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -730,7 +730,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		r = store_pathinfo(vecs->pathvec, conf,
-				   udevice, DI_ALL, &pp);
+				   udevice, DI_ALL | DI_BLACKLIST, &pp);
 		pthread_cleanup_pop(1);
 		udev_device_unref(udevice);
 		if (!pp) {
-- 
2.17.2
