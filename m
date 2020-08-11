From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 4/8] libmultipath: count pending paths as
	active on loads
Date: Tue, 11 Aug 2020 16:58:39 -0500
Message-ID: <1597183123-15797-5-git-send-email-bmarzins@redhat.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
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

When multipath loads a table, it signals to udev if there are no active
paths.  Multipath wasn't counting pending paths as active.  This meant
that if all the paths were pending, udev would treat the device as not
ready, and not run kpartx on it.  Even if the pending paths later
because active and were reinstated, the kernel would not send a new
uevent, because from its point of view, they were always up.

The alternative would be to continue to treat them as failed in the udev
rules, but then also tell the kernel that they were down, so that it
would trigger a uevent when they were reinstated. However, this could
lead to newly created multipath devices failing IO, simply because the
path checkers hadn't returned yet. Having udev assume that the the
device is up, like the kernel does, seems like the safer option.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 3 ++-
 libmultipath/structs.c   | 7 +++++++
 libmultipath/structs.h   | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f597ff8b..126cd728 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -417,7 +417,8 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
 	/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
 	return	(mpp->skip_kpartx == SKIP_KPARTX_ON ?
 		 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
-		((count_active_paths(mpp) == 0 || mpp->ghost_delay_tick > 0) ?
+		((count_active_pending_paths(mpp) == 0 ||
+		  mpp->ghost_delay_tick > 0) ?
 		 MPATH_UDEV_NO_PATHS_FLAG : 0) |
 		(reload && !mpp->force_udev_reload ?
 		 MPATH_UDEV_RELOAD_FLAG : 0);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 90874559..010deb47 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -503,6 +503,13 @@ int count_active_paths(const struct multipath *mpp)
 	return count;
 }
 
+int count_active_pending_paths(const struct multipath *mpp)
+{
+	int states[] = {PATH_UP, PATH_GHOST, PATH_PENDING};
+
+	return do_pathcount(mpp, states, 3);
+}
+
 int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
 {
 	int i, j;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 0c03e711..917e4083 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -448,6 +448,7 @@ struct path * first_path (const struct multipath *mpp);
 
 int pathcount (const struct multipath *, int);
 int count_active_paths(const struct multipath *);
+int count_active_pending_paths(const struct multipath *);
 int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
-- 
2.17.2
