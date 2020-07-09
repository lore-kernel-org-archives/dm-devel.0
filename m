From: mwilck@suse.com
Subject: [PATCH 52/54] libmultipath: constify get_mpe_wwid()
Date: Thu,  9 Jul 2020 12:36:21 +0200
Message-ID: <20200709103623.8302-11-mwilck@suse.com>
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

As this returns a pointer to a struct member, the return value
should also be a const char*.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c    | 2 +-
 libmultipath/config.h    | 2 +-
 libmultipath/configure.c | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 658bec8..69a2723 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -157,7 +157,7 @@ struct mpentry *find_mpe(vector mptable, char *wwid)
 	return NULL;
 }
 
-char *get_mpe_wwid(vector mptable, char *alias)
+const char *get_mpe_wwid(const struct _vector *mptable, const char *alias)
 {
 	int i;
 	struct mpentry * mpe;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 92c61a0..2bb7153 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -239,7 +239,7 @@ int find_hwe (const struct _vector *hwtable,
 	      const char * vendor, const char * product, const char *revision,
 	      vector result);
 struct mpentry * find_mpe (vector mptable, char * wwid);
-char * get_mpe_wwid (vector mptable, char * alias);
+const char *get_mpe_wwid (const struct _vector *mptable, const char *alias);
 
 struct hwentry * alloc_hwe (void);
 struct mpentry * alloc_mpe (void);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index db9a255..7461e99 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1350,7 +1350,8 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	int ret = 1;
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
-	char * refwwid = NULL, tmpwwid[WWID_SIZE];
+	const char *refwwid = NULL;
+	char tmpwwid[WWID_SIZE];
 	struct udev_device *udevice;
 	int flags = DI_SYSFS | DI_WWID;
 
-- 
2.26.2
