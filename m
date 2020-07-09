From: mwilck@suse.com
Subject: [PATCH 54/54] libmultipath: get_refwwid(): skip
	strchop(), and constify dev parameter
Date: Thu,  9 Jul 2020 12:36:23 +0200
Message-ID: <20200709103623.8302-13-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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

With the previous change, we can safely assume that strchop() has been
called already where appropriate (the only caller is multipath's
configure()). We can now use const char* for the "dev" parameter.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 6 +++---
 libmultipath/configure.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7461e99..48426cd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1344,7 +1344,8 @@ struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type)
 	return ud;
 }
 
-static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
+static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
+			enum devtypes dev_type,
 			vector pathvec, struct config *conf, char **wwid)
 {
 	int ret = 1;
@@ -1379,7 +1380,6 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		goto common;
 
 	case DEV_DEVT:
-		strchop(dev);
 		pp = find_path_by_devt(pathvec, dev);
 		goto common;
 
@@ -1451,7 +1451,7 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 /*
  * Returns: PATHINFO_OK, PATHINFO_FAILED, or PATHINFO_SKIPPED (see pathinfo())
  */
-int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
+int get_refwwid(enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		vector pathvec, char **wwid)
 
 {
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 0e33bf4..d9a7de6 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -52,7 +52,7 @@ int setup_map (struct multipath * mpp, char * params, int params_size,
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
-int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
+int get_refwwid (enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
-- 
2.26.2
