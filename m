From: Edward Goggin <egoggin@emc.com>
Subject: patch to fix locking bug in libmultipath/alias.c
Date: Mon, 17 Jul 2006 23:05:20 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E41491AF@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe,

The posix file byte range locks used to provide atomicity for accessing
the entries in the multipath bindings file get released from whenever
__any__ descriptor or FILE structure for that file is closed.  This
patch delays the fclose() for the FILE structures used within
lookup_binding() and rlookup_binding() until there is no more need for
the atomicity.

Without this patch I could fairly easily get two multipath mpath0
entries in /var/lib/multipath/bindings by running 8 concurrent instances
of multipath(8) while with the patch I cannot get this problem to occur.

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 6d103d7..86cae9b 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -166,28 +166,14 @@ fail:
=20
=20
 static int
-lookup_binding(int fd, char *map_wwid, char **map_alias)
+lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr =3D 0;
-	int scan_fd;
 	int id =3D 0;
=20
 	*map_alias =3D NULL;
-	scan_fd =3D dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f =3D fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor :
%s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -215,38 +201,22 @@ lookup_binding(int fd, char *map_wwid, c
 			if (*map_alias =3D=3D NULL)
 				condlog(0, "Cannot copy alias from
bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
-	fclose(f);
 	return id;
 }=09
=20
 static int
-rlookup_binding(int fd, char **map_wwid, char *map_alias)
+rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr =3D 0;
-	int scan_fd;
 	int id =3D 0;
=20
 	*map_wwid =3D NULL;
-	scan_fd =3D dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f =3D fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor :
%s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -274,12 +244,10 @@ rlookup_binding(int fd, char **map_wwid,
 			if (*map_wwid =3D=3D NULL)
 				condlog(0, "Cannot copy alias from
bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching alias [%s] in bindings file.",
map_alias);
-	fclose(f);
 	return id;
 }=09
=20
@@ -327,7 +295,8 @@ char *
 get_user_friendly_alias(char *wwid, char *file)
 {
 	char *alias;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
=20
 	if (!wwid || *wwid =3D=3D '\0') {
 		condlog(3, "Cannot find binding for empty WWID");
@@ -337,14 +306,37 @@ get_user_friendly_alias(char *wwid, char
 	fd =3D open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id =3D lookup_binding(fd, wwid, &alias);
+
+	scan_fd =3D dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f =3D fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor :
%s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id =3D lookup_binding(f, wwid, &alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
+
 	if (!alias)
 		alias =3D allocate_binding(fd, wwid, id);
=20
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return alias;
 }
@@ -353,7 +345,8 @@ char *
 get_user_friendly_wwid(char *alias, char *file)
 {
 	char *wwid;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
=20
 	if (!alias || *alias =3D=3D '\0') {
 		condlog(3, "Cannot find binding for empty alias");
@@ -363,12 +356,34 @@ get_user_friendly_wwid(char *alias, char
 	fd =3D open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id =3D rlookup_binding(fd, &wwid, alias);
+
+	scan_fd =3D dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f =3D fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor :
%s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id =3D rlookup_binding(f, &wwid, alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
=20
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return wwid;
 }
