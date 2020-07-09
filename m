From: mwilck@suse.com
Subject: [PATCH 70/74] libmultipath: disassemble_map(): do not
	change pathvec and WWIDs
Date: Thu,  9 Jul 2020 12:51:41 +0200
Message-ID: <20200709105145.9211-18-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

After introducing update_pathvec_from_dm() in a predecessor patch,
the "layer violations" in disassemble_map() can now be removed.
I hope this clarifies program logic a little bit.

Callers need to call update_pathvec_from_dm() after disassemble_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c    | 48 +++++---------------------------------
 libmultipath/structs_vec.c |  3 +++
 2 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 233a1b8..e629a89 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -122,6 +122,12 @@ err:
 
 #undef APPEND
 
+/*
+ * Caution callers: If this function encounters yet unkown path devices, it
+ * adds them uninitialized to the mpp.
+ * Call update_pathvec_from_dm() after this function to make sure
+ * all data structures are in a sane state.
+ */
 int disassemble_map(vector pathvec, char *params, struct multipath *mpp)
 {
 	char * word;
@@ -282,20 +288,12 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp)
 		FREE(word);
 
 		for (j = 0; j < num_paths; j++) {
-			char devname[FILE_NAME_SIZE];
-
 			pp = NULL;
 			p += get_word(p, &word);
 
 			if (!word)
 				goto out;
 
-			if (devt2devname(devname, FILE_NAME_SIZE, word)) {
-				condlog(2, "%s: cannot find block device",
-					word);
-				devname[0] = '\0';
-			}
-
 			pp = find_path_by_devt(pathvec, word);
 
 			if (!pp) {
@@ -305,46 +303,12 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp)
 					goto out1;
 
 				strlcpy(pp->dev_t, word, BLK_DEV_SIZE);
-				strlcpy(pp->dev, devname, FILE_NAME_SIZE);
-				if (strlen(mpp->wwid)) {
-					strlcpy(pp->wwid, mpp->wwid,
-						WWID_SIZE);
-				}
-				if (store_path(pathvec, pp))
-					goto out1;
-			} else {
-				if (!strlen(pp->wwid) &&
-				    strlen(mpp->wwid))
-					strlcpy(pp->wwid, mpp->wwid,
-						WWID_SIZE);
 			}
 			FREE(word);
 
 			if (store_path(pgp->paths, pp))
 				goto out;
 
-			/*
-			 * Update wwid for multipaths which are not setup
-			 * in the get_dm_mpvec() code path
-			 */
-			if (!strlen(mpp->wwid))
-				strlcpy(mpp->wwid, pp->wwid, WWID_SIZE);
-
-			/*
-			 * Update wwid for paths which may not have been
-			 * active at the time the getuid callout was run
-			 */
-			else if (!strlen(pp->wwid))
-				strlcpy(pp->wwid, mpp->wwid, WWID_SIZE);
-
-			/*
-			 * Do not allow in-use patch to change wwid
-			 */
-			else if (strcmp(pp->wwid, mpp->wwid) != 0) {
-				condlog(0, "%s: path wwid appears to have changed. Using map wwid.\n", pp->dev_t);
-				strlcpy(pp->wwid, mpp->wwid, WWID_SIZE);
-			}
-
 			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 73a7221..2ddb8cd 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -389,6 +389,9 @@ update_multipath_table (struct multipath *mpp, vector pathvec)
 		return DMP_ERR;
 	}
 
+	/* FIXME: we should deal with the return value here */
+	update_pathvec_from_dm(pathvec, mpp, 0);
+
 	return DMP_OK;
 }
 
-- 
2.26.2
