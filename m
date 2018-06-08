From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 15/28] libmultipath: merge hwentries inside a
	conf file
Date: Fri,  8 Jun 2018 12:20:28 +0200
Message-ID: <20180608102041.22904-16-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Merging hwentries with identical vendor/product/revision is still useful,
although it's not strictly necessary any more. But such identical entries
should always be merged, not only if they appear in different configuration
files. This requires changing the logic of factorize_hwtable.

By setting -DCHECK_BUILTIN_HWTABLE at compile time, the built-in hwtable
can be checked against duplicates as well.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 713ac7f3..fb41d620 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -452,7 +452,7 @@ out:
 }
 
 static void
-factorize_hwtable (vector hw, int n)
+factorize_hwtable (vector hw, int n, const char *table_desc)
 {
 	struct hwentry *hwe1, *hwe2;
 	int i, j;
@@ -462,22 +462,26 @@ restart:
 		if (i == n)
 			break;
 		j = n;
+		/* drop invalid device configs */
+		if (i >= n && (!hwe1->vendor || !hwe1->product)) {
+			condlog(0, "device config in %s missing vendor or product parameter",
+				table_desc);
+			vector_del_slot(hw, i--);
+			free_hwe(hwe1);
+			continue;
+		}
+		j = n > i + 1 ? n : i + 1;
 		vector_foreach_slot_after(hw, hwe2, j) {
-			/* drop invalid device configs */
-			if (!hwe2->vendor || !hwe2->product) {
-				condlog(0, "device config missing vendor or product parameter");
-				vector_del_slot(hw, j--);
-				free_hwe(hwe2);
-				continue;
-			}
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
-				condlog(4, "%s: removing hwentry %s:%s:%s",
+				condlog(i >= n ? 1 : 3,
+					"%s: duplicate device section for %s:%s:%s in %s",
 					__func__, hwe1->vendor, hwe1->product,
-					hwe1->revision);
+					hwe1->revision, table_desc);
 				vector_del_slot(hw, i);
 				merge_hwe(hwe2, hwe1);
 				free_hwe(hwe1);
-				n -= 1;
+				if (i < n)
+					n -= 1;
 				/*
 				 * Play safe here; we have modified
 				 * the original vector so the outer
@@ -605,9 +609,8 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 		snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]->d_name);
 		path[LINE_MAX-1] = '\0';
 		process_file(conf, path);
-		if (VECTOR_SIZE(conf->hwtable) > old_hwtable_size)
-			factorize_hwtable(conf->hwtable, old_hwtable_size);
-
+		factorize_hwtable(conf->hwtable, old_hwtable_size,
+				  namelist[i]->d_name);
 	}
 	pthread_cleanup_pop(1);
 }
@@ -655,6 +658,9 @@ load_config (char * file)
 	if (setup_default_hwtable(conf->hwtable))
 		goto out;
 
+#ifdef CHECK_BUILTIN_HWTABLE
+	factorize_hwtable(conf->hwtable, 0, "builtin");
+#endif
 	/*
 	 * read the config file
 	 */
@@ -668,14 +674,7 @@ load_config (char * file)
 			condlog(0, "error parsing config file");
 			goto out;
 		}
-		if (VECTOR_SIZE(conf->hwtable) > builtin_hwtable_size) {
-			/*
-			 * remove duplica in hwtable. config file
-			 * takes precedence over build-in hwtable
-			 */
-			factorize_hwtable(conf->hwtable, builtin_hwtable_size);
-		}
-
+		factorize_hwtable(conf->hwtable, builtin_hwtable_size, file);
 	}
 
 	conf->processed_main_config = 1;
-- 
2.17.0
