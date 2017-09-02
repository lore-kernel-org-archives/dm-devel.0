From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/31] kpartx: helper functions for name and uuid
	generation
Date: Sun,  3 Sep 2017 00:38:31 +0200
Message-ID: <20170902223900.7339-3-mwilck@suse.com>
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

strip_slash() is copied from kpartx.c, and will be removed there
in a follow-up patch. The others are new helpers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 4ab58ce9..3d382285 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -92,6 +92,42 @@ out:
 	return r;
 }
 
+static void
+strip_slash (char * device)
+{
+	char * p = device;
+
+	while (*(p++) != 0x0) {
+
+		if (*p == '/')
+			*p = '!';
+	}
+}
+
+static int format_partname(char *buf, size_t bufsiz,
+			   const char *mapname, const char *delim, int part)
+{
+	if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part) >= bufsiz)
+		return 0;
+	strip_slash(buf);
+	return 1;
+}
+
+static char *make_prefixed_uuid(int part, const char *uuid)
+{
+	char *prefixed_uuid;
+	int len = MAX_PREFIX_LEN + strlen(uuid) + 1;
+
+	prefixed_uuid = malloc(len);
+	if (!prefixed_uuid) {
+		fprintf(stderr, "cannot create prefixed uuid : %s\n",
+			strerror(errno));
+		return NULL;
+	}
+	snprintf(prefixed_uuid, len, UUID_PREFIX "%s", part, uuid);
+	return prefixed_uuid;
+}
+
 int dm_addmap(int task, const char *name, const char *target,
 	      const char *params, uint64_t size, int ro, const char *uuid,
 	      int part, mode_t mode, uid_t uid, gid_t gid)
@@ -117,13 +153,9 @@ int dm_addmap(int task, const char *name, const char *target,
 			goto addout;
 
 	if (task == DM_DEVICE_CREATE && uuid) {
-		prefixed_uuid = malloc(MAX_PREFIX_LEN + strlen(uuid) + 1);
-		if (!prefixed_uuid) {
-			fprintf(stderr, "cannot create prefixed uuid : %s\n",
-				strerror(errno));
+		prefixed_uuid = make_prefixed_uuid(part, uuid);
+		if (prefixed_uuid == NULL)
 			goto addout;
-		}
-		sprintf(prefixed_uuid, UUID_PREFIX "%s", part, uuid);
 		if (!dm_task_set_uuid(dmt, prefixed_uuid))
 			goto addout;
 	}
-- 
2.14.0
