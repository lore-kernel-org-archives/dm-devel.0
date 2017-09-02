From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/31] libmultipath: use const char* in some dm
	helpers
Date: Sun,  3 Sep 2017 00:38:41 +0200
Message-ID: <20170902223900.7339-13-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Changing dm_get_info and dm_get_uuid for now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 4 ++--
 libmultipath/devmapper.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 7a3390a7..6e3abe3e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -553,7 +553,7 @@ uuidout:
 	return r;
 }
 
-int dm_get_uuid(char *name, char *uuid)
+int dm_get_uuid(const char *name, char *uuid)
 {
 	if (dm_get_prefixed_uuid(name, uuid))
 		return 1;
@@ -1308,7 +1308,7 @@ alloc_dminfo (void)
 }
 
 int
-dm_get_info (char * mapname, struct dm_info ** dmi)
+dm_get_info (const char * mapname, struct dm_info ** dmi)
 {
 	if (!mapname)
 		return 1;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 99a554b5..5c824a21 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -59,8 +59,8 @@ int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
-int dm_get_uuid(char *name, char *uuid);
-int dm_get_info (char * mapname, struct dm_info ** dmi);
+int dm_get_uuid(const char *name, char *uuid);
+int dm_get_info (const char * mapname, struct dm_info ** dmi);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
-- 
2.14.0
