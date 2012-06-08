From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: remove unnecessary fds from alias code
Date: Fri, 8 Jun 2012 12:28:28 -0500
Message-ID: <20120608172828.GD3211@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Originally, the alias code duped the bindings file fd so that a stream could
be opened on it, and then closed without closing the original fd. Later,
closing the stream was moved to the end of the function, to avoid a locking
bug.  Because of this, there isn't any point to duping the fd.  Also, since
the stream is still opened when the original fd is used, the stream
should be flushed after its done being used.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c |   41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

Index: multipath-tools-120518/libmultipath/alias.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/alias.c
+++ multipath-tools-120518/libmultipath/alias.c
@@ -361,7 +361,7 @@ get_user_friendly_alias(char *wwid, char
 			int bindings_read_only)
 {
 	char *alias;
-	int fd, scan_fd, id;
+	int fd, id;
 	FILE *f;
 	int can_write;
 
@@ -374,19 +374,10 @@ get_user_friendly_alias(char *wwid, char
 	if (fd < 0)
 		return NULL;
 
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		close(fd);
-		return NULL;
-	}
-
-	f = fdopen(scan_fd, "r");
+	f = fdopen(fd, "r");
 	if (!f) {
 		condlog(0, "cannot fdopen on bindings file descriptor : %s",
 			strerror(errno));
-		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
@@ -394,8 +385,13 @@ get_user_friendly_alias(char *wwid, char
 	id = lookup_binding(f, wwid, &alias, prefix);
 	if (id < 0) {
 		fclose(f);
-		close(scan_fd);
-		close(fd);
+		return NULL;
+	}
+
+	if (fflush(f) != 0) {
+		condlog(0, "cannot fflush bindings file stream : %s",
+			strerror(errno));
+		fclose(f);
 		return NULL;
 	}
 
@@ -403,8 +399,6 @@ get_user_friendly_alias(char *wwid, char
 		alias = allocate_binding(fd, wwid, id, prefix);
 
 	fclose(f);
-	close(scan_fd);
-	close(fd);
 	return alias;
 }
 
@@ -412,7 +406,7 @@ char *
 get_user_friendly_wwid(char *alias, char *file)
 {
 	char *wwid;
-	int fd, scan_fd, id, unused;
+	int fd, id, unused;
 	FILE *f;
 
 	if (!alias || *alias == '\0') {
@@ -424,19 +418,10 @@ get_user_friendly_wwid(char *alias, char
 	if (fd < 0)
 		return NULL;
 
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		close(fd);
-		return NULL;
-	}
-
-	f = fdopen(scan_fd, "r");
+	f = fdopen(fd, "r");
 	if (!f) {
 		condlog(0, "cannot fdopen on bindings file descriptor : %s",
 			strerror(errno));
-		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
@@ -444,13 +429,9 @@ get_user_friendly_wwid(char *alias, char
 	id = rlookup_binding(f, &wwid, alias);
 	if (id < 0) {
 		fclose(f);
-		close(scan_fd);
-		close(fd);
 		return NULL;
 	}
 
 	fclose(f);
-	close(scan_fd);
-	close(fd);
 	return wwid;
 }
