From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 56/72] kpartx: use unsigned arguments in
 dm_devn() and dm_prereq()
Date: Sat, 12 Oct 2019 21:28:46 +0000
Message-ID: <20191012212703.12989-57-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

In both cases, the corresponding libdevmapper values are unsigned.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 10 +++++-----
 kpartx/devmapper.h |  7 ++++---
 kpartx/kpartx.h    |  7 ++++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 7e599e07..9a3dd5f8 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -17,7 +17,7 @@
 #define MAX_PREFIX_LEN (_UUID_PREFIX_LEN + 4)
 #define PARAMS_SIZE 1024
 
-int dm_prereq(char * str, int x, int y, int z)
+int dm_prereq(char * str, uint32_t x, uint32_t y, uint32_t z)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -359,7 +359,7 @@ out:
 }
 
 int
-dm_devn (const char * mapname, int *major, int *minor)
+dm_devn (const char * mapname, unsigned int *major, unsigned int *minor)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -528,7 +528,7 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 	struct remove_data *rd = data;
 	unsigned next = 0;
 	char params[PARAMS_SIZE];
-	int major, minor;
+	unsigned int major, minor;
 	char dev_t[32];
 	int r = 1;
 	int is_dmdev = 1;
@@ -645,7 +645,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	char params[PARAMS_SIZE];
 	char *tmp;
 	char *uuid;
-	int major, minor;
+	unsigned int major, minor;
 	char dev_t[32];
 
 	if (!format_partname(name, namesiz, parent, delim, part)) {
@@ -715,7 +715,7 @@ char *nondm_create_uuid(dev_t devt)
 	return uuid_buf;
 }
 
-int nondm_parse_uuid(const char *uuid, int *major, int *minor)
+int nondm_parse_uuid(const char *uuid, unsigned int *major, unsigned int *minor)
 {
 	const char *p;
 	char *e;
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 73b80f2f..701bdf6e 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -9,14 +9,14 @@
 
 extern int udev_sync;
 
-int dm_prereq (char *, int, int, int);
+int dm_prereq (char *, uint32_t, uint32_t, uint32_t);
 int dm_simplecmd (int, const char *, int, uint16_t);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
 	       int, const char *, int, mode_t, uid_t, gid_t);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(const char *mapname);
-int dm_devn (const char * mapname, int *major, int *minor);
+int dm_devn (const char * mapname, unsigned int *major, unsigned int *minor);
 int dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose);
 int dm_find_part(const char *parent, const char *delim, int part,
 		 const char *parent_uuid,
@@ -34,5 +34,6 @@ int dm_find_part(const char *parent, const char *delim, int part,
 #define NONDM_UUID_PREFIX "devnode"
 #define NONDM_UUID_SUFFIX "Wh5pYvM"
 char *nondm_create_uuid(dev_t devt);
-int nondm_parse_uuid(const char *uuid, int *major, int *minor);
+int nondm_parse_uuid(const char *uuid,
+		     unsigned int *major, unsigned int *minor);
 #endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 3ec13dbc..015dcab4 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -33,11 +33,12 @@ struct slice {
 	uint64_t start;
 	uint64_t size;
 	int container;
-	int major;
-	int minor;
+	unsigned int major;
+	unsigned int minor;
 };
 
-typedef int (ptreader)(int fd, struct slice all, struct slice *sp, int ns);
+typedef int (ptreader)(int fd, struct slice all, struct slice *sp,
+		       int ns);
 
 extern int force_gpt;
 
-- 
2.23.0
