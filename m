From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/2] multipathd: Avoid "socket operation on
	non-socket" errors
Date: Fri, 14 Oct 2016 08:34:26 -0700
Message-ID: <5e2dbb22-cfa0-28e4-bea7-ac0129c6b433@sandisk.com>
References: <a7920385-9f76-d029-48dd-31ebcb06a212@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a7920385-9f76-d029-48dd-31ebcb06a212@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Changing write_all() into write() is safe for files since the
POSIX standard guarantees that write() writes the entire buffer
except if the disk is full, a resource limit is encountered or
if interrupted by a signal. See also
http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html.

Fixes: commit 810082e7a8cf ("libmultipath, multipathd: Rework SIGPIPE handling")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/alias.c | 2 +-
 libmultipath/file.c  | 2 +-
 libmultipath/wwids.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index b86843a..12afef8 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -219,7 +219,7 @@ allocate_binding(int fd, char *wwid, int id, char *prefix)
 			strerror(errno));
 		return NULL;
 	}
-	if (write_all(fd, buf, strlen(buf)) != strlen(buf)){
+	if (write(fd, buf, strlen(buf)) != strlen(buf)){
 		condlog(0, "Cannot write binding to bindings file : %s",
 			strerror(errno));
 		/* clear partial write */
diff --git a/libmultipath/file.c b/libmultipath/file.c
index 74cde64..e4951c9 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -158,7 +158,7 @@ open_file(char *file, int *can_write, char *header)
 			goto fail;
 		/* If file is empty, write the header */
 		size_t len = strlen(header);
-		if (write_all(fd, header, len) != len) {
+		if (write(fd, header, len) != len) {
 			condlog(0,
 				"Cannot write header to file %s : %s", file,
 				strerror(errno));
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index babf149..bc70a27 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -71,7 +71,7 @@ write_out_wwid(int fd, char *wwid) {
 			strerror(errno));
 		return -1;
 	}
-	if (write_all(fd, buf, strlen(buf)) != strlen(buf)) {
+	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
 		condlog(0, "cannot write wwid to wwids file : %s",
 			strerror(errno));
 		if (ftruncate(fd, offset))
@@ -110,7 +110,7 @@ replace_wwids(vector mp)
 		goto out_file;
 	}
 	len = strlen(WWIDS_FILE_HEADER);
-	if (write_all(fd, WWIDS_FILE_HEADER, len) != len) {
+	if (write(fd, WWIDS_FILE_HEADER, len) != len) {
 		condlog(0, "Can't write wwid file header : %s",
 			strerror(errno));
 		/* cleanup partially written header */
-- 
2.10.0
