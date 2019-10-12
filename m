From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 07/72] libmultipath: lookup_binding(): don't rely
 on int overflow
Date: Sat, 12 Oct 2019 21:27:45 +0000
Message-ID: <20191012212703.12989-8-martin.wilck@suse.com>
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

lookup_binding() would return a negative result and issue an error
message if variable "id" became negative. But id is only incremented,
starting from 1. Relying on an int overflow is wrong, because the result
is undefined behavior in C. Also, an overflow might as well (actually, more
likely) occur if biggest_id == INT_MAX.

Also, lookup_binding() would return 0 both in an error case and if a
matching wwid was found. While the two cases could be distinguished
by checking if *map_alias was NULL after return, this is highly
non-standard and confusing. Return -1 in error case.

Because of the semantics of lookup_binding(), the test for "id" before calling
allocate_binding() in get_user_friendly_alias() is redundant.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index a96ba5cc..ac342a54 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -104,6 +104,13 @@ scan_devname(const char *alias, const char *prefix)
 	return n;
 }
 
+/*
+ * Returns: 0   if matching entry in WWIDs file found
+ *         -1   if an error occurs
+ *         >0   a free ID that could be used for the WWID at hand
+ * *map_alias is set to a freshly allocated string with the matching alias if
+ * the function returns 0, or to NULL otherwise.
+ */
 static int
 lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 	       const char *prefix)
@@ -130,8 +137,14 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 		if (!alias) /* blank line */
 			continue;
 		curr_id = scan_devname(alias, prefix);
-		if (curr_id == id)
-			id++;
+		if (curr_id == id) {
+			if (id < INT_MAX)
+				id++;
+			else {
+				id = -1;
+				break;
+			}
+		}
 		if (curr_id > biggest_id)
 			biggest_id = curr_id;
 		if (curr_id > id && curr_id < smallest_bigger_id)
@@ -147,20 +160,26 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 			condlog(3, "Found matching wwid [%s] in bindings file."
 				" Setting alias to %s", wwid, alias);
 			*map_alias = strdup(alias);
-			if (*map_alias == NULL)
+			if (*map_alias == NULL) {
 				condlog(0, "Cannot copy alias from bindings "
-					"file : %s", strerror(errno));
+					"file: out of memory");
+				return -1;
+			}
 			return 0;
 		}
 	}
-	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
+	if (id >= smallest_bigger_id) {
+		if (biggest_id < INT_MAX)
+			id = biggest_id + 1;
+		else
+			id = -1;
+	}
 	if (id < 0) {
 		condlog(0, "no more available user_friendly_names");
-		return 0;
-	}
-	if (id < smallest_bigger_id)
-		return id;
-	return biggest_id + 1;
+		return -1;
+	} else
+		condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
+	return id;
 }
 
 static int
@@ -363,7 +382,7 @@ get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
 		return NULL;
 	}
 
-	if (!alias && can_write && !bindings_read_only && id)
+	if (can_write && !bindings_read_only && !alias)
 		alias = allocate_binding(fd, wwid, id, prefix);
 
 	fclose(f);
-- 
2.23.0
