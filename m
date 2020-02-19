From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 12/18] multipathd: add new paths under vecs
	lock
Date: Wed, 19 Feb 2020 00:48:34 -0600
Message-ID: <1582094920-9883-13-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Right now, multipathd only ever calls pathinfo on a path outside of the
vecs lock in one circumstance, when it's adding a new path from a
uevent. Doing this can cause weirdness or crash multipathd.

First off, the path checker code is written assuming that only one
checker instance will be active at a time.  If this isn't the case, two
processes can modify the checker's refcounts at the same time,
potentially causing a checker to get removed while still in use (if two
threads try to increment the refcount at the same time, causing it to
only increment once).

Another issue is that since the vecs lock isn't grabbed until after all
of the pathinfo is gathered, and the vecs lock is the only thing keeping
the uevent servicing thread from running at the same time as a
reconfigure is happening, it is possible to have multipathd add a path
using the old config after reconfigure has already added that path using
the new config. Leading to two versions of the path on the pathvec.
There are possibly other issues with running pathinfo outside of the
vecs lock that I haven't noticed, as well.

The easiest solution is to call pathinfo on the path while holding the
vecs lock, to keep other threads from modifying the checker structure or
the config while setting up the path. This is what happens every other
time multipathd calls pathinfo, including when a path is added through
the multipathd command interface.

This does mean that any time spent calling pathinfo on new paths will
block other threads that need the vecs lock, but since the checker is
now always called in async mode, and the prio function will use a
short timeout if called on a failed path, this shouldn't be any more
noticeable than the calls to check_path() for already existing paths.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a590ba8d..e607acf3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -872,9 +872,8 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 			}
 		}
 	}
-	lock_cleanup_pop(vecs->lock);
 	if (pp)
-		return ret;
+		goto out;
 
 	/*
 	 * get path vital state
@@ -886,13 +885,13 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	pthread_cleanup_pop(1);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
-			return 0;
-		condlog(3, "%s: failed to get path info", uev->kernel);
-		return 1;
+			ret = 0;
+		else {
+			condlog(3, "%s: failed to get path info", uev->kernel);
+			ret = 1;
+		}
+		goto out;
 	}
-	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(&vecs->lock);
-	pthread_testcancel();
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
 		conf = get_multipath_config();
@@ -906,6 +905,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 		free_path(pp);
 		ret = 1;
 	}
+out:
 	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
-- 
2.17.2
