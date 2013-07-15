From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/29] Check return value from pathinfo()
Date: Mon, 15 Jul 2013 15:00:14 +0200
Message-ID: <1373893230-26077-14-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

pathinfo() has a return value, which should be checked to catch
any abnormal behaviour.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c |   10 ++++++++--
 libmultipath/discovery.c |    6 ++++--
 multipath/main.c         |   15 ++++++++++-----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1cf46cc..7f5e065 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -793,8 +793,14 @@ extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
 
 	update_mpp_paths(mpp, vecs->pathvec);
 	if (refresh) {
-		vector_foreach_slot (mpp->paths, pp, i)
-			pathinfo(pp, conf->hwtable, DI_PRIO);
+		vector_foreach_slot (mpp->paths, pp, i) {
+			r = pathinfo(pp, conf->hwtable, DI_PRIO);
+			if (r) {
+				condlog(2, "%s: failed to refresh pathinfo",
+					mpp->alias);
+				return 1;
+			}
+		}
 	}
 	if (setup_map(mpp, params, PARAMS_SIZE)) {
 		condlog(0, "%s: failed to setup map", mpp->alias);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a482c53..96fe985 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -125,8 +125,10 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 			continue;
 		}
 		devtype = udev_device_get_devtype(udevice);
-		if(devtype && !strncmp(devtype, "disk", 4))
-			r += path_discover(pathvec, conf, udevice, flag);
+		if(devtype && !strncmp(devtype, "disk", 4)) {
+			r += path_discover(pathvec, conf,
+						   udevice, flag);
+		}
 		udev_device_unref(udevice);
 	}
 	udev_enumerate_unref(udev_iter);
diff --git a/multipath/main.c b/multipath/main.c
index 4a8b966..842a787 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -152,16 +152,21 @@ update_paths (struct multipath * mpp)
 					continue;
 				}
 				pp->mpp = mpp;
-				pathinfo(pp, conf->hwtable, DI_ALL);
+				if (pathinfo(pp, conf->hwtable, DI_ALL))
+					pp->state = PATH_UNCHECKED;
 				continue;
 			}
 			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED ||
-			    pp->state == PATH_WILD)
-				pathinfo(pp, conf->hwtable, DI_CHECKER);
+			    pp->state == PATH_WILD) {
+				if (pathinfo(pp, conf->hwtable, DI_CHECKER))
+					pp->state = PATH_UNCHECKED;
+			}
 
-			if (pp->priority == PRIO_UNDEF)
-				pathinfo(pp, conf->hwtable, DI_PRIO);
+			if (pp->priority == PRIO_UNDEF) {
+				if (pathinfo(pp, conf->hwtable, DI_PRIO))
+					pp->priority = PRIO_UNDEF;
+			}
 		}
 	}
 	return 0;
-- 
1.7.10.4
