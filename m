From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [LVM PATCH 1/4] Misc: New function for reading lvm
	config file, 'dm_config_get_int'
Date: Thu, 23 Jan 2014 09:05:45 -0600
Message-ID: <1390489548-18076-2-git-send-email-jbrassow@redhat.com>
References: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

---
 libdm/libdevmapper.h |    1 +
 libdm/libdm-config.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/libdm/libdevmapper.h b/libdm/libdevmapper.h
index adfbb76..3bf8bd6 100644
--- a/libdm/libdevmapper.h
+++ b/libdm/libdevmapper.h
@@ -1661,6 +1661,7 @@ int dm_config_tree_find_bool(const struct dm_config_tree *cft, const char *path,
 int dm_config_find_bool(const struct dm_config_node *cn, const char *path, int fail);
 int dm_config_value_is_bool(const struct dm_config_value *v);
 
+int dm_config_get_int(const struct dm_config_node *cn, const char *path, int *result);
 int dm_config_get_uint32(const struct dm_config_node *cn, const char *path, uint32_t *result);
 int dm_config_get_uint64(const struct dm_config_node *cn, const char *path, uint64_t *result);
 int dm_config_get_str(const struct dm_config_node *cn, const char *path, const char **result);
diff --git a/libdm/libdm-config.c b/libdm/libdm-config.c
index ea1af2f..3297621 100644
--- a/libdm/libdm-config.c
+++ b/libdm/libdm-config.c
@@ -1047,6 +1047,20 @@ int dm_config_tree_find_bool(const struct dm_config_tree *cft, const char *path,
 
 /************************************/
 
+int dm_config_get_int(const struct dm_config_node *cn, const char *path,
+		      int *result)
+{
+	const struct dm_config_node *n;
+
+	n = _find_config_node(cn, path);
+
+	if (!n || !n->v || n->v->type != DM_CFG_INT)
+		return 0;
+
+	if (result)
+		*result = n->v->v.i;
+	return 1;
+}
 
 int dm_config_get_uint32(const struct dm_config_node *cn, const char *path,
 			 uint32_t *result)
-- 
1.7.7.6
