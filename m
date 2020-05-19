From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 6/6] libmultipath: use atomic linkat() in
	mark_failed_wwid()
Date: Mon, 18 May 2020 23:57:08 -0500
Message-ID: <1589864228-1363-7-git-send-email-bmarzins@redhat.com>
References: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This keeps (almost) the simplicity of the previous patch, while
making sure that the return value of mark_failed_wwid()
(WWID_FAILED_CHANGED vs. WWID_FAILED_UNCHANGED) is correct, even
if several processes access this WWID at the same time.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/wwids.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index da55924b..c7a16636 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -374,7 +374,7 @@ int is_failed_wwid(const char *wwid)
 
 	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
 		condlog(1, "%s: path name overflow", __func__);
-		return -1;
+		return WWID_FAILED_ERROR;
 	}
 
 	if (lstat(path, &st) == 0)
@@ -390,27 +390,43 @@ int is_failed_wwid(const char *wwid)
 
 int mark_failed_wwid(const char *wwid)
 {
-	char path[PATH_MAX];
-	int r, fd;
+	char tmpfile[WWID_SIZE + 2 * sizeof(long) + 1];
+	int r = WWID_FAILED_ERROR, fd, dfd;
 
-	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
-		condlog(1, "%s: path name overflow", __func__);
-		return -1;
+	dfd = open(shm_dir, O_RDONLY|O_DIRECTORY);
+	if (dfd == -1 && errno == ENOENT) {
+		char path[sizeof(shm_dir) + 2];
+
+		/* arg for ensure_directories_exist() must not end with "/" */
+		safe_sprintf(path, "%s/_", shm_dir);
+		ensure_directories_exist(path, 0700);
+		dfd = open(shm_dir, O_RDONLY|O_DIRECTORY);
 	}
-	if (ensure_directories_exist(path, 0700) < 0) {
-		condlog(1, "%s: can't setup directories", __func__);
-		return -1;
+	if (dfd == -1) {
+		condlog(1, "%s: can't setup %s: %m", __func__, shm_dir);
+		return WWID_FAILED_ERROR;
 	}
 
-	fd = open(path, O_RDONLY | O_CREAT | O_EXCL, S_IRUSR);
-	if (fd >= 0) {
+	safe_sprintf(tmpfile, "%s.%lx", wwid, (long)getpid());
+	fd = openat(dfd, tmpfile, O_RDONLY | O_CREAT | O_EXCL, S_IRUSR);
+	if (fd >= 0)
 		close(fd);
+	else
+		goto out_closedir;
+
+	if (linkat(dfd, tmpfile, dfd, wwid, 0) == 0)
 		r = WWID_FAILED_CHANGED;
-	} else if (errno == EEXIST)
+	else if (errno == EEXIST)
 		r = WWID_FAILED_UNCHANGED;
 	else
 		r = WWID_FAILED_ERROR;
 
+	if (unlinkat(dfd, tmpfile, 0) == -1)
+		condlog(2, "%s: failed to unlink %s/%s: %m",
+			__func__, shm_dir, tmpfile);
+
+out_closedir:
+	close(dfd);
 	print_failed_wwid_result("mark_failed", wwid, r);
 	return r;
 }
@@ -422,7 +438,7 @@ int unmark_failed_wwid(const char *wwid)
 
 	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
 		condlog(1, "%s: path name overflow", __func__);
-		return -1;
+		return WWID_FAILED_ERROR;
 	}
 
 	if (unlink(path) == 0)
-- 
2.17.2
